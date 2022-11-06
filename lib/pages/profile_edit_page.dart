import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:livrodin/components/button_action.dart';
import 'package:livrodin/components/button_option_profile.dart';
import 'package:livrodin/components/header.dart';
import 'package:livrodin/components/layout.dart';
import 'package:livrodin/components/profile_icon.dart';
import 'package:livrodin/configs/themes.dart';
import 'package:livrodin/controllers/auth_controller.dart';
import 'package:livrodin/controllers/profile_edit_controller.dart';

class ProfileEditPage extends StatelessWidget {
  ProfileEditPage({super.key});

  final authController = Get.find<AuthController>();
  final profileEditController = Get.find<ProfileEditController>();

  @override
  Widget build(BuildContext context) {
    return Layout(
      headerProps: HeaderProps(
        showLogo: false,
        showBackButton: true,
        title: 'Editar Perfil',
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
          child: Stack(
            children: [
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: GestureDetector(
                      onTap: profileEditController.updateImage,
                      child: SizedBox(
                        width: 100,
                        child: Stack(
                          alignment: Alignment.center,
                          fit: StackFit.loose,
                          children: [
                            Obx(
                              () {
                                final isNetworkImage =
                                    profileEditController.image.value == null
                                        ? true
                                        : false;
                                return ProfileIcon(
                                  image: isNetworkImage
                                      ? authController.user.value?.photoURL
                                      : profileEditController.image.value?.path,
                                  imageType: isNetworkImage
                                      ? ImageType.network
                                      : ImageType.file,
                                );
                              },
                            ),
                            const Positioned(
                              child: Icon(
                                Icons.camera_alt_rounded,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 20),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            spreadRadius: 1,
                            blurRadius: 10,
                            offset: const Offset(
                                0, 3), // changes position of shadow
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ButtonOptionProfile(
                              label: "Editar Informações",
                              icon: Icons.account_circle_rounded,
                              onPressed: profileEditController.editProfileInfo,
                            ),
                            ButtonOptionProfile(
                              label: "Editar Email",
                              icon: Icons.email_rounded,
                              onPressed: profileEditController.editEmail,
                            ),
                            ButtonOptionProfile(
                              label: "Editar Senha",
                              icon: Icons.password_rounded,
                              onPressed: profileEditController.editPassword,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: ButtonAction(
                          label: "Deletar Conta",
                          onPressed: profileEditController.deleteAccount,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Obx(
                () {
                  return profileEditController.isLoading.value
                      ? Container(
                          color: Colors.black.withOpacity(0.5),
                          child: const Center(
                            child: CircularProgressIndicator(),
                          ),
                        )
                      : const SizedBox();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
