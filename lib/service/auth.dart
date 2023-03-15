// ignore_for_file: use_build_context_synchronously, depend_on_referenced_packages

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sportify/screens/edit_profile.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'dataBase.dart';

class AuthService extends GetxController {
  final _auth = FirebaseAuth.instance;
  // final storage = new FlutterSecureStorage();

  Future<String> createAccount(
      {required String email, required String password}) async {
    UserCredential userCredential;
    if (isEmailAlreadyRegistered(email) == Future.value(true)) {
      return 'Email Already Exists';
    } else {
      userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    }
    print(userCredential);
    return 'Account created';
  }

//Sign In
  Future<String> signIn(
      {required String email, required String password}) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      return 'Success';
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return 'No user found for that email.';
      } else if (e.code == 'wrong-password') {
        return 'Wrong password provided for that user.';
      }
    }
    return 'Success';
  }

  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [
      'email',
      'https://www.googleapis.com/auth/contacts.readonly',
    ],
  );

  final storage = const FlutterSecureStorage();
  Future<void> googleSignIn(BuildContext context) async {
    try {
      GoogleSignInAccount? googleSignInAccount = await _googleSignIn.signIn();
      GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount!.authentication;
      AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );
      if (googleSignInAccount != null) {
        UserCredential userCredential =
            await _auth.signInWithCredential(credential);
        storeTokenAndData(userCredential);
        await DatabaseService(uid: userCredential.user!.uid).updateUserData(
            userCredential.user!.displayName.toString(),
            userCredential.user!.email.toString(),
            userCredential.user!.phoneNumber.toString(),
            'password',
            '',
            '');
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (builder) => SettingsForm()),
            (route) => false);

        // final snackBar =
        // SnackBar(content: Text(userCredential.user!.uid));
        // ignore: unnecessary_statements
        // ScaffoldMessenger.of(context).showSnackBar;
      }
    } catch (e) {
      print("here---->");
      final snackBar = SnackBar(content: Text(e.toString()));
      // ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  Future<void> signOut({required BuildContext context}) async {
    try {
      // await _googleSignIn.signOut();
      await _auth.signOut();
      await storage.delete(key: "token");
    } catch (e) {
      final snackBar = SnackBar(content: Text(e.toString()));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  Future<String> resetPassword({required String email}) async {
    await _auth.sendPasswordResetEmail(email: email).then((value) => "Success");
    return "Success";
  }

  void storeTokenAndData(UserCredential userCredential) async {
    print("storing token and data");
    await storage.write(
        key: "token", value: userCredential.credential!.token.toString());
    await storage.write(
        key: "usercredential", value: userCredential.toString());
  }

  Future<String?> getToken() async {
    return await storage.read(key: "token");
  }

  Future<void> verifyPhoneNumber(
      String phoneNumber, BuildContext context, Function setData) async {
    verificationCompleted(PhoneAuthCredential phoneAuthCredential) async {
      showSnackBar(context, "Verification Completed");
    }

    verificationFailed(FirebaseAuthException exception) {
      showSnackBar(context, exception.toString());
    }

    codeSent(String verificationID, [int? forceResnedingtoken]) {
      showSnackBar(context, "Verification Code sent on the phone number");
      setData(verificationID);
    }

    codeAutoRetrievalTimeout(String verificationID) {
      showSnackBar(context, "Time out");
    }

    try {
      await _auth.verifyPhoneNumber(
          timeout: const Duration(seconds: 60),
          phoneNumber: phoneNumber,
          verificationCompleted: verificationCompleted,
          verificationFailed: verificationFailed,
          codeSent: codeSent,
          codeAutoRetrievalTimeout: codeAutoRetrievalTimeout);
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  Future<void> signInwithPhoneNumber(
      String verificationId, String smsCode, BuildContext context) async {
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
          verificationId: verificationId, smsCode: smsCode);

      UserCredential userCredential =
          await _auth.signInWithCredential(credential);
      storeTokenAndData(userCredential);
      await Get.off(() => const SettingsForm());

      showSnackBar(context, "logged In");
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  void showSnackBar(BuildContext context, String text) {
    final snackBar = SnackBar(content: Text(text));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  Future<bool> isEmailAlreadyRegistered(String email) async {
    await FirebaseAuth.instance.fetchSignInMethodsForEmail(email);
    return true; // email already exists
  }
}
