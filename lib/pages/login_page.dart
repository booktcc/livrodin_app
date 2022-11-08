import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:livrodin/components/button_action.dart';
import 'package:livrodin/components/input.dart';
import 'package:livrodin/components/layout.dart';
import 'package:livrodin/configs/themes.dart';
import 'package:livrodin/controllers/auth_controller.dart';
import 'package:livrodin/controllers/login_controller.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
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
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: loginController.loginAnonymous,
                          style: TextButton.styleFrom(
                            splashFactory: NoSplash.splashFactory,
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: const [
                              Text(
                                "Entrar como visitante",
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              Icon(
                                Icons.arrow_forward_rounded,
                                size: 24,
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Form(
                        key: loginController.formKey,
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
                              validator: loginController.validateEmail,
                            ),
                            const SizedBox(height: 20),
                            Input(
                              key: const Key("password"),
                              controller: loginController.passwordController,
                              leftIcon: const Icon(
                                Icons.password_rounded,
                                color: grey,
                              ),
                              hintText: "Senha",
                              autofillHints: const [
                                AutofillHints.password,
                              ],
                              obscureText: true,
                              validator: loginController.validatePassword,
                            ),
                          ],
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () => Get.toNamed("/forgot-password"),
                          child: RichText(
                            text: const TextSpan(
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                              children: [
                                TextSpan(
                                  text: "Esqueceu a senha?",
                                  style: TextStyle(
                                    color: Colors.black,
                                  ),
                                ),
                                TextSpan(
                                  text: " Recupere aqui",
                                  style: TextStyle(
                                    color: red,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      ButtonAction(
                        key: const Key("loginButton"),
                        onPressed: loginController.login,
                        minWidth: double.infinity,
                        fontSize: 20,
                        label: "Entrar",
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
                                  "Ou, faça login com",
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                GestureDetector(
                                  onTap: () => authController.loginGoogle(),
                                  child: SvgPicture.asset(
                                    "assets/icons/google_logo.svg",
                                    height: 50,
                                    width: 50,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextButton(
                        onPressed: () => Get.toNamed("/register"),
                        child: RichText(
                          text: const TextSpan(
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                            children: [
                              TextSpan(
                                text: "Não tem uma conta?",
                                style: TextStyle(
                                  color: Colors.black,
                                ),
                              ),
                              TextSpan(
                                text: " Cadastre-se aqui",
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
                Obx(
                  () => Visibility(
                    visible: loginController.isLoading.value,
                    child: Container(
                      width: double.infinity,
                      height: double.infinity,
                      color: Colors.black.withOpacity(0.5),
                      child: const Center(
                        child: CircularProgressIndicator(),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: context.mediaQueryPadding.bottom),
        ],
      ),
    );
  }
}
