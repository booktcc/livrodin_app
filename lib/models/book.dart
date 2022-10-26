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
}
