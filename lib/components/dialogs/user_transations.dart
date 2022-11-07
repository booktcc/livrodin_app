import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:livrodin/components/cards/transaction_card.dart';
import 'package:livrodin/components/header.dart';
import 'package:livrodin/components/layout.dart';
import 'package:livrodin/configs/themes.dart';
import 'package:livrodin/controllers/book_controller.dart';
import 'package:livrodin/models/transaction.dart';
import 'package:livrodin/utils/state_machine.dart';

enum TransactionTabType {
  progress,
  ordersReceived,
  ordersMade,
  done,
  canceled;

  String get name {
    switch (this) {
      case TransactionTabType.progress:
        return "Andamento";
      case TransactionTabType.done:
        return "Concluido";
      case TransactionTabType.canceled:
        return "Cancelado";
      case TransactionTabType.ordersMade:
        return "Pedidos Feitos";
      case TransactionTabType.ordersReceived:
        return "Pedidos Recebidos";
    }
  }
}

enum TransactionsType { donate, trade }

class UserTransationsDialog extends StatefulWidget {
  const UserTransationsDialog({
    super.key,
    required this.type,
    this.tab = TransactionTabType.progress,
  });

  final TransactionsType type;
  final TransactionTabType tab;

  @override
  State<UserTransationsDialog> createState() => _UserTransationsDialogState();
}

class _UserTransationsDialogState extends State<UserTransationsDialog> {
  final BookController _bookController = Get.find<BookController>();

  RxList<Transaction> transactions = <Transaction>[].obs;

  final Rx<FetchState> stateFetch = FetchState.loading.obs;

  @override
  void initState() {
    super.initState();
    stateFetch.value = FetchState.loading;
    _bookController.getTransactionsFromUser().then((value) {
      transactions.value = value;
      stateFetch.value = FetchState.success;
    }).onError((error, stackTrace) {
      stateFetch.value = FetchState.error;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Layout(
      headerProps: HeaderProps(
        showLogo: false,
        showBackButton: true,
        title: widget.type == TransactionsType.donate ? 'Doações' : 'Trocas',
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(pageRadius),
          topRight: Radius.circular(pageRadius),
        ),
        child: Container(
          color: lightGrey,
          height: double.infinity,
          width: double.infinity,
          child: DefaultTabController(
            length: TransactionTabType.values.length,
            child: Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  child: TabBar(
                    overlayColor: MaterialStateProperty.all(Colors.transparent),
                    enableFeedback: true,
                    labelColor: dark,
                    labelStyle: const TextStyle(
                      fontWeight: FontWeight.w800,
                    ),
                    unselectedLabelStyle: const TextStyle(
                      fontWeight: FontWeight.w500,
                    ),
                    isScrollable: true,
                    physics: const BouncingScrollPhysics(),
                    tabs: TransactionTabType.values
                        .map(
                          (e) => Tab(
                            text: e.name,
                          ),
                        )
                        .toList(),
                  ),
                ),
                Expanded(
                  child: Builder(builder: (context) {
                    return Obx(
                      () => TabBarView(
                          children: TransactionTabType.values
                              .map(
                                (e) => ListView.builder(
                                  itemCount: transactions.length,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15, vertical: 20),
                                  itemBuilder: (context, index) => Padding(
                                    padding: EdgeInsets.only(
                                        top: index == 0 ? 0 : 20),
                                    child: TransactionCard(
                                      transaction: transactions[index],
                                      onMessagePressed: () {},
                                      onConfirmPressed: () {},
                                      onCancelPressed: () {},
                                    ),
                                  ),
                                ),
                              )
                              .toList()),
                    );
                  }),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
