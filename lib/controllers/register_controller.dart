import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:livrodin/controllers/auth_controller.dart';

class RegisterController extends GetxController {
  final TextEditingController nameController = TextEditingController(text: "");
  final TextEditingController lastNameController =
      TextEditingController(text: "");
  final TextEditingController emailController = TextEditingController(text: "");
  final TextEditingController passwordController =
      TextEditingController(text: "");
  final TextEditingController confirmPasswordController =
      TextEditingController(text: "");
  var authController = Get.find<AuthController>();
  Future<void> register() async {
    await authController.register(
      emailController.text,
      passwordController.text,
    );
  }
}
