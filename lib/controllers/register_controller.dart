import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:livrodin/configs/themes.dart';
import 'package:livrodin/controllers/auth_controller.dart';

class RegisterController extends GetxController {
  final TextEditingController nameController = TextEditingController(text: "");
  final TextEditingController lastNameController =
      TextEditingController(text: "");
  final TextEditingController emailController = TextEditingController(text: "");
  final TextEditingController passwordController =
      TextEditingController(text: "");
  final TextEditingController confirmPasswordController =
      TextEditingController(text: "");
  final Rx<CroppedFile?> image = Rx(null);
  final PageController pageController = PageController(initialPage: 0);
  final GlobalKey<FormState> formKeyStep1 = GlobalKey<FormState>();
  final GlobalKey<FormState> formKeyStep2 = GlobalKey<FormState>();

  var authController = Get.find<AuthController>();
  Future<void> register() async {
    await authController.register(
      emailController.text,
      passwordController.text,
    );
    await authController.login(
      emailController.text,
      passwordController.text,
    );

    if (image.value != null) {
      try {
        var snapshot = await FirebaseStorage.instance
            .ref("Users")
            .child(authController.user.value!.uid)
            .putFile(File(image.value!.path));
        await authController.updatePhoto(await snapshot.ref.getDownloadURL());
      } catch (e) {
        Get.snackbar("Error", e.toString());
      }
    }
    await authController.updateProfile(nameController.text);

    await FirebaseFirestore.instance
        .collection("Users")
        .doc(authController.user.value!.uid)
        .set(
      {
        "name": nameController.text,
        "lastName": lastNameController.text,
        "email": emailController.text,
        "profilePictureUrl": authController.user.value!.photoURL,
      },
    );
    await Get.offAllNamed("/home");
  }

  Future<void> pickImage() async {
    try {
      XFile? pickedFile = await ImagePicker().pickImage(
        source: ImageSource.gallery,
      );
      image.value = await ImageCropper().cropImage(
        cropStyle: CropStyle.circle,
        sourcePath: pickedFile!.path,
        compressFormat: ImageCompressFormat.jpg,
        aspectRatio: const CropAspectRatio(
          ratioX: 1,
          ratioY: 1,
        ),
        compressQuality: 100,
        uiSettings: [
          AndroidUiSettings(
            toolbarColor: dark,
            showCropGrid: false,
            toolbarWidgetColor: Colors.white,
            cropFrameColor: red,
            hideBottomControls: true,
            backgroundColor: dark,
            initAspectRatio: CropAspectRatioPreset.square,
            lockAspectRatio: true,
          ),
          IOSUiSettings(
            hidesNavigationBar: true,
            aspectRatioLockEnabled: true,
          ),
          WebUiSettings(
            context: Get.context!,
            presentStyle: CropperPresentStyle.dialog,
            boundary: const CroppieBoundary(
              width: 520,
              height: 520,
            ),
            viewPort:
                const CroppieViewPort(width: 480, height: 480, type: 'circle'),
            enableExif: true,
            enableZoom: true,
            showZoomer: true,
          ),
        ],
      );
    } catch (e) {
      Get.snackbar("Error", e.toString());
    }
  }

  void nextStep() {
    if (pageController.page == 0) {
      if (formKeyStep1.currentState!.validate()) {
        pageController.jumpToPage(1);
      }
    } else if (pageController.page == 1) {
      if (formKeyStep2.currentState!.validate()) {
        register();
      }
    }
  }

  void previousStep() {
    nameController.clear();
    lastNameController.clear();
    image.value = null;
    pageController.jumpToPage(0);
  }

  String? validateName(String? name) {
    if (name == null || name.isEmpty) {
      return "Campo obrigatório";
    }
    return null;
  }

  String? validateLastName(String? lastName) {
    return null;
  }

  String? validateEmail(String? email) {
    if (email == null || email.isEmpty) {
      return "Campo obrigatório";
    } else if (!GetUtils.isEmail(email)) {
      return "Email inválido";
    }
    return null;
  }

  String? validatePassword(String? password) {
    if (password == null || password.isEmpty) {
      return "Campo obrigatório";
    } else if (password.length < 8) {
      return "A senha deve ter no mínimo 8 caracteres";
    }
    return null;
  }

  String? validateConfirmPassword(String? password) {
    if (password == null || password.isEmpty) {
      return "Campo obrigatório";
    }
    if (password != passwordController.text) {
      return "Senhas não conferem";
    }
    return null;
  }
}
