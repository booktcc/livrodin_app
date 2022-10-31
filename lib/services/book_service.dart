import 'package:livrodin/components/toggle_offer_status.dart';
import 'package:livrodin/controllers/auth_controller.dart';
import 'package:books_finder/books_finder.dart' as books_finder;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

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
      "idUser": authController.user.value!.uid,
      "rate": rate,
      "comment": comment.trim().isNotEmpty ? comment : null,
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
      try {
        if (books.last.id != data["idBook"]) {
          books.add(
            Book(
              id: data['idBook'],
              title: data['title'],
              coverUrl: data['coverUrl'],
            ),
          );
        }
      } catch (e) {
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
}
