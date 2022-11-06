import 'dart:developer';

import 'package:books_finder/books_finder.dart' as books_finder;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:get/get.dart';
import 'package:livrodin/controllers/auth_controller.dart';
import 'package:livrodin/models/availability.dart';
import 'package:livrodin/models/interest.dart';
import 'package:livrodin/models/rating.dart';
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

  Future<User?> getUserById(String idUser) async {
    try {
      var result = await firestore.collection("Users").doc(idUser).get();
      return User.fromFireStore(result.id, result.data()!);
    } catch (e) {
      return null;
    }
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
        User? user = await getUserById(data["idUser"]);
        ratings.add(
          Rating(
            id: doc.id,
            user: user ??
                User(
                  id: "-1",
                  name: "Usuário",
                  profilePictureUrl: null,
                ),
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
      String availabilityId, BookAvailableType availableType) async {
    if (authController.user.value == null) throw 'User not logged in';
    HttpsCallable callable =
        FirebaseFunctions.instanceFor(region: 'southamerica-east1')
            .httpsCallable('createTransaction');
    var request = <String, dynamic>{
      "availabilityId": availabilityId.toString(),
      "type": availableType.value.toString()
    };

    inspect(request);
    await callable.call(request);
  }
}
