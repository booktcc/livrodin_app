import 'package:livrodin/models/user.dart';

enum SystemMessage {
  confirmed,
  canceled,
  finished;

  String get value {
    switch (this) {
      case SystemMessage.confirmed:
        return 'CONFIRMED';
      case SystemMessage.canceled:
        return 'CANCELED';
      case SystemMessage.finished:
        return 'FINISHED';
    }
  }

  static SystemMessage? fromString(String? value) {
    if (value == null) return null;
    switch (value) {
      case 'CONFIRMED':
        return SystemMessage.confirmed;
      case 'CANCELED':
        return SystemMessage.canceled;
      case 'FINISHED':
        return SystemMessage.finished;
      default:
        return null;
    }
  }

  String get label {
    switch (this) {
      case SystemMessage.confirmed:
        return 'confirmou';
      case SystemMessage.canceled:
        return 'cancelou';
      case SystemMessage.finished:
        return 'finalizou';
    }
  }
}

class Message {
  final String id;
  final User user;
  final String? text;
  final DateTime createdAt;
  final SystemMessage? systemMessage;

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
      systemMessage: SystemMessage.fromString(json['systemMessage']),
    );
  }
}
