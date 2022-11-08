class User {
  final String id;
  final String name;
  final String? lastName;
  final String email;
  final String? profilePictureUrl;
  final bool isMe;

  User({
    required this.id,
    required String? name,
    this.lastName,
    this.email = "",
    this.profilePictureUrl,
    this.isMe = false,
  }) : name = name ?? "";

  factory User.fromFireStore(String id, Map<String, dynamic> oldBook) {
    return User(
      id: id,
      name: oldBook['name'],
      lastName: oldBook['lastName'],
      profilePictureUrl: oldBook['profilePictureUrl'],
      email: oldBook['email'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      "name": name,
      "lastName": lastName,
      "email": email,
      "profilePictureUrl": profilePictureUrl,
    };
  }
}
