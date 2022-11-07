import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:livrodin/components/cards/transaction_card.dart';
import 'package:livrodin/components/header.dart';
import 'package:livrodin/components/input.dart';
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
  late MessagesController _messagesController;

  @override
  void initState() {
    super.initState();
    _messagesController =
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
      resizeToAvoidBottomInset: true,
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 15),
                        child: Obx(
                          () => ListView.builder(
                            itemCount: _messagesController.messages.length,
                            itemBuilder: (context, index) {
                              final message =
                                  _messagesController.messages[index];
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
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Expanded(
                              child: Input(
                            controller: _messagesController.textInputController,
                          )),
                          IconButton(
                              onPressed: _messagesController.sendMessage,
                              icon: const Icon(Icons.send))
                        ],
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