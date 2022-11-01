import 'package:livrodin/components/layout.dart';
import 'package:livrodin/configs/themes.dart';
import 'package:livrodin/controllers/auth_controller.dart';
import 'package:livrodin/controllers/login_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
    return SafeArea(
      child: Layout(child: LayoutBuilder(
        builder: (context, boxConstraints) {
          final double minSize =
              (boxConstraints.maxHeight - 240) / boxConstraints.maxHeight;
          return Stack(
            children: [
              Column(
                children: [
                  const SizedBox(
                    height: 22,
                  ),
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
              DraggableScrollableSheet(
                initialChildSize: minSize,
                maxChildSize: 1,
                minChildSize: minSize,
                builder: (context, scrollController) => ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(pageRadius),
                  ),
                  child: Container(
                    color: lightGrey,
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            TextButton(
                              onPressed: () {},
                              style: TextButton.styleFrom(
                                foregroundColor: Colors.black,
                              ),
                              child: Row(
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
                          ],
                        ),
                        Expanded(
                          child: Column(
                            children: [
                              const SizedBox(height: 20),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 34,
                                ),
                                child: Column(
                                  children: [
                                    TextField(
                                      key: const Key("email"),
                                      controller:
                                          loginController.emailController,
                                      decoration: const InputDecoration(
                                        labelText: "Email",
                                      ),
                                    ),
                                    const SizedBox(height: 20),
                                    TextField(
                                      key: const Key("password"),
                                      controller:
                                          loginController.passwordController,
                                      decoration: const InputDecoration(
                                        labelText: "Senha",
                                      ),
                                      obscureText: true,
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        // 'Esqueceu a senha?' in black 'Recupere aqui' in red
                                        TextButton(
                                          onPressed: () {},
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
                                      ],
                                    ),
                                    const SizedBox(height: 20),
                                    ElevatedButton(
                                      key: const Key("loginButton"),
                                      onPressed: loginController.login,
                                      style: ElevatedButton.styleFrom(
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                        minimumSize: const Size(
                                          double.infinity,
                                          40,
                                        ),
                                      ),
                                      child: const Text(
                                        "Entrar",
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      )),
    );
  }
}
