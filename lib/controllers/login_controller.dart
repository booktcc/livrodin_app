import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'auth_controller.dart';

class LoginController extends GetxController {
  final TextEditingController emailController = TextEditingController(text: "");
  final TextEditingController passwordController =
      TextEditingController(text: "");
  var authController = Get.find<AuthController>();
  Future<void> login() async {
    var result = await authController.login(
      emailController.text,
      passwordController.text,
    );
    if (result == null) return;
    await Get.offAllNamed("/home");
  }

  Future<void> forgotPassword() async {
    await authController.resetPassword(emailController.text);
  }
}
