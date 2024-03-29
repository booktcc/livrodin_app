import 'package:books_finder/books_finder.dart' as books_finder;
import 'package:cloud_firestore/cloud_firestore.dart' hide Transaction;
import 'package:cloud_functions/cloud_functions.dart';
import 'package:get/get.dart';
import 'package:livrodin/configs/constants.dart';
import 'package:livrodin/controllers/auth_controller.dart';
import 'package:livrodin/models/Genrer.dart';
import 'package:livrodin/models/availability.dart';
import 'package:livrodin/models/discussion.dart';
import 'package:livrodin/models/interest.dart';
import 'package:livrodin/models/rating.dart';
import 'package:livrodin/models/reply.dart';
import 'package:livrodin/models/transaction.dart';
import 'package:livrodin/models/user.dart';

import '../models/book.dart';

class BookService extends GetxService {
  var authController = Get.find<AuthController>();
  final FirebaseFirestore firestore;

  BookService({required this.firestore});

  Future<List<Book>> searchBooksOnGoogleApi(
    String query, {
    int maxResults = 10,
    int startIndex = 0,
  }) async {
    var results = await books_finder.queryBooks(
      query,
      startIndex: startIndex,
      maxResults: maxResults,
      printType: books_finder.PrintType.books,
      orderBy: books_finder.OrderBy.relevance,
    );
    return results.map(Book.fromApi).toList();
  }

  Future<Book> getBookOnGoogleApi(String bookId) async {
    var result = await books_finder.getSpecificBook(bookId);

    return Book.fromApi(result);
  }

  Future<List<Genrer>> getGenres() async {
    var result = await firestore.collection(collectionGenres).get();
    return result.docs.map(Genrer.fromFirestore).toList();
  }

  Future<void> addBookAvailable(
      Book book, BookAvailableType offerStatus) async {
    if (authController.user.value == null) throw 'User not logged in';

    await firestore.collection(collectionAvailable).doc().set(
          book.toFireStore(
            idUser: authController.user.value!.uid,
            availableType: offerStatus,
          ),
        );
  }

  Future<void> addRate(
      {required Book book, required int rate, required String comment}) async {
    if (authController.user.value == null) throw 'User not logged in';

    await firestore.collection(collectionRatings).doc().set({
      "idBook": book.id,
      "nameBook": book.title,
      "coverUrl": book.coverUrl,
      "idUser": authController.user.value!.uid,
      "rate": rate,
      "comment": comment.trim().isNotEmpty ? comment : null,
      "createdAt": FieldValue.serverTimestamp(),
      "updatedAt": FieldValue.serverTimestamp(),
    });
  }

  Future<List<Book>> getAvailableBooks(
      {List<String>? booksIds, int? limit, int? page}) async {
    List<Book> books = List.empty(growable: true);
    late QuerySnapshot<Map<String, dynamic>> result;
    if (booksIds != null) {
      if (booksIds.isEmpty) return [];
      result = await firestore
          .collection("Book")
          .where(FieldPath.documentId, whereIn: booksIds)
          .get();
    } else {
      result = await firestore
          .collection("Book")
          .where(
            "lastAvailabilityUpdated",
            isNull: false,
          )
          .orderBy("lastAvailabilityUpdated", descending: true)
          .limit(limit ?? 100)
          .get();
    }
    for (var doc in result.docs) {
      var data = doc.data();
      if (!books.any((element) => element.id == data["idBook"])) {
        books.add(
          Book(
            id: doc.id,
            title: data['title'],
            coverUrl: data['coverUrl'],
            // can be null
            availableType: data['availableType'] == "FOR_TRADE"
                ? BookAvailableType.trade
                : data['availableType'] == "FOR_DONATION"
                    ? BookAvailableType.donate
                    : data['availableType'] != null
                        ? BookAvailableType.both
                        : null,
          ),
        );
      }
    }

    return books;
  }

  Future<List<Book>> getBooksRatingByUser() async {
    if (authController.user.value == null) throw 'User not logged in';

    var result = await firestore
        .collection(collectionRatings)
        .where("idUser", isEqualTo: authController.user.value!.uid)
        .get();

    return result.docs.map((e) {
      var data = e.data();
      return Book(
        id: data["idBook"],
        title: data["nameBook"],
        coverUrl: data["coverUrl"],
        ratings: [
          Rating(
            id: e.id,
            user: User(
                id: authController.user.value!.uid,
                name: "Eu",
                profilePictureUrl: authController.user.value?.photoURL),
            rating: data["rate"],
            comment: data["comment"] ?? "",
          )
        ],
      );
    }).toList();
  }

  Future<List<Availability>> getMadeAvailableList() async {
    if (authController.user.value == null) throw 'User not logged in';

    var result = await firestore
        .collection(collectionAvailable)
        .where("idUser", isEqualTo: authController.user.value!.uid)
        .get();

    var books = await getAvailableBooks(
        booksIds:
            result.docs.map((e) => (e.data()["idBook"] as String)).toList());
    return result.docs.map((e) {
      var data = e.data();

      var book = books.firstWhere((element) => element.id == data["idBook"]);
      var availability = Availability(
        id: e.id,
        book: book,
        user: User(id: authController.user.value!.uid, name: "Eu"),
        createdAt: data["createdAt"].toDate(),
        availableType: data['availableType'] == "FOR_TRADE"
            ? BookAvailableType.trade
            : data['availableType'] == "FOR_DONATION"
                ? BookAvailableType.donate
                : BookAvailableType.both,
      );
      book.availabilities = [availability];
      return availability;
    }).toList();
  }

  Future<List<Rating>> getBookRating(String idBook) async {
    var result = await firestore
        .collection(collectionRatings)
        .where("idBook", isEqualTo: idBook)
        .get();
    List<Rating> ratings = List.empty(growable: true);

    var users = await getUsersByIds(
        result.docs.map((e) => (e.data()["idUser"] as String)).toList());

    for (var doc in result.docs) {
      var data = doc.data();
      if (authController.user.value != null &&
          authController.user.value!.uid == data["idUser"]) {
        ratings.insert(
          0,
          Rating(
            id: doc.id,
            user: User(
              id: authController.user.value!.uid,
              name: "Eu",
              profilePictureUrl: authController.user.value!.photoURL,
            ),
            rating: data['rate'],
            comment: data['comment'] ?? "",
          ),
        );
      } else {
        final user = users.firstWhere(
          (element) => element.id == data["idUser"],
          orElse: () => User(id: "", name: "Usuário"),
        );
        ratings.add(
          Rating(
            id: doc.id,
            user: user,
            rating: data['rate'],
            comment: data['comment'] ?? "",
          ),
        );
      }
    }
    return ratings;
  }

  Future<List<Interest>> getInterestList() async {
    if (authController.user.value == null) throw 'User not logged in';

    var result = await firestore
        .collection(collectionUsers)
        .doc(authController.user.value!.uid)
        .collection(collectionInterestList)
        .get();

    return result.docs
        .map(
          (e) => Interest(
            id: e.id,
            book: Book(
              id: e.id,
              title: e.data()["name"],
              coverUrl: e.data()["coverUrl"],
            ),
          ),
        )
        .toList();
  }

  Future<List<User>> getUsersByIds(List<String> ids) async {
    if (ids.isEmpty) return [];
    var result = await firestore
        .collection(collectionUsers)
        .where(FieldPath.documentId, whereIn: ids)
        .get();

    return result.docs.map((e) {
      var data = e.data();
      return User(
        id: e.id,
        name: data["name"],
        profilePictureUrl: data["profilePictureUrl"],
        isMe: authController.user.value!.uid == e.id,
      );
    }).toList();
  }

  Future<List<Book>> getBooksByIds(List<String> ids) async {
    if (ids.isEmpty) return [];
    var result = await firestore
        .collection(collectionBooks)
        .where(FieldPath.documentId, whereIn: ids)
        .get();

    return result.docs.map((e) {
      var data = e.data();
      return Book(
        id: e.id,
        title: data["title"],
        coverUrl: data["coverUrl"],
      );
    }).toList();
  }

  Future<List<Availability>> getBookAvailabityById(String idBook) async {
    var result = await firestore
        .collection(collectionAvailable)
        .where("idBook", isEqualTo: idBook)
        .where("idUser", isNotEqualTo: authController.user.value?.uid)
        .get();

    List<Availability> availabilities = List.empty(growable: true);

    var users = await getUsersByIds(
        result.docs.map((e) => (e.data()["idUser"] as String)).toList());

    for (var doc in result.docs) {
      var data = doc.data();
      var user = users.firstWhere(
        (element) => element.id == data["idUser"],
        orElse: () => User(
          id: "",
          name: "Usuário",
        ),
      );
      availabilities.add(
        Availability(
          id: doc.id,
          book: Book(
            id: data["idBook"],
            title: data["title"],
            coverUrl: data["coverUrl"],
          ),
          user: user,
          createdAt: data["createdAt"].toDate(),
          availableType: data["availableType"] == "FOR_TRADE"
              ? BookAvailableType.trade
              : data["availableType"] == "FOR_DONATION"
                  ? BookAvailableType.donate
                  : BookAvailableType.both,
        ),
      );
    }

    return availabilities;
  }

  Future<void> requestBook(
      String availabilityId, TransactionType availableType) async {
    if (authController.user.value == null) throw 'User not logged in';
    HttpsCallable callable =
        FirebaseFunctions.instanceFor(region: 'southamerica-east1')
            .httpsCallable('createTransaction');
    var request = <String, dynamic>{
      "availabilityId": availabilityId.toString(),
      "type": availableType.value.toString()
    };

    var result = await callable.call<Map<String, dynamic>>(request);
    if (result.data["error"]) {
      throw result.data["message"];
    }
  }

  Future<List<Transaction>> getTransactionsFromUser() async {
    if (authController.user.value == null) throw 'User not logged in';

    var resultTransactions1 = await firestore
        .collection(collectionTransaction)
        .where("user1Id", isEqualTo: authController.user.value!.uid)
        .get();
    var resultTransactions2 = await firestore
        .collection(collectionTransaction)
        .where("user2Id", isEqualTo: authController.user.value!.uid)
        .get();

    var resultTransactionsDocs =
        (resultTransactions1.docs + resultTransactions2.docs);

    List<Transaction> transactions = List.empty(growable: true);
    List<String> usersIds = List.empty(growable: true);
    List<String> booksIds = List.empty(growable: true);

    for (var doc in resultTransactionsDocs) {
      var data = doc.data();
      usersIds.add(data["user1Id"]);
      usersIds.add(data["user2Id"]);
      booksIds.add(data["idBook1"]);
      if (data["idBook2"] != null) booksIds.add(data["idBook2"]);
    }

    // get all users from transactions
    var users = await getUsersByIds(usersIds.toSet().toList());

    // get all books from transactions
    var books = await getBooksByIds(booksIds.toSet().toList());

    for (var doc in resultTransactionsDocs) {
      var data = doc.data();

      transactions.add(
        Transaction(
          id: doc.id,
          book1: books.firstWhere(
            (element) => element.id == data["idBook1"],
            orElse: () => Book(
              id: "",
              title: "Livro",
            ),
          ),
          book2: data["idBook2"] != null
              ? books.firstWhere(
                  (element) => element.id == data["idBook2"],
                  orElse: () => Book(
                    id: "",
                    title: "Livro",
                  ),
                )
              : null,
          user1: users.firstWhere(
            (element) => element.id == data["user1Id"],
            orElse: () => User(
              id: "",
              name: "Usuário",
            ),
          ),
          user2: users.firstWhere(
            (element) => element.id == data["user2Id"],
            orElse: () => User(
              id: "",
              name: "Usuário",
            ),
          ),
          createdAt: data["createdAt"].toDate(),
          updatedAt: data["updatedAt"].toDate(),
          status: TransactionStatus.values.firstWhere(
            (element) => element.value == data["status"],
            orElse: () => TransactionStatus.pending,
          ),
          type: TransactionType.values.firstWhere(
            (element) => element.value == data["type"],
            orElse: () => TransactionType.trade,
          ),
          user1Confirm: data["user1Confirm"],
          user2Confirm: data["user2Confirm"],
        ),
      );
    }
    // order by date
    transactions.sort((a, b) => b.createdAt.compareTo(a.createdAt));

    return transactions;
  }

  Future<void> confirmTransaction(
      String transactionId, String? availability2Id) async {
    if (authController.user.value == null) throw 'User not logged in';

    HttpsCallable callable =
        FirebaseFunctions.instanceFor(region: 'southamerica-east1')
            .httpsCallable('confirmTransaction');
    var request = <String, dynamic>{
      "transactionId": transactionId,
      "availability2Id": availability2Id
    };

    var result = await callable.call<Map<String, dynamic>>(request);
    if (result.data["error"]) {
      throw result.data["message"];
    }
  }

  Future<String> completeTransaction(String transactionId) async {
    if (authController.user.value == null) throw 'User not logged in';

    HttpsCallable callable =
        FirebaseFunctions.instanceFor(region: 'southamerica-east1')
            .httpsCallable('completeTransaction');
    var request = <String, dynamic>{
      "transactionId": transactionId,
    };

    var result = await callable.call<Map<String, dynamic>>(request);
    if (result.data["error"]) {
      throw result.data["message"];
    }

    return result.data["message"];
  }

  Future<void> cancelTransaction(String transactionId) async {
    if (authController.user.value == null) throw 'User not logged in';

    HttpsCallable callable =
        FirebaseFunctions.instanceFor(region: 'southamerica-east1')
            .httpsCallable('cancelTransaction');
    var request = <String, dynamic>{"transactionId": transactionId};

    var result = await callable.call<Map<String, dynamic>>(request);
    if (result.data["error"]) {
      throw result.data["message"];
    }
  }

  Future<void> sendTransactionMessage(
      String transactionId, String message) async {
    if (authController.user.value == null) throw 'User not logged in';

    HttpsCallable callable =
        FirebaseFunctions.instanceFor(region: 'southamerica-east1')
            .httpsCallable('sendTransactionMessage');
    var request = <String, dynamic>{
      "transactionId": transactionId,
      "message": message
    };

    var result = await callable.call<Map<String, dynamic>>(request);
    if (result.data["error"]) {
      throw result.data["message"];
    }
  }

  Future<List<Discussion>> getBookDiscussions(Book book) async {
    var result = await firestore
        .collection(collectionBooks)
        .doc(book.id)
        .collection(collectionDiscussions)
        .get();

    List<Discussion> discussions = List.empty(growable: true);

    var users = await getUsersByIds(
        result.docs.map((e) => (e.data()["idUser"] as String)).toList());

    for (var doc in result.docs) {
      var data = doc.data();
      var user = users.firstWhere(
        (element) => element.id == data["idUser"],
        orElse: () => User(
          id: "",
          name: "Usuário",
        ),
      );
      discussions.add(
        Discussion.fromFirestore(doc, user, book),
      );
    }

    return discussions;
  }

  // fetch discussion replies
  Future<List<Reply>> getDiscussionReplies(Discussion discussion) async {
    var result = await firestore
        .collection(collectionBooks)
        .doc(discussion.book.id)
        .collection(collectionDiscussions)
        .doc(discussion.id)
        .collection(collectionReplies)
        .get();

    List<Reply> replies = List.empty(growable: true);

    var users = await getUsersByIds(
        result.docs.map((e) => (e.data()["idUser"] as String)).toList());

    for (var doc in result.docs) {
      var data = doc.data();
      var user = users.firstWhere(
        (element) => element.id == data["idUser"],
        orElse: () => User(
          id: "",
          name: "Usuário",
        ),
      );
      replies.add(
        Reply.fromFirestore(doc, discussion, user),
      );
    }

    return replies;
  }

  Future<void> addDiscussion({
    required Book book,
    required Discussion discussion,
  }) async {
    if (authController.user.value == null) throw 'User not logged in';
    await firestore
        .collection(collectionBooks)
        .doc(book.id)
        .collection(collectionDiscussions)
        .add(discussion.toFirestore());
  }

  Future<void> createDiscussionReply(
      {required Book book,
      required Reply reply,
      required Discussion parentDiscussion}) async {
    if (authController.user.value == null) throw 'User not logged in';
    await firestore
        .collection(collectionBooks)
        .doc(book.id)
        .collection(collectionDiscussions)
        .doc(parentDiscussion.id)
        .collection(collectionReplies)
        .add(reply.toFirestore());
  }

  Future<List<Book>> getRecomendBooks() async {
    var result = await firestore.collection(collectionRatings).get();

    List<Book> books = List.empty(growable: true);

    for (var doc in result.docs) {
      var data = doc.data();
      var book =
          books.firstWhereOrNull((element) => element.id == data["idBook"]);
      if (book == null) {
        book = Book(
          id: data["idBook"],
          title: data["nameBook"],
          coverUrl: data["coverUrl"],
        );
        books.add(book);
      }
      book.ratings = [
        ...book.ratings,
        ...[
          Rating(
            id: doc.id,
            user: User(id: "", name: "Usuário"),
            rating: data["rate"],
            comment: data["comment"],
          )
        ]
      ];
    }
    books.sort((a, b) => b.averageRating.compareTo(a.averageRating));
    return books;
  }

  Future<List<Availability>> getAvailableBooksFromUser(User user) async {
    if (authController.user.value == null) throw 'User not logged in';

    var availability = await firestore
        .collection(collectionAvailable)
        .where("idUser", isEqualTo: user.id)
        .where("availableType", whereIn: [
      BookAvailableType.both.value,
      BookAvailableType.trade.value,
    ]).get();

    List<String> bookIds = List.empty(growable: true);

    for (var doc in availability.docs) {
      bookIds.add(doc.data()["idBook"]);
    }

    var books = await getBooksByIds(bookIds);

    List<Availability> availableBooks = List.empty(growable: true);

    for (var doc in availability.docs) {
      var data = doc.data();
      availableBooks.add(
        Availability(
          id: doc.id,
          book: books.firstWhere(
            (element) => element.id == data["idBook"],
            orElse: () => Book(
              id: "",
              title: "Livro",
            ),
          ),
          availableType: BookAvailableType.values.firstWhere(
            (element) => element.value == data["availableType"],
            orElse: () => BookAvailableType.both,
          ),
          createdAt: data["createdAt"].toDate(),
          user: user,
        ),
      );
    }

    return availableBooks;
  }

  Future<bool> isUserBookInterest(String idBook) async {
    if (authController.user.value == null) throw 'User not logged in';

    var result = await firestore
        .collection(collectionUsers)
        .doc(authController.user.value!.uid)
        .collection(collectionInterestList)
        .doc(idBook)
        .get();
    return result.exists;
  }

  Future<void> addBookToInterestList(Book book) async {
    if (authController.user.value == null) throw 'User not logged in';

    await firestore
        .collection(collectionUsers)
        .doc(authController.user.value!.uid)
        .collection(collectionInterestList)
        .doc(book.id)
        .set({"name": book.title, "coverUrl": book.coverUrl});
  }

  removeBookOfInterestList(String idBook) {
    if (authController.user.value == null) throw 'User not logged in';

    firestore
        .collection(collectionUsers)
        .doc(authController.user.value!.uid)
        .collection(collectionInterestList)
        .doc(idBook)
        .delete();
  }
}
