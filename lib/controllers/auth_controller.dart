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
    firebaseAuth.authStateChanges().listen((user) {
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

  Future<void> register(String email, String password) async {
    try {
      await firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      Snackbar.error(e.message);
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

  Future<void> updatePassword(String password) async {
    try {
      await firebaseAuth.currentUser!.updatePassword(password);
    } on FirebaseAuthException catch (e) {
      Snackbar.error(e.message);
    }
  }

  Future<void> updateEmail(String email) async {
    try {
      await firebaseAuth.currentUser!.updateEmail(email);
    } on FirebaseAuthException catch (e) {
      Snackbar.error(e.message);
    }
  }

  Future<void> updateProfile(String name) async {
    try {
      await firebaseAuth.currentUser!.updateDisplayName(name);
    } on FirebaseAuthException catch (e) {
      Snackbar.error(e.message);
    }
  }

  Future<void> updatePhoto(String photo) async {
    try {
      await firebaseAuth.currentUser!.updatePhotoURL(photo);
    } on FirebaseAuthException catch (e) {
      Snackbar.error(e.message);
    }
  }
}
