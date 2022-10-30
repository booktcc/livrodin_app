import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:livrodin/models/book.dart';

final mockedUser = MockUser(
  isAnonymous: false,
  uid: 'someuid',
  email: 'bob@somedomain.com',
  displayName: 'Bob',
);

final fakeBook = Book(
  id: "harrypotter",
  title: "Harry Potter e a Ordem da Fênix",
  coverUrl: "",
);
