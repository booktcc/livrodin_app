import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:livrodin/utils/alert.dart';
import 'package:livrodin/utils/snackbar.dart';

class AuthController extends GetxController {
  final FirebaseAuth firebaseAuth;

  final _user = Rx<User?>(null);

  AuthController({required this.firebaseAuth});

  Rx<User?> get user => _user.value.obs;

  RxBool get isLogged => (_user.value != null).obs;

  @override
  void onInit() {
    firebaseAuth.userChanges().listen((user) {
      _user.value = user;
    });
    super.onInit();
  }

  Future<UserCredential?> login(String email, String password) async {
    try {
      return await firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      Snackbar.error(e.message);
      return null;
    }
  }

  Future<UserCredential?> register(String email, String password) async {
    try {
      return await firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      Snackbar.error(e.message);
      return null;
    }
  }

  Future<void> logout() async {
    try {
      await firebaseAuth.signOut();
      await Get.offAllNamed("/login");
    } on FirebaseAuthException catch (e) {
      Snackbar.error(e.message);
    }
  }

  Future<void> resetPassword(String email) async {
    try {
      await firebaseAuth.sendPasswordResetEmail(email: email);
      Alert.info(
        title: "Sucesso",
        message: "Email de recuperação enviado com sucesso!",
        onConfirm: () => Get.offAllNamed("/login"),
      );
    } on FirebaseAuthException catch (e) {
      Snackbar.error(e.message);
    }
  }

  Future<bool> updatePassword(String password) async {
    try {
      await firebaseAuth.currentUser!.updatePassword(password);
      return true;
    } on FirebaseAuthException catch (e) {
      Snackbar.error(e.message);
      return false;
    }
  }

  Future<bool> updateEmail(String email) async {
    try {
      await firebaseAuth.currentUser!.updateEmail(email);
      return true;
    } on FirebaseAuthException catch (e) {
      Snackbar.error(e.message);
      return false;
    }
  }

  Future<bool> updateProfile(String name) async {
    try {
      await firebaseAuth.currentUser!.updateDisplayName(name);
      return true;
    } on FirebaseAuthException catch (e) {
      Snackbar.error(e.message);
      return false;
    }
  }

  Future<String?> updatePhoto(String photo) async {
    try {
      await firebaseAuth.currentUser!.updatePhotoURL(photo);
      return photo;
    } on FirebaseAuthException catch (e) {
      Snackbar.error(e.message);
      return null;
    }
  }

  Future<bool> deleteAccount() async {
    try {
      await firebaseAuth.currentUser!.delete();
      return true;
    } on FirebaseAuthException catch (e) {
      Snackbar.error(e.message);
      return false;
    }
  }
}
