import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:livrodin/models/book.dart';
import 'package:livrodin/models/reply.dart';
import 'package:livrodin/models/user.dart';

class Discussion {
  final String id;
  final User user;
  final String title;
  final Book book;
  final DateTime? createdAt;
  List<Reply> replies;

  Discussion({
    required this.id,
    required this.user,
    required this.title,
    required this.book,
    this.createdAt,
    this.replies = const [],
  });

  Map<String, dynamic> toFirestore() {
    return {
      "idUser": user.id,
      "title": title,
      "createdAt": FieldValue.serverTimestamp()
    };
  }

  factory Discussion.fromFirestore(DocumentSnapshot doc, User user, Book book) {
    final data = doc.data() as Map<String, dynamic>;
    return Discussion(
      book: book,
      id: doc.id,
      user: user,
      createdAt: (data["createdAt"] as Timestamp).toDate(),
      title: data["title"],
      replies: [],
    );
  }
}
