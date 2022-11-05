import 'package:livrodin/models/book.dart';

class Interest {
  final String _id;
  final Book book;

  get id => _id;

  Interest({
    required String id,
    required this.book,
  }) : _id = id;
}
