import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:livrodin/configs/themes.dart';
import 'package:livrodin/controllers/auth_controller.dart';
import 'package:livrodin/services/user_service.dart';

class ProfileEditController extends GetxController {
  final Rx<bool> isLoading = false.obs;
  late final TextEditingController nameController;
  late final TextEditingController lastNameController;
  late final TextEditingController emailController;
  late final TextEditingController passwordController;
  late final TextEditingController confirmPasswordController;
  late final Rx<CroppedFile?> image;

  final GlobalKey<FormState> formKeyStep1 = GlobalKey<FormState>();
  final GlobalKey<FormState> formKeyStep2 = GlobalKey<FormState>();

  final AuthController authController;
  final UserService userService;
  ProfileEditController({
    required this.userService,
    required this.authController,
  }) {
    nameController = TextEditingController(
      text: authController.user.value?.displayName ?? "",
    );
    lastNameController = TextEditingController(text: "");
    emailController = TextEditingController(
      text: authController.user.value?.email ?? "",
    );
    passwordController = TextEditingController(text: "");
    confirmPasswordController = TextEditingController(text: "");
    image = Rx(null);
  }

  Future<void> register() async {
    isLoading.value = true;
    await authController.register(
      emailController.text,
      passwordController.text,
    );
    await authController.login(
      emailController.text,
      passwordController.text,
    );
    if (authController.user.value == null) {
      isLoading.value = false;
      return;
    }

    final photoUrl = await userService.uploadUserPhoto(image.value?.path);
    if (photoUrl != null) await authController.updatePhoto(photoUrl);
    await authController.updateProfile(nameController.text);

    await userService.createUser();
    await Get.offAllNamed("/home");
  }

  Future<void> updateImage() async {
    isLoading.value = true;
    try {
      XFile? pickedFile = await ImagePicker().pickImage(
        source: ImageSource.gallery,
      );
      final CroppedFile? file = await ImageCropper().cropImage(
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

      final photoUrl = await userService.uploadUserPhoto(file?.path);
      if (photoUrl != null) {
        await authController.updatePhoto(photoUrl);
        userService.updateUser();
        image.value = file;
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
    }
    isLoading.value = false;
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
