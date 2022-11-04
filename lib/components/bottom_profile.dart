import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:livrodin/components/button_option_profile.dart';
import 'package:livrodin/components/dialogs/user_list_rating.dart';

class BottomProfile extends StatelessWidget {
  const BottomProfile({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 10,
              offset: const Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ButtonOptionProfile(
                label: "Lista de Interesse",
                icon: Icons.book_rounded,
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
                onPressed: () => Get.dialog(UserListRatingDialig()),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
