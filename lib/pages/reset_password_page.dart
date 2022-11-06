import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:livrodin/components/button_action.dart';
import 'package:livrodin/components/input.dart';
import 'package:livrodin/components/layout.dart';
import 'package:livrodin/configs/themes.dart';
import 'package:livrodin/controllers/auth_controller.dart';
import 'package:livrodin/controllers/login_controller.dart';

class ResetPasswordPage extends StatefulWidget {
  const ResetPasswordPage({super.key});

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  var loginController = Get.find<LoginController>();
  var authController = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return Layout(
      child: Column(
        children: [
          SizedBox(height: context.mediaQueryPadding.top),
          SizedBox(
            height: context.height * 0.3,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Image.asset(
                      "assets/splash.png",
                      width: 177,
                      height: 214,
                      filterQuality: FilterQuality.high,
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            height: Get.height -
                context.height * 0.3 -
                context.mediaQueryPadding.top,
            decoration: const BoxDecoration(
              color: lightGrey,
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(pageRadius),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Row(
                      children: [
                        ButtonAction(
                          onPressed: () => Get.offAllNamed("/login"),
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
                          "Recuperar senha",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Form(
                    child: Column(
                      children: [
                        Input(
                          key: const Key("email"),
                          controller: loginController.emailController,
                          leftIcon: const Icon(
                            Icons.email_rounded,
                            color: grey,
                          ),
                          hintText: "Email",
                          autofillHints: const [
                            AutofillHints.email,
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  ButtonAction(
                    key: const Key("registerButton"),
                    onPressed: loginController.forgotPassword,
                    minWidth: double.infinity,
                    fontSize: 20,
                    label: "Resetar senha",
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: context.mediaQueryPadding.bottom),
        ],
      ),
    );
  }
}
