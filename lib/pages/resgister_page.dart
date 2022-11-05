import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:livrodin/components/button_action.dart';
import 'package:livrodin/components/input.dart';
import 'package:livrodin/components/layout.dart';
import 'package:livrodin/configs/themes.dart';
import 'package:livrodin/controllers/auth_controller.dart';
import 'package:livrodin/controllers/register_controller.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  var registerController = Get.find<RegisterController>();
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
                          "Cadastrar",
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
                          controller: registerController.emailController,
                          leftIcon: const Icon(
                            Icons.email_rounded,
                            color: grey,
                          ),
                          hintText: "Email",
                          autofillHints: const [
                            AutofillHints.email,
                          ],
                        ),
                        const SizedBox(height: 10),
                        Input(
                          key: const Key("password"),
                          controller: registerController.passwordController,
                          leftIcon: const Icon(
                            Icons.password_rounded,
                            color: grey,
                          ),
                          hintText: "Senha",
                          autofillHints: const [
                            AutofillHints.newPassword,
                          ],
                          obscureText: true,
                        ),
                        const SizedBox(height: 10),
                        Input(
                          key: const Key("confirm_password"),
                          controller:
                              registerController.confirmPasswordController,
                          leftIcon: const Icon(
                            Icons.password_rounded,
                            color: grey,
                          ),
                          hintText: "Confirmar Senha",
                          autofillHints: const [
                            AutofillHints.newPassword,
                          ],
                          obscureText: true,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  ButtonAction(
                    key: const Key("registerButton"),
                    onPressed: () {},
                    minWidth: double.infinity,
                    fontSize: 20,
                    label: "Avançar",
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 250,
                          decoration: const BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: grey,
                                width: 1,
                              ),
                            ),
                          ),
                          child: const Center(
                            child: Text(
                              "Ou, registre-se com",
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                              iconSize: 40,
                              onPressed: () {},
                              icon: const Icon(
                                Icons.facebook_rounded,
                                color: grey,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextButton(
                    onPressed: () => Get.offAllNamed("/login"),
                    child: RichText(
                      text: const TextSpan(
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                        children: [
                          TextSpan(
                            text: "Já tem uma conta?",
                            style: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                          TextSpan(
                            text: " Faça login",
                            style: TextStyle(
                              color: red,
                            ),
                          ),
                        ],
                      ),
                    ),
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
