import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:livrodin/components/cards/transaction_card.dart';
import 'package:livrodin/components/header.dart';
import 'package:livrodin/components/layout.dart';
import 'package:livrodin/configs/themes.dart';
import 'package:livrodin/controllers/messages_controller.dart';
import 'package:livrodin/models/message.dart';
import 'package:livrodin/models/transaction.dart';
import 'package:livrodin/utils/converters.dart';

class TransactionChat extends StatefulWidget {
  final Transaction transaction;
  const TransactionChat({
    super.key,
    required this.transaction,
  });

  @override
  State<TransactionChat> createState() => _TransactionChatState();
}

class _TransactionChatState extends State<TransactionChat> {
  late MessagesController messagesController;

  @override
  void initState() {
    super.initState();
    messagesController =
        Get.put(MessagesController(transaction: widget.transaction));
  }

  @override
  Widget build(BuildContext context) {
    return Layout(
      headerProps: HeaderProps(
        showLogo: false,
        showBackButton: true,
        title: 'Mensagem',
      ),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: SizedBox(
              width: 258,
              child: TransactionDetail(
                transaction: widget.transaction,
                color: Colors.white,
              ),
            ),
          ),
          Expanded(
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(pageRadius),
                topRight: Radius.circular(pageRadius),
              ),
              child: Container(
                color: lightGrey,
                height: double.infinity,
                width: double.infinity,
                child: Stack(
                  alignment: Alignment.topCenter,
                  children: [
                    Positioned(
                      top: 11,
                      child: Container(
                        width: 200,
                        height: 20,
                        decoration: const BoxDecoration(
                          color: dark,
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                        child: const Text(
                          "29 de Fevereiro de 2022",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 40),
                      child: Expanded(
                        child: Obx(
                          () => ListView.builder(
                            itemCount: messagesController.messages.length,
                            itemBuilder: (context, index) {
                              final message =
                                  messagesController.messages[index];
                              return Padding(
                                padding: EdgeInsets.only(
                                  left: 10,
                                  right: 10,
                                  top: index == 0 ? 0 : 10,
                                ),
                                child: MessageContainer(message: message),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class MessageContainer extends StatelessWidget {
  const MessageContainer({
    Key? key,
    required this.message,
  }) : super(key: key);

  final Message message;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment:
          message.user.isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        Container(
          width: 294,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(
              Radius.circular(10),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: Stack(
              children: [
                Text(
                  message.text,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFFB8B8B8),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Text(
                    dateToHour(message.createdAt),
                    style: const TextStyle(
                      fontSize: 6,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFFB8B8B8),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
