import 'package:livrodin/utils/snackbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class AuthController extends GetxController {
  final _user = Rx<User?>(FirebaseAuth.instance.currentUser);

  Rx<User?> get user => _user.value.obs;

  RxBool get isLogged => (_user.value != null).obs;

  @override
  void onInit() {
    _user.bindStream(FirebaseAuth.instance.authStateChanges());
    super.onInit();
  }

  Future<UserCredential?> login(String email, String password) async {
    try {
      return await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      Snackbar.error(e.message);
      return null;
    }
  }

  Future<void> register(String email, String password) async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      Snackbar.error(e.message);
    }
  }

  Future<void> logout() async {
    try {
      await FirebaseAuth.instance.signOut();
      await Get.offAllNamed("/login");
    } on FirebaseAuthException catch (e) {
      Snackbar.error(e.message);
    }
  }

  Future<void> resetPassword(String email) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      Snackbar.error(e.message);
    }
  }

  Future<void> updatePassword(String password) async {
    try {
      await FirebaseAuth.instance.currentUser!.updatePassword(password);
    } on FirebaseAuthException catch (e) {
      Snackbar.error(e.message);
    }
  }

  Future<void> updateEmail(String email) async {
    try {
      await FirebaseAuth.instance.currentUser!.updateEmail(email);
    } on FirebaseAuthException catch (e) {
      Snackbar.error(e.message);
    }
  }

  Future<void> updateProfile(String name) async {
    try {
      await FirebaseAuth.instance.currentUser!.updateDisplayName(name);
    } on FirebaseAuthException catch (e) {
      Snackbar.error(e.message);
    }
  }

  Future<void> updatePhoto(String photo) async {
    try {
      await FirebaseAuth.instance.currentUser!.updatePhotoURL(photo);
    } on FirebaseAuthException catch (e) {
      Snackbar.error(e.message);
    }
  }
}
