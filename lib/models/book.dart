import 'package:books_finder/books_finder.dart' as books_finder;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get_utils/get_utils.dart';
import 'package:livrodin/models/availability.dart';
import 'package:livrodin/models/discussion.dart';
import 'package:livrodin/models/rating.dart';

enum BookAvailableType {
  both,
  trade,
  donate;

  String get value {
    switch (this) {
      case BookAvailableType.trade:
        return "FOR_TRADE";
      case BookAvailableType.donate:
        return "FOR_DONATION";
      case BookAvailableType.both:
        return "BOTH";
    }
  }
}

class Book {
  final String _id;
  final String? isbn10;
  final String? isbn13;
  final String? title;
  final int? pageCount;
  final String? synopsis;
  final String? language;
  final List<String>? authors;
  final String? coverUrl;
  final String? publisher;
  final DateTime? publishedDate;
  final List<String>? genres;
  List<Rating> ratings;
  List<Availability> availabilities;
  List<Discussion> discussions;
  BookAvailableType? availableType;

  Book({
    required String id,
    this.isbn10,
    this.isbn13,
    this.title,
    this.language,
    this.pageCount,
    this.synopsis,
    this.publisher,
    this.authors,
    this.coverUrl,
    this.publishedDate,
    this.genres,
    this.ratings = const [],
    this.availabilities = const [],
    this.discussions = const [],
    this.availableType,
  }) : _id = id;

  String get id => _id;

  double get averageRating {
    if (ratings.isEmpty) return 0;
    return ratings.map((e) => e.rating).reduce((a, b) => a + b) /
        ratings.length;
  }

  String get genresString => genres?.join(", ") ?? "";
  String get authorsString => authors?.join(', ') ?? 'Desconhecido';

  factory Book.fromApi(books_finder.Book oldBook) {
    return Book(
      id: oldBook.id,
      title: oldBook.info.title,
      pageCount: oldBook.info.pageCount,
      authors: oldBook.info.authors,
      publisher: oldBook.info.publisher,
      language: oldBook.info.language,
      coverUrl:
          "https://books.google.com/books/content?id=${oldBook.id}&printsec=frontcover&img=1&zoom=1&edge=curl&source=gbs_api",
      synopsis: oldBook.info.description,
      genres: oldBook.info.categories,
      publishedDate: oldBook.info.publishedDate,
      isbn10: oldBook.info.industryIdentifiers
          .firstWhereOrNull((element) => element.type == "ISBN_10")
          ?.identifier,
      isbn13: oldBook.info.industryIdentifiers
          .firstWhereOrNull((element) => element.type == "ISBN_13")
          ?.identifier,
    );
  }

  // toMap
  Map<String, dynamic> toFireStore(
      {required String idUser, required BookAvailableType availableType}) {
    return {
      "idBook": id,
      "idUser": idUser,
      "createdAt": FieldValue.serverTimestamp(),
      "availableType": availableType.value,
    };
  }
}
