import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:livrodin/components/button_action.dart';
import 'package:livrodin/components/input.dart';
import 'package:livrodin/components/profile_icon.dart';
import 'package:livrodin/configs/themes.dart';
import 'package:livrodin/controllers/register_controller.dart';

class Step2 extends StatelessWidget {
  Step2({super.key});
  final registerController = Get.find<RegisterController>();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Row(
            children: [
              ButtonAction(
                onPressed: () =>
                    registerController.pageController.jumpToPage(0),
                icon: Icons.arrow_back_rounded,
                color: Colors.transparent,
                elevation: 0,
                textColor: Theme.of(context).primaryColor,
                radius: 360,
                minWidth: 40,
                minHeight: 40,
              ),
              const SizedBox(width: 10),
              const Text(
                "Cadastrar",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Form(
            child: Column(
              children: [
                GestureDetector(
                  onTap: registerController.pickImage,
                  child: Stack(
                    children: [
                      Obx(() {
                        return ProfileIcon(
                          image: registerController.image.value?.path,
                          imageType: ImageType.file,
                        );
                      }),
                      Positioned(
                        right: 0,
                        bottom: 0,
                        child: Icon(Icons.edit_rounded, color: grey),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Input(
                        key: const Key("name"),
                        controller: registerController.nameController,
                        leftIcon: const Icon(
                          Icons.account_circle_rounded,
                          color: grey,
                        ),
                        hintText: "Nome",
                        autofillHints: const [
                          AutofillHints.name,
                        ],
                      ),
                    ),
                    SizedBox(width: 5),
                    Expanded(
                      flex: 1,
                      child: Input(
                        key: const Key("lastName"),
                        controller: registerController.lastNameController,
                        hintText: "Sobrenome",
                        autofillHints: const [
                          AutofillHints.middleName,
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          ButtonAction(
            key: const Key("registerButton"),
            onPressed: registerController.register,
            minWidth: double.infinity,
            fontSize: 20,
            label: "Cadastrar",
          ),
        ],
      ),
    );
  }
}
