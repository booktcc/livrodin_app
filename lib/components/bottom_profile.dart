import 'package:app_flutter/components/button_option_profile.dart';
import 'package:flutter/material.dart';

class BottomProfile extends StatelessWidget {
  const BottomProfile({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Ink(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 10,
              offset: const Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ButtonOptionProfile(
              label: "Lista de Interesse",
              icon: Icons.book_rounded,
              topLeftRadius: 20,
              topRightRadius: 20,
              onPressed: () {},
            ),
            ButtonOptionProfile(
              label: "Livros Disponibilizados",
              icon: Icons.book_rounded,
              onPressed: () {},
            ),
            ButtonOptionProfile(
              label: "Livros Avaliados",
              icon: Icons.stars_rounded,
              bottomLeftRadius: 20,
              bottomRightRadius: 20,
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}
