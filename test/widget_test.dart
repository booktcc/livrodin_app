// ignore_for_file: avoid_print

import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:get/get.dart';
import 'package:livrodin/controllers/auth_controller.dart';
import 'package:livrodin/controllers/book_controller.dart';
import 'package:livrodin/controllers/login_controller.dart';
import 'package:livrodin/models/book.dart';
import 'package:livrodin/pages/home_page.dart';
import 'package:livrodin/pages/login_page.dart';
import 'package:livrodin/services/book_service.dart';
import 'package:network_image_mock/network_image_mock.dart';

import 'utils/fake_data.dart';

void main() async {
  testWidgets('Should login', (WidgetTester tester) async {
    disableOverflowErrors();

    final auth = MockFirebaseAuth(mockUser: mockedUser);
    final authController = Get.put(AuthController(firebaseAuth: auth));

    final firestore = FakeFirebaseFirestore();

    await mockNetworkImagesFor(
      () async {
        await tester.pumpWidget(
          GetMaterialApp(
            initialRoute: "/login",
            getPages: [
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
                binding: BindingsBuilder(() {
                  Get.put(BookService(firestore: firestore));
                  Get.put(BookController());
                }),
              ),
            ],
          ),
        );
        Finder emailField = find.byKey(const Key('email'));
        await tester.enterText(emailField, mockedUser.email!);

        Finder passwordField = find.byKey(const Key('password'));
        await tester.enterText(passwordField, '123456');

        Finder loginButton = find.byKey(const Key('loginButton'));
        await tester.tap(loginButton);

        await tester.pumpAndSettle();

        expect(authController.isLogged.value, true);
        expect(find.byType(HomePage), findsOneWidget);
      },
    );
  });
  testWidgets('Should render Home Page with an Book available',
      (WidgetTester tester) async {
    disableOverflowErrors();

    final auth = MockFirebaseAuth(mockUser: mockedUser);

    final authController = Get.put(AuthController(firebaseAuth: auth));

    await authController.login(mockedUser.email!, "123456");

    final firestore = FakeFirebaseFirestore();

    await firestore.collection("BookAvailable").doc().set(
          fakeBook.toFireStore(
            idUser: mockedUser.uid,
            availableType: BookAvailableType.both,
          ),
        );

    // Build our app and trigger a frame.
    await mockNetworkImagesFor(
      () async {
        await tester.pumpWidget(
          GetMaterialApp(
            initialBinding: BindingsBuilder(() {
              Get.put(BookService(firestore: firestore));
              Get.put(BookController());
            }),
            home: HomePage(),
          ),
        );
        await tester.idle();
        await tester.pump();

        expect(find.text("Harry Potter e a Ordem da Fênix"), findsOneWidget);
      },
    );
  });
}

void disableOverflowErrors() {
  FlutterError.onError = (FlutterErrorDetails details) {
    final exception = details.exception;
    final isOverflowError = exception is FlutterError &&
        !exception.diagnostics.any(
            (e) => e.value.toString().startsWith("A RenderFlex overflowed by"));

    if (isOverflowError) {
      print(details);
    } else {
      FlutterError.presentError(details);
    }
  };
}
