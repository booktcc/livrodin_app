import 'package:books_finder/books_finder.dart' as books_finder;

class Book {
  final String? isbn10;
  final String? isbn13;
  final String? title;
  final String? sinopse;
  final List<String>? authors;
  final String? capaUrl;
  final DateTime? publishedDate;
  final List<String>? generos;

  Book({
    this.isbn10,
    this.isbn13,
    this.title,
    this.sinopse,
    this.authors,
    this.capaUrl,
    this.publishedDate,
    this.generos,
  });

  factory Book.fromApi(books_finder.Book oldBook) {
    return Book(
      title: oldBook.info.title,
      authors: oldBook.info.authors,
      capaUrl:
          "https://books.google.com/books/content?id=${oldBook.id}&printsec=frontcover&img=1&zoom=1&edge=curl&source=gbs_api",
      sinopse: oldBook.info.description,
      generos: oldBook.info.categories,
      publishedDate: oldBook.info.publishedDate,
      isbn10: oldBook.info.industryIdentifiers
          .firstWhere((element) => element.type == "ISBN_10")
          .identifier,
      isbn13: oldBook.info.industryIdentifiers
          .firstWhere((element) => element.type == "ISBN_13")
          .identifier,
    );
  }
}
