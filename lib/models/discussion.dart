import 'package:livrodin/models/user.dart';

class Discussion {
  final String id;
  final User user;
  final String title;

  Discussion({
    required this.id,
    required this.user,
    required this.title,
  });
}
