import 'package:app_flutter/components/button_option_badge.dart';
import 'package:app_flutter/configs/themes.dart';
import 'package:flutter/material.dart';

class TransactionPainel extends StatelessWidget {
  const TransactionPainel({
    super.key,
    this.radius = 20,
    required this.icon,
    required this.title,
  });

  final double radius;
  final IconData icon;
  final String title;
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
                          icon,
                          color: Colors.black,
                          size: 32,
                        ),
                        const SizedBox(width: 10),
                        Text(
                          title,
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
                        onTap: () {},
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
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ButtonOptionBadge(
                    iconData: Icons.book_rounded,
                    text: 'Pedidos Recebidos',
                    onPressed: () {},
                    badgeCount: 10,
                  ),
                  ButtonOptionBadge(
                    iconData: Icons.book_rounded,
                    text: 'Pedidos Feitos',
                    onPressed: () {},
                    badgeCount: 9,
                  ),
                  ButtonOptionBadge(
                    iconData: Icons.book_rounded,
                    text: 'Andamento',
                    onPressed: () {},
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
