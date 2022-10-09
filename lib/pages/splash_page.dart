import 'package:app_flutter/configs/themes.dart';
import 'package:app_flutter/controllers/auth_controller.dart';
import 'package:app_flutter/pages/home_page.dart';
import 'package:app_flutter/pages/login_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:page_transition/page_transition.dart';

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
          authController.isLogged.value ? const HomePage() : const LoginPage();
      Navigator.pushReplacement(
        context,
        PageTransition(
          type: PageTransitionType.fade,
          child: pageToRedirect,
          childCurrent: widget,
          duration: const Duration(seconds: 1),
          curve: Curves.easeOut,
        ),
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
