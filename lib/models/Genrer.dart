import 'package:cloud_firestore/cloud_firestore.dart';

class Genrer {
  String id;
  String name;
  String coverUrl;

  Genrer({
    required this.id,
    required this.name,
    required this.coverUrl,
  });

  factory Genrer.fromFirestore(QueryDocumentSnapshot doc) {
    Map data = doc.data() as Map;
    return Genrer(
      id: doc.id,
      name: data["name"],
      coverUrl: data["coverUrl"],
    );
  }
}
