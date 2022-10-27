import 'package:app_flutter/configs/themes.dart';
import 'package:app_flutter/controllers/auth_controller.dart';
import 'package:app_flutter/controllers/book_controller.dart';
import 'package:app_flutter/controllers/login_controller.dart';
import 'package:app_flutter/pages/book_availability_page.dart';
import 'package:app_flutter/pages/home_page.dart';
import 'package:app_flutter/pages/login_page.dart';
import 'package:app_flutter/pages/splash_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'App Book',
      theme: themeData,
      initialRoute: '/',
      getPages: [
        GetPage(
          name: '/',
          page: () => const SplashPage(),
        ),
        GetPage(
          name: '/login',
          page: () => const LoginPage(),
          binding: BindingsBuilder(() {
            Get.put(LoginController());
          }),
        ),
        GetPage(
          name: '/home',
          page: () => HomePage(),
        ),
        GetPage(
          name: '/book_availability',
          page: () => const BookAvailabilityPage(),
          binding: BindingsBuilder(() {
            Get.put(BookController());
          }),
        ),
      ],
      initialBinding: BindingsBuilder(() {
        Get.put(AuthController(), permanent: true);
      }),
    );
  }
}
