import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Alert {
  static void info(
      {required String title,
      required String message,
      required Function() onConfirm}) {
    Get.dialog(
      AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: onConfirm,
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }
}
