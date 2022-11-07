import 'package:books_finder/books_finder.dart' as books_finder;
import 'package:cloud_firestore/cloud_firestore.dart' hide Transaction;
import 'package:cloud_functions/cloud_functions.dart';
import 'package:get/get.dart';
import 'package:livrodin/configs/constants.dart';
import 'package:livrodin/controllers/auth_controller.dart';
import 'package:livrodin/models/availability.dart';
import 'package:livrodin/models/discussion.dart';
import 'package:livrodin/models/interest.dart';
import 'package:livrodin/models/rating.dart';
import 'package:livrodin/models/transaction.dart';
import 'package:livrodin/models/user.dart';

import '../models/book.dart';

class BookService extends GetxService {
  var authController = Get.find<AuthController>();
  final FirebaseFirestore firestore;

  BookService({required this.firestore});

  Future<List<Book>> searchBooksOnGoogleApi(String query) async {
    var results = await books_finder.queryBooks(query,
        maxResults: 10,
        langRestrict: "pt,en",
        orderBy: books_finder.OrderBy.relevance);
    return results.map(Book.fromApi).toList();
  }

  Future<void> addBookAvailable(
      Book book, BookAvailableType offerStatus) async {
    if (authController.user.value == null) throw 'User not logged in';

    await firestore.collection("BookAvailable").doc().set(
          book.toFireStore(
            idUser: authController.user.value!.uid,
            availableType: offerStatus,
          ),
        );
  }

  Future<void> addRate(
      {required Book book, required int rate, required String comment}) async {
    if (authController.user.value == null) throw 'User not logged in';

    await firestore.collection("BookRate").doc().set({
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

  Future<List<Book>> getAvailableBooks({int? limit, int? page}) async {
    List<Book> books = List.empty(growable: true);
    var result = await firestore
        .collection("Book")
        .where(
          "lastAvailabilityUpdated",
          isNull: false,
        )
        .orderBy("lastAvailabilityUpdated", descending: true)
        .limit(limit ?? 100)
        .get();
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
                    : BookAvailableType.both,
          ),
        );
      }
    }

    return books;
  }

  Future<List<Book>> getBooksRatingByUser() async {
    if (authController.user.value == null) throw 'User not logged in';

    var result = await firestore
        .collection("BookRate")
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
            user: User(id: authController.user.value!.uid, name: "Eu"),
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
        .collection("BookAvailable")
        .where("idUser", isEqualTo: authController.user.value!.uid)
        .get();

    return result.docs.map((e) {
      var data = e.data();
      var book = Book(
          id: data["idBook"], title: data["title"], coverUrl: data["coverUrl"]);
      var availability = Availability(
        id: e.id,
        book: book,
        user: User(id: authController.user.value!.uid, name: "Eu"),
        dateAvailable: data["createdAt"].toDate(),
        availableType: data["forDonation"] && data["forTrade"]
            ? BookAvailableType.both
            : (data["forDonation"]
                ? BookAvailableType.donate
                : BookAvailableType.trade),
      );
      book.availabilities = [availability];
      return availability;
    }).toList();
  }

  Future<List<Rating>> getBookRating(String idBook) async {
    var result = await firestore
        .collection("BookRate")
        .where("idBook", isEqualTo: idBook)
        .get();
    List<Rating> ratings = List.empty(growable: true);

    var users = await _getUsersByIds(
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
        .collection("InterestList")
        .where("idUser", isEqualTo: authController.user.value!.uid)
        .get();

    return result.docs.map(
      (e) {
        var data = e.data();
        return Interest(
          id: e.id,
          book: Book(
            id: data["idBook"],
            title: data["nameBook"],
            coverUrl: data["coverUrl"],
          ),
        );
      },
    ).toList();
  }

  Future<List<User>> _getUsersByIds(List<String> ids) async {
    if (ids.isEmpty) return [];
    var result = await firestore
        .collection("Users")
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

  Future<List<Book>> _getBooksByIds(List<String> ids) async {
    if (ids.isEmpty) return [];
    var result = await firestore
        .collection("Book")
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
        .collection("BookAvailable")
        .where("idBook", isEqualTo: idBook)
        .where("idUser", isNotEqualTo: authController.user.value?.uid)
        .get();

    List<Availability> availabilities = List.empty(growable: true);

    var users = await _getUsersByIds(
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
          dateAvailable: data["createdAt"].toDate(),
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
    var users = await _getUsersByIds(usersIds.toSet().toList());

    // get all books from transactions
    var books = await _getBooksByIds(booksIds.toSet().toList());

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
          book2: data["book2Id"] != null
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
      "transactionId": transactionId.toString(),
      "availability2Id": availability2Id
    };

    var result = await callable.call<Map<String, dynamic>>(request);
    if (result.data["error"]) {
      throw result.data["message"];
    }
  }

  Future<void> cancelTransaction(String transactionId) async {
    if (authController.user.value == null) throw 'User not logged in';

    HttpsCallable callable =
        FirebaseFunctions.instanceFor(region: 'southamerica-east1')
            .httpsCallable('cancelTransaction');
    var request = <String, dynamic>{"transactionId": transactionId.toString()};

    var result = await callable.call<Map<String, dynamic>>(request);
    if (result.data["error"]) {
      throw result.data["message"];
    }
  }

  Future<List<Discussion>> getBookDiscussions(String idBook) async {
    var result = await firestore
        .collection(collectionBooks)
        .doc(idBook)
        .collection(collectionDiscussions)
        .get();

    List<Discussion> discussions = List.empty(growable: true);

    var users = await _getUsersByIds(
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
        Discussion(
          id: doc.id,
          user: user,
          title: data["title"],
        ),
      );
    }

    return discussions;
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
        .add({
      "idUser": authController.user.value!.uid,
      "title": discussion.title,
      "createdAt": FieldValue.serverTimestamp(),
      "mensagens": [],
    });
  }
}
