// ignore_for_file: depend_on_referenced_packages

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sportify/screens/profile_show.dart';

import '../screens/login.dart';



class HomeController extends GetxController {
  late GoogleSignIn googleSign;
  var isSignIn = false.obs;
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() async {
    googleSign = GoogleSignIn();
    ever(isSignIn, handleAuthStateChanged);
    isSignIn.value = await firebaseAuth.currentUser != null;
    firebaseAuth.authStateChanges().listen((event) {
      isSignIn.value = event != null;
    });

    super.onReady();
  }

  @override
  void onClose() {}

  void handleAuthStateChanged(isLoggedIn) async{
  //   if (isLoggedIn) {
  //           Get.off(() => ProfilePage());
  //    await Get.offAllNamed(Routes.WELCOME, arguments: firebaseAuth.currentUser);
  //   } else {
  //     Get.offAllNamed(Routes.LOGIN);
  //     Get.off(() => Login());
  //   }
  }
}
