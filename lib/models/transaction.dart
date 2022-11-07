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

class Transaction {
  final String id;
  final DateTime createdAt;
  final DateTime updatedAt;
  final BookAvailableType type;
  final TransactionStatus status;
  final User user1;
  final User user2;
  final Book book1;
  final Book? book2;

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
  });
}
