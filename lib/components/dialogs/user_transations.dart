import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:livrodin/components/cards/transaction_card.dart';
import 'package:livrodin/components/header.dart';
import 'package:livrodin/components/layout.dart';
import 'package:livrodin/configs/themes.dart';
import 'package:livrodin/controllers/auth_controller.dart';
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

class UserTransationsDialog extends StatefulWidget {
  const UserTransationsDialog({
    super.key,
    required this.type,
    this.tab = TransactionTabType.progress,
  });

  final TransactionType type;
  final TransactionTabType tab;

  @override
  State<UserTransationsDialog> createState() => _UserTransationsDialogState();
}

class _UserTransationsDialogState extends State<UserTransationsDialog> {
  final BookController _bookController = Get.find<BookController>();
  final AuthController _authController = Get.find<AuthController>();

  RxMap<TransactionTabType, List<Transaction>> transactionsByTab =
      <TransactionTabType, List<Transaction>>{
    TransactionTabType.progress: [],
    TransactionTabType.done: [],
    TransactionTabType.canceled: [],
    TransactionTabType.ordersMade: [],
    TransactionTabType.ordersReceived: [],
  }.obs;

  final Rx<FetchState> stateFetch = FetchState.loading.obs;

  @override
  void initState() {
    super.initState();
    stateFetch.value = FetchState.loading;
    fetchTransactions();
  }

  void fetchTransactions() {
    _bookController.getTransactionsFromUser(widget.type).then((transactions) {
      final inProgress = transactions
          .where((element) => element.status == TransactionStatus.inProgress)
          .toList();
      inspect(inProgress);
      final done = transactions
          .where((element) => element.status == TransactionStatus.completed)
          .toList();

      final canceled = transactions
          .where((element) => element.status == TransactionStatus.canceled)
          .toList();

      final ordersMade = transactions
          .where(
            (element) =>
                element.status == TransactionStatus.pending &&
                element.user2.id == _authController.user.value!.uid,
          )
          .toList();

      final ordersReceived = transactions
          .where(
            (element) =>
                element.status == TransactionStatus.pending &&
                element.user1.id == _authController.user.value!.uid,
          )
          .toList();
      transactionsByTab.value = {
        TransactionTabType.progress: inProgress,
        TransactionTabType.done: done,
        TransactionTabType.canceled: canceled,
        TransactionTabType.ordersMade: ordersMade,
        TransactionTabType.ordersReceived: ordersReceived,
      };

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
        title: widget.type == TransactionType.donate ? 'Doações' : 'Trocas',
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
                                  itemCount: transactionsByTab[e]!.length,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15, vertical: 20),
                                  itemBuilder: (context, index) {
                                    var transaction =
                                        transactionsByTab[e]![index];
                                    return Padding(
                                      padding: EdgeInsets.only(
                                          top: index == 0 ? 0 : 20),
                                      child: TransactionCard(
                                        transaction: transaction,
                                        onMessagePressed: () {},
                                        onConfirmPressed: () async {
                                          await _bookController
                                              .confirmTransaction(
                                            transaction.id,
                                            null,
                                          );
                                          fetchTransactions();
                                        },
                                        onCancelPressed: () async {
                                          if (transaction.status ==
                                              TransactionStatus.pending) {
                                            await _bookController
                                                .rejectTransaction(
                                              transaction.id,
                                            );
                                          } else {
                                            await _bookController
                                                .cancelTransaction(
                                              transaction.id,
                                            );
                                          }
                                          fetchTransactions();
                                        },
                                      ),
                                    );
                                  },
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
