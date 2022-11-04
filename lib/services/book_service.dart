import 'package:books_finder/books_finder.dart' as books_finder;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:livrodin/components/toggle_offer_status.dart';
import 'package:livrodin/controllers/auth_controller.dart';
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

  Future<void> addBook(Book book, OfferStatus offerStatus) async {
    if (authController.user.value == null) throw 'User not logged in';

    await firestore.collection("BookAvailable").doc().set(
          book.toFireStore(
            idUser: authController.user.value!.uid,
            offerStatus: offerStatus,
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
        .collection("BookAvailable")
        .limit(limit ?? 100)
        .orderBy("createdAt", descending: true)
        .orderBy("idBook")
        .get();

    for (var doc in result.docs) {
      var data = doc.data();
      if (!books.any((element) => element.id == data["idBook"])) {
        books.add(
          Book(
            id: data['idBook'],
            title: data['title'],
            coverUrl: data['coverUrl'],
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
}
