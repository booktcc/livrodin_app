import 'package:books_finder/books_finder.dart' as books_finder;

import '../models/book.dart';

class BookService {
  Future<List<Book>> searchBooks(String query) async {
    var results = await books_finder.queryBooks(query, maxResults: 10);
    return results.map(Book.fromApi).toList();
  }
}
