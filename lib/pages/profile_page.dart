import 'package:app_flutter/components/bottom_profile.dart';
import 'package:app_flutter/components/button_action.dart';
import 'package:app_flutter/components/header.dart';
import 'package:app_flutter/components/layout.dart';
import 'package:app_flutter/components/profile_info.dart';
import 'package:app_flutter/components/transaction_painel.dart';
import 'package:app_flutter/configs/themes.dart';
import 'package:app_flutter/controllers/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
      child: Container(
        decoration: const BoxDecoration(
          color: lightGrey,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(pageRadius),
            topRight: Radius.circular(pageRadius),
          ),
        ),
        height: double.infinity,
        width: double.infinity,
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 20, left: 20, top: 24),
                child: ProfileInfo(
                  name: authController.user.value?.displayName ?? "Sem nome",
                  email: authController.user.value?.email ?? "Sem email",
                  image: "https://avatars.githubusercontent.com/u/47704204?v=4",
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
                onPressed: () {},
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}
