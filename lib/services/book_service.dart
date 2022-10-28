import 'package:app_flutter/components/toggle_offer_status.dart';
import 'package:app_flutter/controllers/auth_controller.dart';
import 'package:books_finder/books_finder.dart' as books_finder;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import '../models/book.dart';

class BookService {
  var authController = Get.find<AuthController>();

  Future<List<Book>> searchBooksOnGoogleApi(String query) async {
    var results = await books_finder.queryBooks(query, maxResults: 10);
    return results.map(Book.fromApi).toList();
  }

  Future<void> addBook(Book book, OfferStatus offerStatus) async {
    if (authController.user.value == null) throw 'User not logged in';

    await FirebaseFirestore.instance.collection("BookAvailable").doc().set({
      "isbn10": book.isbn10,
      "isbn13": book.isbn13,
      "title": book.title,
      "coverUrl": book.coverUrl,
      "idUser": authController.user.value!.uid,
      "createdAt": FieldValue.serverTimestamp(),
      "forDonation": (offerStatus == OfferStatus.both ||
          offerStatus == OfferStatus.donate),
      "forTrade":
          (offerStatus == OfferStatus.both || offerStatus == OfferStatus.trade),
    });
  }

  Future<void> addRate(
      {required Book book, required int rate, required String comment}) async {
    if (authController.user.value == null) throw 'User not logged in';

    await FirebaseFirestore.instance.collection("BookRate").doc().set({
      "isbn10": book.isbn10,
      "isbn13": book.isbn13,
      "idUser": authController.user.value!.uid,
      "rate": rate,
      "comment": comment.trim().isNotEmpty ? comment : null,
    });
  }
}
