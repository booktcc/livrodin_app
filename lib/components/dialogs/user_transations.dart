import 'package:flutter/material.dart';
import 'package:livrodin/components/header.dart';
import 'package:livrodin/components/layout.dart';
import 'package:livrodin/configs/themes.dart';

enum TransactionTabType { progress, done, canceled, ordersMade, ordersReceived }

enum TransactionsType { donate, trade }

class UserTransationsDialog extends StatelessWidget {
  const UserTransationsDialog({
    super.key,
    required this.type,
    this.tab = TransactionTabType.progress,
  });

  final TransactionsType type;
  final TransactionTabType tab;
  final int _tabCount = 5;
  @override
  Widget build(BuildContext context) {
    return Layout(
      headerProps: HeaderProps(
        showLogo: false,
        showBackButton: true,
        title: type == TransactionsType.donate ? 'Doações' : 'Trocas',
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
            length: _tabCount,
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
                    tabs: const [
                      Tab(text: "Andamento"),
                      Tab(text: "Pedidos Recebidos"),
                      Tab(text: "Pedidos Feitos"),
                      Tab(text: "Concluido"),
                      Tab(text: "Cancelado"),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
