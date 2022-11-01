import 'package:livrodin/models/user.dart';

class Rating {
  final String id;
  final User user;
  final int rating;
  final String comment;

  Rating({
    required this.id,
    required this.user,
    required this.rating,
    required this.comment,
  });
}
