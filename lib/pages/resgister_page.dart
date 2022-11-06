import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:livrodin/components/layout.dart';
import 'package:livrodin/configs/themes.dart';
import 'package:livrodin/controllers/auth_controller.dart';
import 'package:livrodin/controllers/register_controller.dart';
import 'package:livrodin/pages/register_page/step1.dart';
import 'package:livrodin/pages/register_page/step2.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  var registerController = Get.find<RegisterController>();
  var authController = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    final headerHeigth = MediaQuery.of(context).size.height * 0.3;
    final bodyHeight = MediaQuery.of(context).size.height -
        headerHeigth -
        context.mediaQueryPadding.top -
        context.mediaQueryPadding.bottom;
    return Layout(
      child: Column(
        children: [
          SizedBox(height: context.mediaQueryPadding.top),
          SizedBox(
            height: headerHeigth,
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
            height: bodyHeight,
            decoration: const BoxDecoration(
              color: lightGrey,
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(pageRadius),
              ),
            ),
            child: PageView(
              controller: registerController.pageController,
              physics: const NeverScrollableScrollPhysics(),
              children: [Step1(), Step2()],
            ),
          ),
        ],
      ),
    );
  }
}
