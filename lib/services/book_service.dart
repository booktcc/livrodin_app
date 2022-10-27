import 'package:books_finder/books_finder.dart' as books_finder;

import '../models/book.dart';

List<Book> parseBooks(List<books_finder.Book> books) => books
    .map((book) => Book(
          title: book.info.title,
          authors: book.info.authors,
          isbn10: "978-85-7522-510-0",
          isbn13: "978-85-7522-510-0",
          capaUrl: book.info.imageLinks.entries.first.value.toString(),
          sinopse: book.info.description,
          generos: book.info.categories,
          publishedDate: book.info.publishedDate,
        ))
    .toList();

class BookService {
  Future<List<Book>> searchBooks(String query) async {
    var results = await books_finder.queryBooks(query, maxResults: 10);
    return parseBooks(results);
  }
}
