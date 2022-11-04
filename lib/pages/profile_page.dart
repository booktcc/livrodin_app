import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:livrodin/components/bottom_profile.dart';
import 'package:livrodin/components/button_action.dart';
import 'package:livrodin/components/header.dart';
import 'package:livrodin/components/layout.dart';
import 'package:livrodin/components/profile_info.dart';
import 'package:livrodin/components/transaction_painel.dart';
import 'package:livrodin/configs/themes.dart';
import 'package:livrodin/controllers/auth_controller.dart';

class ProfilePage extends StatelessWidget {
  ProfilePage({super.key});

  final authController = Get.find<AuthController>();
  @override
  Widget build(BuildContext context) {
    return Layout(
      headerProps: HeaderProps(
        showLogo: false,
        showBackButton: true,
        title: 'Perfil',
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {},
          ),
        ],
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
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 20, left: 20, top: 24),
                  child: ProfileInfo(
                    name: authController.user.value?.displayName ?? 'Sem nome',
                    email: authController.user.value?.email ?? 'Sem email',
                    image: authController.user.value?.photoURL ?? "",
                  ),
                ),
                const SizedBox(height: 24),
                const TransactionPainel(
                  icon: Icons.handshake_rounded,
                  title: 'Doações',
                ),
                const SizedBox(height: 10),
                const TransactionPainel(
                  icon: Icons.swap_horizontal_circle_rounded,
                  title: 'Trocas',
                ),
                const SizedBox(height: 10),
                const BottomProfile(),
                const SizedBox(height: 10),
                ButtonAction(
                  minWidth: 100,
                  icon: Icons.logout,
                  label: 'Sair',
                  onPressed: authController.logout,
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
