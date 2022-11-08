import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:livrodin/configs/constants.dart';
import 'package:livrodin/controllers/auth_controller.dart';
import 'package:livrodin/models/user.dart';

class UserService extends GetxService {
  var authController = Get.find<AuthController>();
  final FirebaseFirestore firestore;
  final FirebaseStorage storage;

  UserService({required this.firestore, required this.storage});

  Future<void> createUser(User user) async {
    await firestore
        .collection(collectionUsers)
        .doc(authController.user.value!.uid)
        .set(user.toFirestore());
  }

  Future<void> updateUser(User user) async {
    await firestore
        .collection(collectionUsers)
        .doc(authController.user.value!.uid)
        .update(user.toFirestore());
  }

  Future<String?> uploadUserPhoto(String? file) async {
    if (file == null) return null;
    try {
      var snapshot = await storage
          .ref(storageUsers)
          .child(authController.user.value!.uid)
          .putFile(File(file));
      return await snapshot.ref.getDownloadURL();
    } catch (e) {
      return null;
    }
  }
}
