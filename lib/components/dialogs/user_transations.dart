import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:livrodin/components/cards/transaction_card.dart';
import 'package:livrodin/components/dialogs/transaction_chat.dart';
import 'package:livrodin/components/header.dart';
import 'package:livrodin/components/layout.dart';
import 'package:livrodin/configs/themes.dart';
import 'package:livrodin/controllers/book_controller.dart';
import 'package:livrodin/controllers/user_transaction_controller.dart';
import 'package:livrodin/models/transaction.dart';

class UserTransationsDialog extends StatefulWidget {
  const UserTransationsDialog({
    super.key,
    required this.type,
    this.tab = TransactionCategoryType.progress,
  });

  final TransactionType type;
  final TransactionCategoryType tab;

  @override
  State<UserTransationsDialog> createState() => _UserTransationsDialogState();
}

class _UserTransationsDialogState extends State<UserTransationsDialog>
    with TickerProviderStateMixin {
  final BookController _bookController = Get.find<BookController>();

  late final TabController _tabController;

  final UserTransactionController _userTransactionController =
      Get.find<UserTransactionController>();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: TransactionCategoryType.values.length,
      vsync: this,
      initialIndex: TransactionCategoryType.values.indexOf(widget.tab),
    );
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
                  tabs: TransactionCategoryType.values
                      .map(
                        (e) => Tab(
                          text: e.name,
                        ),
                      )
                      .toList(),
                  controller: _tabController,
                ),
              ),
              Expanded(
                child: Builder(builder: (context) {
                  return Obx(
                    () {
                      var transactions = _userTransactionController
                          .transactionsByCategory[widget.type]!;
                      return TabBarView(
                          controller: _tabController,
                          children: TransactionCategoryType.values
                              .map(
                                (e) => ListView.builder(
                                  itemCount: transactions[e]!.length,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15, vertical: 20),
                                  itemBuilder: (context, index) {
                                    var transaction = transactions[e]![index];
                                    return Padding(
                                      padding: EdgeInsets.only(
                                          top: index == 0 ? 0 : 20),
                                      child: TransactionCard(
                                        transaction: transaction,
                                        onMessagePressed: () {
                                          Get.dialog(TransactionChat(
                                              transaction: transaction));
                                        },
                                        onConfirmPressed: () async {
                                          await _bookController
                                              .confirmTransaction(
                                            transaction.id,
                                            null,
                                          );
                                          _userTransactionController
                                              .fetchTransactions();
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
                                          _userTransactionController
                                              .fetchTransactions();
                                        },
                                      ),
                                    );
                                  },
                                ),
                              )
                              .toList());
                    },
                  );
                }),
              )
            ],
          ),
        ),
      ),
    );
  }
}
