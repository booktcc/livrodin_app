import 'package:livrodin/models/book.dart';
import 'package:livrodin/models/user.dart';

class Availability {
  final String _id;
  final Book book;
  final User user;
  final DateTime dateAvailable;
  final BookAvailableType availableType;

  Availability({
    required String id,
    required this.book,
    required this.user,
    required this.dateAvailable,
    required this.availableType,
  }) : _id = id;

  String get id => _id;
}
