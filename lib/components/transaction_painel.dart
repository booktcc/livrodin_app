import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:livrodin/components/button_option_badge.dart';
import 'package:livrodin/components/dialogs/user_transations.dart';
import 'package:livrodin/configs/themes.dart';
import 'package:livrodin/controllers/user_transaction_controller.dart';
import 'package:livrodin/models/transaction.dart';

class TransactionPainel extends StatelessWidget {
  TransactionPainel({
    super.key,
    this.radius = 20,
    required this.type,
  });

  final double radius;
  final TransactionType type;
  final UserTransactionController _userTransactionController =
      Get.find<UserTransactionController>();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(radius),
          boxShadow: const [
            BoxShadow(
              color: Color.fromRGBO(0, 0, 0, 0.05),
              blurRadius: 20,
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              decoration: BoxDecoration(
                color: lightGrey,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(radius),
                  topRight: Radius.circular(radius),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.only(
                  left: 20,
                  top: 10,
                  bottom: 10,
                  right: 10,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(
                          type == TransactionType.donate
                              ? Icons.handshake_rounded
                              : Icons.swap_horizontal_circle_rounded,
                          color: Colors.black,
                          size: 32,
                        ),
                        const SizedBox(width: 10),
                        Text(
                          type == TransactionType.donate ? 'Doações' : 'Trocas',
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            fontFamily: "Avenir",
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                    Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(20),
                        onTap: () => Get.dialog(
                          UserTransationsDialog(
                            type: type == TransactionType.donate
                                ? TransactionType.donate
                                : TransactionType.trade,
                            tab: TransactionCategoryType.done,
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 10,
                            horizontal: 10,
                          ),
                          child: Row(
                            children: const [
                              Text(
                                'Mostrar Tudo',
                                style: TextStyle(
                                  color: grey,
                                  fontSize: 14,
                                  fontFamily: "Avenir",
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              SizedBox(width: 10),
                              Icon(
                                Icons.arrow_forward_ios_rounded,
                                color: grey,
                                size: 18,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Obx(
                () {
                  var transactions =
                      _userTransactionController.transactionsByCategory[type]!;

                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ButtonOptionBadge(
                        iconData: Icons.book_rounded,
                        text: 'Pedidos Recebidos',
                        onPressed: () => Get.dialog(
                          UserTransationsDialog(
                            type: type == TransactionType.donate
                                ? TransactionType.donate
                                : TransactionType.trade,
                            tab: TransactionCategoryType.ordersReceived,
                          ),
                        ),
                        badgeCount: transactions[
                                TransactionCategoryType.ordersReceived]!
                            .length,
                      ),
                      ButtonOptionBadge(
                        iconData: Icons.book_rounded,
                        text: 'Pedidos Feitos',
                        onPressed: () => Get.dialog(
                          UserTransationsDialog(
                            type: type == TransactionType.donate
                                ? TransactionType.donate
                                : TransactionType.trade,
                            tab: TransactionCategoryType.ordersMade,
                          ),
                        ),
                        badgeCount:
                            transactions[TransactionCategoryType.ordersMade]!
                                .length,
                      ),
                      ButtonOptionBadge(
                        iconData: Icons.book_rounded,
                        text: 'Andamento',
                        onPressed: () => Get.dialog(
                          UserTransationsDialog(
                            type: type == TransactionType.donate
                                ? TransactionType.donate
                                : TransactionType.trade,
                            tab: TransactionCategoryType.progress,
                          ),
                        ),
                        badgeCount:
                            transactions[TransactionCategoryType.progress]!
                                .length,
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
