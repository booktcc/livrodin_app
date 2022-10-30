// ignore_for_file: avoid_print

import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:get/get.dart';
import 'package:livrodin/controllers/auth_controller.dart';
import 'package:livrodin/controllers/book_controller.dart';
import 'package:livrodin/pages/home_page.dart';
import 'package:livrodin/services/book_service.dart';
import 'package:network_image_mock/network_image_mock.dart';

void main() async {
  testWidgets('Should render Home Page with an Book available',
      (WidgetTester tester) async {
    disableOverflowErrors();
    final mockedUser = MockUser(
      isAnonymous: false,
      uid: 'someuid',
      email: 'bob@somedomain.com',
      displayName: 'Bob',
    );
    final auth = MockFirebaseAuth(mockUser: mockedUser);

    final authController = Get.put(AuthController(firebaseAuth: auth));

    await authController.login("bob@somedomain.com", "123456");

    final firestore = FakeFirebaseFirestore();

    await firestore.collection("BookAvailable").doc().set({
      "idBook": "VTeU5dQYAmQ3fK6bZkis",
      "title": "Harry Potter e a Ordem da Fênix",
      "coverUrl": "",
      "idUser": "someuid",
      "createdAt": DateTime.now(),
      "forDonation": true,
      "forTrade": true,
    });

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
        expect(find.text('Harry Potter e a Ordem da Fênix'), findsOneWidget);
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
