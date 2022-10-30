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
      child: Scaffold(
        body: Center(
          child: Column(
            children: [
              TextFormField(
                key: const Key('email'),
                decoration: const InputDecoration(
                  hintText: 'Email',
                ),
                controller: loginController.emailController,
              ),
              TextFormField(
                key: const Key('password'),
                decoration: const InputDecoration(
                  hintText: 'Password',
                ),
                controller: loginController.passwordController,
                obscureText: true,
              ),
              ElevatedButton(
                key: const Key('login'),
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
