import 'package:app_flutter/configs/themes.dart';
import 'package:app_flutter/controllers/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SplashPage extends StatefulWidget {
  final bool withRedirect;
  const SplashPage({super.key, this.withRedirect = false});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!widget.withRedirect) return;
      var authController = Get.find<AuthController>();
      var pageToRedirect = authController.isLogged.value ? "/home" : "/login";
      Get.offAllNamed(pageToRedirect);
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
