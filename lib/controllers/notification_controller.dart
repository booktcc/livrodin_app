import 'dart:async';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:livrodin/configs/constants.dart';
import 'package:livrodin/models/notification.dart';
import 'package:livrodin/services/book_service.dart';
import 'package:livrodin/utils/state_machine.dart';

class NotificationController extends GetxController {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final BookService _bookService =
      BookService(firestore: FirebaseFirestore.instance);

  final notifications = <Notificaton>[].obs;

  final notificationsFilled = <NotificationFilled>[].obs;
  Rx<FetchState> fetchState = FetchState.loading.obs;

  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>? _subscription;

  @override
  void onInit() {
    super.onInit();
    if (FirebaseAuth.instance.currentUser != null) {
      _listenNotifications();
    }
    FirebaseAuth.instance.userChanges().listen((user) {
      if (user != null) {
        _listenNotifications();
      } else {
        _subscription?.cancel();
      }
    });
  }

  @override
  void onClose() {
    _subscription?.cancel();
    super.onClose();
  }

  void _listenNotifications() {
    _subscription = firestore
        .collection(collectionUsers)
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('Notification')
        .snapshots()
        .listen((event) {
      notifications.value = event.docs.map((e) {
        var data = e.data();
        inspect(data);
        return Notificaton.fromJson(data, e.id);
      }).toList();
    });
  }

  getFilledNotifications() async {
    inspect(notifications);
    fetchState.value = FetchState.loading;
    var usersIds = notifications.map((e) => e.userId).toSet().toList();
    var users = await _bookService.getUsersByIds(usersIds);
    notificationsFilled.value = await Future.wait(notifications.map((e) async {
      return NotificationFilled(
          notification: e,
          user: users.firstWhere((element) => element.id == e.userId));
    }));
    fetchState.value = FetchState.success;
  }

  deleteAllNotifications() async {
    await firestore
        .collection(collectionUsers)
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('Notification')
        .get()
        .then((value) {
      for (DocumentSnapshot ds in value.docs) {
        ds.reference.delete();
      }
    });

    notificationsFilled.value = [];
  }

  deleteNotification(String id) async {
    firestore
        .collection(collectionUsers)
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('Notification')
        .doc(id)
        .delete();

    notificationsFilled.removeWhere((element) => element.notification.id == id);
  }
}
