import 'package:app_flutter/controllers/auth_controller.dart';
import 'package:app_flutter/controllers/login_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  var loginController = Get.put(LoginController());
  var authController = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Column(
            children: [
              TextFormField(
                decoration: const InputDecoration(
                  hintText: 'Email',
                ),
                controller: loginController.emailController,
              ),
              TextFormField(
                decoration: const InputDecoration(
                  hintText: 'Password',
                ),
                controller: loginController.passwordController,
                obscureText: true,
              ),
              ElevatedButton(
                onPressed: loginController.login,
                child: const Text('Login'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
