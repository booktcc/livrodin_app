import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'auth_controller.dart';

class LoginController extends GetxController {
  final Rx<bool> isLoading = false.obs;
  final TextEditingController emailController = TextEditingController(text: "");
  final TextEditingController passwordController =
      TextEditingController(text: "");
  var authController = Get.find<AuthController>();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  Future<void> login() async {
    isLoading.value = true;
    if (formKey.currentState!.validate()) {
      var result = await authController.login(
        emailController.text,
        passwordController.text,
      );
      if (result == null) {
        isLoading.value = false;
        return;
      }
      await Get.offAllNamed("/home");
    }
  }

  Future<void> forgotPassword() async {
    await authController.resetPassword(emailController.text);
  }

  String? validateEmail(String? email) {
    if (email == null || email.isEmpty) {
      return "Campo obrigatório";
    } else if (!GetUtils.isEmail(email)) {
      return "Email inválido";
    }
    return null;
  }

  String? validatePassword(String? password) {
    if (password == null || password.isEmpty) {
      return "Campo obrigatório";
    } else if (password.length < 8) {
      return "A senha deve ter no mínimo 8 caracteres";
    }
    return null;
  }
}
