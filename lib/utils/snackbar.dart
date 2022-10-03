import 'package:get/get.dart';

class Snackbar {
  static void error(String? message) {
    Get.snackbar(
      "Error",
      message ?? "Error",
      snackPosition: SnackPosition.BOTTOM,
    );
  }
}
