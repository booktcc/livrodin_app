import 'package:livrodin/models/book.dart';
import 'package:livrodin/models/message.dart';
import 'package:livrodin/models/transaction.dart';
import 'package:livrodin/models/user.dart';

const fakeImageProfile = "https://avatars.githubusercontent.com/u/47704204?v=4";
const fakeName = "Higor Pires de França";
const fakeEmail = "higor.pires@gmail.com";
const fakeBookImage =
    "https://books.google.com/books/content?id=GgQmDwAAQBAJ&printsec=frontcover&img=1&zoom=1&edge=curl&source=gbs_api";

final fakeUser1 = User(
  id: "",
  name: "João Lucas",
  profilePictureUrl: "https://avatars.githubusercontent.com/u/55464917?v=4",
  isMe: true,
);
final fakeUser2 = User(
  id: "",
  name: "Higor",
  profilePictureUrl: "https://avatars.githubusercontent.com/u/47704204?v=4",
);

final fakeBook = Book(
  id: "1",
  title: "Livro 1",
  coverUrl: fakeBookImage,
);
final fakeTransaction = Transaction(
  id: "",
  book1: fakeBook,
  createdAt: DateTime.now(),
  updatedAt: DateTime.now(),
  type: TransactionType.trade,
  status: TransactionStatus.pending,
  user1: fakeUser1,
  user2: fakeUser2,
);

final fakeMessage = Message(
  id: "",
  user: fakeUser1,
  text: "Olá, tudo bem?",
  createdAt: DateTime.now(),
);
final fakeMessage2 = Message(
  id: "",
  user: fakeUser2,
  text: "Tudo sim e com você?",
  createdAt: DateTime.now(),
);
