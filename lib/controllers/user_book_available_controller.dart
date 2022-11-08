import 'dart:developer';

import 'package:get/get.dart';
import 'package:livrodin/controllers/book_controller.dart';
import 'package:livrodin/models/availability.dart';
import 'package:livrodin/models/user.dart';
import 'package:livrodin/utils/state_machine.dart';

class UserBookAvailableController extends GetxController {
  final User user;

  final BookController _bookController = Get.find<BookController>();

  UserBookAvailableController({required this.user});

  RxList<Availability> availabilityList = <Availability>[].obs;

  Rx<FetchState> fetchState = FetchState.loading.obs;

  @override
  void onInit() {
    super.onInit();
    _getAvailableBooksFromUser();
  }

  _getAvailableBooksFromUser() {
    _bookController.getAvailableBooksFromUser(user).then((value) {
      availabilityList.value = value;
      inspect(value);
    }).catchError((e) {
      printError(info: e.toString());
      fetchState.value = FetchState.error;
    }).whenComplete(() {
      fetchState.value = FetchState.success;
    });
  }
}
