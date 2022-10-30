import 'package:books_finder/books_finder.dart' as books_finder;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:livrodin/components/toggle_offer_status.dart';

class Book {
  final String id;
  final String? isbn10;
  final String? isbn13;
  final String? title;
  final String? synopsis;
  final List<String>? authors;
  final String? coverUrl;
  final DateTime? publishedDate;
  final List<String>? genres;

  Book({
    required this.id,
    this.isbn10,
    this.isbn13,
    this.title,
    this.synopsis,
    this.authors,
    this.coverUrl,
    this.publishedDate,
    this.genres,
  });

  String get authorsString => authors?.join(', ') ?? '';

  factory Book.fromApi(books_finder.Book oldBook) {
    return Book(
      id: oldBook.id,
      title: oldBook.info.title,
      authors: oldBook.info.authors,
      coverUrl:
          "https://books.google.com/books/content?id=${oldBook.id}&printsec=frontcover&img=1&zoom=1&edge=curl&source=gbs_api",
      synopsis: oldBook.info.description,
      genres: oldBook.info.categories,
      publishedDate: oldBook.info.publishedDate,
      isbn10: oldBook.info.industryIdentifiers
          .firstWhere((element) => element.type == "ISBN_10")
          .identifier,
      isbn13: oldBook.info.industryIdentifiers
          .firstWhere((element) => element.type == "ISBN_13")
          .identifier,
    );
  }

  // toMap
  Map<String, dynamic> toFireStore(
      {required String idUser, required OfferStatus offerStatus}) {
    return {
      "idBook": id,
      "title": title,
      "coverUrl": coverUrl,
      "idUser": idUser,
      "createdAt": FieldValue.serverTimestamp(),
      "forDonation": (offerStatus == OfferStatus.both ||
          offerStatus == OfferStatus.donate),
      "forTrade":
          (offerStatus == OfferStatus.both || offerStatus == OfferStatus.trade),
    };
  }
}
