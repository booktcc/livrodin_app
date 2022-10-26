import 'package:app_flutter/components/toggle_offer_status.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import '../models/book.dart';
import 'auth_controller.dart';

class BookController extends GetxController {
  var authController = Get.find<AuthController>();

  Future<bool?> makeBookAvailable(Book book, OfferStatus offerStatus) async {
    try {
      await FirebaseFirestore.instance.collection("BookAvailable").doc().set({
        "idBook": book.isbn10 ?? book.isbn13,
        "idUser": authController.user.value!.uid,
        "data": DateTime.now().toIso8601String(),
        "forDonation": (offerStatus == OfferStatus.both ||
            offerStatus == OfferStatus.donate),
        "forTrade": (offerStatus == OfferStatus.both ||
            offerStatus == OfferStatus.trade),
      });
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<List<Book>> searchBook(String q) async {
    try {
      // TODO: Implement searchBook

      return [
        Book(
          isbn13: "978-85-7522-510-0",
          title: "Harry Potter e a Pedra Filosofal",
          authors: ["J. K. Rowling"],
          capaUrl:
              "https://books.google.com.br/books/publisher/content?id=GjgQCwAAQBAJ&hl=pt-BR&pg=PP1&img=1&zoom=3&bul=1&sig=ACfU3U32CKE-XFfMvnbcz1qW0PS46Lg-Ew&w=1280",
        ),
        Book(
          isbn13: "978-85-7522-510-0",
          title: "Harry Potter e a Pedra Filosofal",
          authors: ["J. K. Rowling"],
          capaUrl:
              "https://books.google.com.br/books/publisher/content?id=GjgQCwAAQBAJ&hl=pt-BR&pg=PP1&img=1&zoom=3&bul=1&sig=ACfU3U32CKE-XFfMvnbcz1qW0PS46Lg-Ew&w=1280",
        ),
      ];
    } catch (e) {
      return [];
    }
  }
}
