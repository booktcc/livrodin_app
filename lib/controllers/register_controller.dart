import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:livrodin/configs/themes.dart';
import 'package:livrodin/controllers/auth_controller.dart';
import 'package:livrodin/models/user.dart';
import 'package:livrodin/services/user_service.dart';

class RegisterController extends GetxController {
  final Rx<bool> isLoading = false.obs;
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

  final AuthController authController;
  final UserService userService;
  RegisterController({required this.userService, required this.authController});

  Future<void> register() async {
    isLoading.value = true;
    var registerResult = await authController.register(
      emailController.text,
      passwordController.text,
    );
    if (registerResult == null) {
      isLoading.value = false;
      return;
    }
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

    await userService.createUser(
      User(
        id: authController.user.value!.uid,
        name: nameController.text,
        lastName: lastNameController.text,
        email: emailController.text,
        profilePictureUrl: photoUrl,
      ),
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
      printError(info: e.toString());
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

  Future<void> registerWithGoogle() async {
    isLoading.value = true;
    var result = await authController.loginGoogle();
    if (result == null) {
      isLoading.value = false;
      return;
    }
    await Get.offAllNamed("/home");
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
