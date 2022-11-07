class User {
  final String id;
  final String name;
  final String? profilePictureUrl;
  final bool isMe;

  User({
    required this.id,
    required this.name,
    this.profilePictureUrl,
    this.isMe = false,
  });

  factory User.fromFireStore(String id, Map<String, dynamic> oldBook) {
    return User(
      id: id,
      name: oldBook['name'],
      profilePictureUrl: oldBook['profilePictureUrl'],
    );
  }
}
