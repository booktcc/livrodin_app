import 'package:livrodin/models/book.dart';
import 'package:livrodin/models/user.dart';

enum TransactionStatus {
  pending,
  inProgress,
  completed,
  canceled;

  String get value {
    switch (this) {
      case TransactionStatus.pending:
        return "PENDING";
      case TransactionStatus.inProgress:
        return "IN_PROGRESS";
      case TransactionStatus.completed:
        return "COMPLETED";
      case TransactionStatus.canceled:
        return "CANCELED";
    }
  }
}

enum TransactionType {
  trade,
  donate;

  String get value {
    switch (this) {
      case TransactionType.trade:
        return "FOR_TRADE";
      case TransactionType.donate:
        return "FOR_DONATION";
    }
  }
}

class Transaction {
  final String id;
  final DateTime createdAt;
  final DateTime updatedAt;
  final TransactionType type;
  final TransactionStatus status;
  final User user1;
  final User user2;
  final Book book1;
  final Book? book2;
  final bool? user1Confirm;
  final bool? user2Confirm;

  Transaction({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.type,
    required this.status,
    required this.user1,
    required this.user2,
    required this.book1,
    this.book2,
    this.user1Confirm,
    this.user2Confirm,
  });
}
