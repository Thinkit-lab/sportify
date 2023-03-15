// ignore_for_file: depend_on_referenced_packages, prefer_const_constructors, use_build_context_synchronously, library_private_types_in_public_api

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:sportify/screens/forget_password.dart';
import 'package:sportify/screens/profile_show.dart';
import 'package:sportify/screens/register.dart';

import '../controller/login_controller.dart';
import '../service/auth.dart';
import 'phoneAuth.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  late DateTime currentBackPressTime;
  String verificationIdFinal = "";
  String phoneNumber = '';
  late String phoneIsoCode;
  final TextEditingController controller = TextEditingController();
  String initialCountry = 'US';
  PhoneNumber number = PhoneNumber(isoCode: 'US');
  void onPhoneNumberChange(
      String number, String internationalizedPhoneNumber, String isoCode) {
    setState(() {
      phoneNumber = number;
      phoneIsoCode = isoCode;
    });
  }

  AuthService authService = AuthService();
  LoginController loginController = LoginController();

  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
        backgroundColor: Colors.black87,
        body: Container(
          decoration: const BoxDecoration(
            // color: Colors.black87,
            image: DecorationImage(
                image: AssetImage('assets/sportify.jpeg'), fit: BoxFit.cover),
          ),
          child: Stack(
            children: <Widget>[
              Positioned(
                top: 0.0,
                left: 0.0,
                child: Container(
                  width: width,
                  height: height,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      stops: const [0.1, 0.3, 0.5, 0.7, 0.9],
                      colors: [
                        Colors.black.withOpacity(0.4),
                        Colors.black.withOpacity(0.55),
                        Colors.black.withOpacity(0.7),
                        Colors.black.withOpacity(0.8),
                        Colors.black.withOpacity(1.0),
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                child: WillPopScope(
                  child: Scaffold(
                    backgroundColor: Colors.teal.shade400,
                    body: ListView(
                      physics: const BouncingScrollPhysics(),
                      children: <Widget>[
                        const SizedBox(height: 30.0),
                        const Image(
                          image: AssetImage('assets/logo.png'),
                          height: 80,
                          width: 80,
                          color: Colors.white70,
                        ),
                        Container(
                          alignment: AlignmentDirectional.center,
                          width: 100,
                          height: 50,
                          child: const Text(
                            'Sportify',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                              color: Colors.teal,
                              borderRadius: BorderRadius.circular(15)),
                          height: 2,
                          margin: const EdgeInsets.symmetric(horizontal: 12),
                        ),
                        SizedBox(height: 40),
                        Text(
                          'Login',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87),
                        ),
                        SizedBox(height: 20),
                        Form(
                            key: _formKey,
                            child: Column(children: [
                              Padding(
                                padding: EdgeInsets.only(
                                    right: 20.0, left: 20.0, top: 10),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.grey[200]!.withOpacity(0.5),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20.0)),
                                  ),
                                  child: TextFormField(
                                    validator: (val) =>
                                        val!.isEmpty ? 'Enter Email' : null,
                                    cursorColor: Colors.white,
                                    controller: _email,
                                    style: TextStyle(
                                      color: Colors.black87,
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    decoration: InputDecoration(
                                      contentPadding:
                                          EdgeInsets.only(left: 20.0),
                                      hintText: 'Email',
                                      hintStyle: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.w500,
                                      ),
                                      border: InputBorder.none,
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                    right: 20.0, left: 20.0, top: 20),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.grey[200]!.withOpacity(0.5),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20.0)),
                                  ),
                                  child: TextFormField(
                                    obscureText: true,
                                    validator: (val) =>
                                        val!.isEmpty ? 'Enter Password' : null,
                                    cursorColor: Colors.white,
                                    controller: _password,
                                    style: TextStyle(
                                      color: Colors.black87,
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    decoration: InputDecoration(
                                      contentPadding:
                                          EdgeInsets.only(left: 20.0),
                                      hintText: 'Password',
                                      hintStyle: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.w500,
                                      ),
                                      border: InputBorder.none,
                                    ),
                                  ),
                                ),
                              ),
                               SizedBox(
                                height: 20,
                              ),
                              GestureDetector(
                                onTap: () => Get.to(()=> ForgetPassword()),
                                child: Text("Forget password?", style: TextStyle(color: Colors.red),),
                              ),
                              SizedBox(
                                height: 40,
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20.0),
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(30.0),
                                  onTap: () async {
                                    String signIn = await authService.signIn(
                                        email: _email.text.trim(),
                                        password: _password.text.trim());

                                    if (signIn == "Success") {
                                      Get.offAll(()=>ProfilePage());
                                    }
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(15.0),
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(30.0),
                                      color: Colors.black87,
                                    ),
                                    child: Text(
                                      'Login',
                                      style: TextStyle(
                                        fontSize: 16.0,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Center(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text("Dont't have an account? "),
                                    GestureDetector(
                                      onTap: () => Get.to(Register()),
                                      child: Text(
                                        'Register',
                                        style: TextStyle(color: Colors.white70),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ])),

                        SizedBox(height: 20),
                        Text(
                          'OR',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87),
                        ),
                        SizedBox(height: 5),
                        Text(
                          'Continue with',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black87),
                        ),

                        const SizedBox(height: 20.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: () => Get.to(PhoneAuthPage()),
                              child: Icon(
                                Icons.phone,
                                size: 30,
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: GestureDetector(
                                onTap: () => authService.googleSignIn(context),
                                child: Icon(
                                  Icons.mail,
                                  size: 30,
                                ),
                              ),
                            ),
                            GestureDetector(
                              // onTap: () => ;
                              child: Icon(
                                Icons.facebook,
                                size: 30,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  onWillPop: () async {
                    bool exitStatus = onWillPop();
                    if (exitStatus) {
                      exit(0);
                    }
                    return false;
                  },
                ),
              ),
            ],
          ),
        ));
  }

  onWillPop() {
    return true;
  }

  void setData(String verificationId) {
  }
}
