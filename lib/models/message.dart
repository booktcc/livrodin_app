import 'package:livrodin/models/user.dart';

class Message {
  final String id;
  final User user;
  final String text;
  final DateTime createdAt;
  final String? systemMessage;

  Message({
    required this.id,
    required this.user,
    required this.text,
    required this.createdAt,
    this.systemMessage,
  });
}
