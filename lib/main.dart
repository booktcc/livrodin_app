import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:livrodin/configs/themes.dart';
import 'package:livrodin/controllers/auth_controller.dart';
import 'package:livrodin/controllers/book_controller.dart';
import 'package:livrodin/controllers/login_controller.dart';
import 'package:livrodin/controllers/register_controller.dart';
import 'package:livrodin/pages/book_availability_page.dart';
import 'package:livrodin/pages/home_page.dart';
import 'package:livrodin/pages/login_page.dart';
import 'package:livrodin/pages/profile_edit_page.dart';
import 'package:livrodin/pages/profile_page.dart';
import 'package:livrodin/pages/register_page.dart';
import 'package:livrodin/pages/reset_password_page.dart';
import 'package:livrodin/services/book_service.dart';
import 'package:livrodin/services/user_service.dart';

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
    var userLogged = FirebaseAuth.instance.currentUser;
    var isLogged = userLogged != null;
    return GetMaterialApp(
      enableLog: false,
      debugShowCheckedModeBanner: false,
      title: 'App Book',
      theme: themeData,
      initialRoute: isLogged ? '/home' : '/login',
      defaultTransition: Transition.fade,
      getPages: [
        GetPage(
          name: '/login',
          page: () => const LoginPage(),
          binding: BindingsBuilder(() {
            Get.put(LoginController());
          }),
        ),
        GetPage(
          name: '/forgot-password',
          page: () => const ResetPasswordPage(),
          binding: BindingsBuilder(() {
            Get.put(LoginController());
          }),
        ),
        GetPage(
          name: '/register',
          page: () => const RegisterPage(),
          binding: BindingsBuilder(() {
            Get.put(
              RegisterController(
                userService: UserService(
                  firestore: FirebaseFirestore.instance,
                  storage: FirebaseStorage.instance,
                ),
                authController: Get.find<AuthController>(),
              ),
            );
          }),
        ),
        GetPage(
          name: '/home',
          page: () => HomePage(),
          binding: BindingsBuilder(() {
            Get.put(BookService(firestore: FirebaseFirestore.instance));
            Get.put(BookController());
          }),
        ),
        GetPage(
          name: '/book/availability',
          page: () => const BookAvailabilityPage(),
          binding: BindingsBuilder(() {
            Get.put(BookController());
          }),
        ),
        GetPage(
          name: '/profile',
          page: () => ProfilePage(),
          binding: BindingsBuilder(() {
            Get.put(BookController());
          }),
        ),
        GetPage(
          name: '/profile/edit',
          page: () => ProfileEditPage(),
        ),
      ],
      initialBinding: BindingsBuilder(() {
        Get.put(AuthController(firebaseAuth: FirebaseAuth.instance),
            permanent: true);
      }),
    );
  }
}
