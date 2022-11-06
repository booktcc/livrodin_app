import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:livrodin/configs/constants.dart';
import 'package:livrodin/controllers/auth_controller.dart';

class UserService extends GetxService {
  var authController = Get.find<AuthController>();
  final FirebaseFirestore firestore;
  final FirebaseStorage storage;

  UserService({required this.firestore, required this.storage});

  Future<void> createUser() async {
    await firestore
        .collection(collectionUsers)
        .doc(authController.user.value!.uid)
        .set({
      "name": authController.user.value?.displayName,
      "lastName": "",
      "email": authController.user.value?.email,
      "profilePictureUrl": authController.user.value?.photoURL,
    });
  }

  Future<void> updateUser(
      {String? name,
      String? lastName,
      String? email,
      String? profilePictureUrl}) async {
    await firestore
        .collection(collectionUsers)
        .doc(authController.user.value!.uid)
        .update({
      "name": name,
      "lastName": lastName,
      "email": email,
      "profilePictureUrl": profilePictureUrl,
    });
  }

  Future<String?> uploadUserPhoto(File file) async {
    try {
      var snapshot = await storage
          .ref(storageUsers)
          .child(authController.user.value!.uid)
          .putFile(file);
      return await snapshot.ref.getDownloadURL();
    } catch (e) {
      return null;
    }
  }
}
