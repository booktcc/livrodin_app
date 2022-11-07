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

  factory Message.fromJson(Map<String, dynamic> json, User user, String id) {
    return Message(
      id: id,
      user: user,
      text: json['text'],
      createdAt: json['createdAt'].toDate(),
      systemMessage: json['systemMessage'],
    );
  }
}
