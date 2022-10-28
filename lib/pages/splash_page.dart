import 'package:app_flutter/configs/themes.dart';
import 'package:app_flutter/controllers/auth_controller.dart';
import 'package:app_flutter/controllers/book_controller.dart';
import 'package:app_flutter/controllers/login_controller.dart';
import 'package:app_flutter/pages/home_page.dart';
import 'package:app_flutter/pages/login_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  var authController = Get.find<AuthController>();
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      var pageToRedirect =
          authController.isLogged.value ? HomePage() : const LoginPage();
      Get.to(
        () => pageToRedirect,
        binding: BindingsBuilder(() {
          Get.put(LoginController());
          Get.put(BookController());
        }),
        transition: Transition.fadeIn,
        duration: const Duration(milliseconds: 1000),
        curve: Curves.easeIn,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        color: red,
        child: const Center(
          child: Directionality(
            textDirection: TextDirection.ltr,
            child: Text(
              "Livrodin",
              style: TextStyle(
                fontSize: 18,
                letterSpacing: 8,
                fontWeight: FontWeight.w800,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
