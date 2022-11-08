import 'package:livrodin/models/user.dart';

enum NotificationType {
  message,
  transaction;

  String get value {
    switch (this) {
      case NotificationType.message:
        return 'MESSAGE';
      case NotificationType.transaction:
        return 'TRANSACTION';
    }
  }
}

class Notificaton {
  final String id;
  final NotificationType type;
  final String transactionId;
  final DateTime createdAt;
  final String userId;
  final String message;

  Notificaton({
    required this.id,
    required this.type,
    required this.transactionId,
    required this.createdAt,
    required this.userId,
    required this.message,
  });

  factory Notificaton.fromJson(Map<String, dynamic> json, String id) {
    return Notificaton(
      id: id,
      type: NotificationType.values
          .firstWhere((element) => element.value == json['type']),
      transactionId: json['transactionId'],
      createdAt: json['createdAt'].toDate(),
      userId: json['userId'],
      message: json['message'],
    );
  }
}

class NotificationFilled {
  final Notificaton notification;
  final User user;

  NotificationFilled({
    required this.notification,
    required this.user,
  });
}
