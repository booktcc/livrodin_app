import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:livrodin/components/button_option.dart';
import 'package:livrodin/components/dialogs/book_list_available_from_user.dart';
import 'package:livrodin/components/profile_icon.dart';
import 'package:livrodin/configs/livrodin_icons.dart';
import 'package:livrodin/configs/themes.dart';
import 'package:livrodin/models/availability.dart';
import 'package:livrodin/models/book.dart';
import 'package:livrodin/models/transaction.dart';
import 'package:livrodin/models/user.dart';
import 'package:intl/intl.dart';

class TransactionCard extends StatelessWidget {
  final Transaction transaction;

  final Function()? onMessagePressed;
  final Function()? onConfirmPressed;
  final Function()? onCancelPressed;
  final Function(Availability)? onChooseBook;

  const TransactionCard({
    super.key,
    required this.transaction,
    this.onMessagePressed,
    this.onConfirmPressed,
    this.onCancelPressed,
    this.onChooseBook,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        width: 345,
        height: 180,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              spreadRadius: 0,
              blurRadius: 4,
              offset: const Offset(0, 4), // changes position of shadow
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 6.0, horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      // "Última Atualização: 02 de outubro de 2022 às 15:30",
                      // make this dynamic
                      "Última Atualização: ${formatDate(transaction.updatedAt)}",
                      style: const TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 8,
                        color: grey,
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Expanded(
                      child: TransactionDetail(
                        transaction: transaction,
                        onChooseBook: onChooseBook,
                      ),
                    )
                  ],
                ),
              ),
            ),
            // border left
            Container(
              decoration: const BoxDecoration(
                border: Border(
                  left: BorderSide(
                    width: 1.0,
                    color: grey,
                  ),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.only(top: 13.5, bottom: 13.5),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Visibility(
                      visible: [
                        TransactionStatus.inProgress,
                        TransactionStatus.completed,
                        TransactionStatus.canceled,
                      ].contains(transaction.status),
                      child: Column(
                        children: [
                          ButtonOption(
                            iconData: Icons.message,
                            text: "Mensagem",
                            onPressed: onMessagePressed,
                          ),
                          Visibility(
                            visible: ![
                              TransactionStatus.completed,
                              TransactionStatus.canceled,
                            ].contains(transaction.status),
                            child: const SizedBox(height: 15),
                          ),
                        ],
                      ),
                    ),
                    Visibility(
                      visible: [
                            TransactionStatus.pending,
                            TransactionStatus.inProgress
                          ].contains(transaction.status) &&
                          (transaction.status == TransactionStatus.pending
                              ? transaction.user1.isMe
                              : true),
                      child: Column(
                        children: [
                          ButtonOption(
                            iconData: Icons.check_circle,
                            text: "Confirmar",
                            color: green,
                            onPressed: onConfirmPressed,
                          ),
                          const SizedBox(height: 15),
                        ],
                      ),
                    ),
                    Visibility(
                      visible: [
                        TransactionStatus.inProgress,
                        TransactionStatus.pending,
                      ].contains(transaction.status),
                      child: ButtonOption(
                        iconData: Icons.cancel,
                        text: transaction.status == TransactionStatus.pending &&
                                transaction.user1.isMe
                            ? "Rejeitar"
                            : "Cancelar",
                        color: red,
                        onPressed: onCancelPressed,
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ));
  }
}

class TransactionDetail extends StatelessWidget {
  const TransactionDetail(
      {Key? key, required this.transaction, this.color, this.onChooseBook})
      : super(key: key);

  final Transaction transaction;
  final Color? color;

  final Function(Availability)? onChooseBook;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        BookCardWithProfile(
          user: transaction.user1,
          book: transaction.book1,
          otherUser: transaction.user2,
        ),
        Icon(
          transaction.type == TransactionType.trade
              ? Icons.swap_horizontal_circle
              : LivrodinIcons.donateIcon,
          color: color,
        ),
        transaction.type == TransactionType.trade
            ? BookCardWithProfile(
                user: transaction.user2,
                book: transaction.book2,
                otherUser: transaction.user1,
                onChooseBook: (availability) {
                  onChooseBook?.call(availability);
                },
              )
            : ProfileCard(
                user: transaction.user2,
              )
      ],
    );
  }
}

// transform DateTime like this: "Última Atualização: 02 de outubro de 2022 às 15:30"
String formatDate(DateTime date) {
  var formatter = DateFormat("dd 'de' MMMM 'de' yyyy 'ás' HH:mm", 'pt_BR');
  return formatter.format(date);
}

class ProfileCard extends StatelessWidget {
  final User user;
  const ProfileCard({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ProfileIcon(
          size: ProfileSize.lg,
          image: user.profilePictureUrl,
        ),
        const SizedBox(height: 10),
        Text(
          user.name,
          style: const TextStyle(
            fontWeight: FontWeight.w800,
            fontSize: 12,
            color: grey,
          ),
        )
      ],
    );
  }
}

class BookCardWithProfile extends StatelessWidget {
  final Book? book;
  final User user;
  final User otherUser;
  final Function(Availability)? onChooseBook;
  const BookCardWithProfile({
    Key? key,
    required this.user,
    required this.otherUser,
    this.book,
    this.onChooseBook,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.center,
      children: [
        Column(
          children: [
            GestureDetector(
              onTap: book == null
                  ? () async {
                      var result = await Get.dialog<Availability?>(
                        BookListAvailableFromUser(
                          user: user,
                        ),
                      );

                      if (result != null) {
                        onChooseBook?.call(result);
                      }
                    }
                  : null,
              child: Container(
                height: 125,
                width: 87,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(5),
                  image: book != null
                      ? DecorationImage(
                          image: NetworkImage(book!.coverUrl!),
                          fit: BoxFit.cover,
                        )
                      : null,
                ),
                child: Visibility(
                  visible: book == null,
                  child: Center(
                    child: Text(
                      "Aguardando\n${otherUser.isMe ? "Você" : otherUser.name}\nEscolher",
                      style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 10,
                          color: grey),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 27,
            ),
          ],
        ),
        Positioned(
          bottom: 0,
          child: Column(
            children: [
              ProfileIcon(
                size: ProfileSize.md,
                image: user.profilePictureUrl,
              ),
              Text(
                user.isMe ? "Eu" : user.name,
                style: const TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 8,
                  color: grey,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
