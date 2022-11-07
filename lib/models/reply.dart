import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:livrodin/models/discussion.dart';
import 'package:livrodin/models/user.dart';

class Reply {
  final String? id;
  final User user;
  final String text;
  final Discussion discussion;
  final DateTime? createdAt;

  Reply({
    this.id,
    required this.discussion,
    required this.user,
    required this.text,
    this.createdAt,
  });

  Map<String, dynamic> toFirestore() {
    return {
      'idUser': user.id,
      'text': text,
      'createdAt': FieldValue.serverTimestamp(),
    };
  }

  factory Reply.fromFirestore(
      DocumentSnapshot doc, Discussion discussion, User user) {
    final data = doc.data() as Map<String, dynamic>;
    return Reply(
      discussion: discussion,
      id: doc.id,
      user: user,
      text: data['text'],
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }
}
