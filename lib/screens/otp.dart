// ignore_for_file: depend_on_referenced_packages, library_private_types_in_public_api

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/otp_field_style.dart';
import 'package:otp_text_field/style.dart';
import 'package:sportify/screens/profile_show.dart';

import '../service/auth.dart';
import 'login.dart';
import 'package:get/get.dart';

class OTPScreen extends StatefulWidget {
  const OTPScreen({Key? key}) : super(key: key);

  @override
  _OTPScreenState createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  int start = 30;
  bool wait = true;
  String buttonName = "Resend";
  TextEditingController phoneController = TextEditingController();
  AuthService authService = AuthService();
  String verificationIdFinal = "";
  String smsCode = "";
  late final Function(String) onOtpEntered;
  Login login = const Login();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
        title: const Text(
          "Verify OTP",
          style: TextStyle(color: Colors.black, fontSize: 22,),
        ),
        centerTitle: true,
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: 1,
                width: MediaQuery.of(context).size.width,
                color: Colors.black,
              ),
              const SizedBox(
                height: 20,
              ),
              
              const SizedBox(
                height: 40,
              ),
              // textField(),
              const Text(
                'Verification',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontSize: 18
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              Container(
                width: MediaQuery.of(context).size.width - 30,
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 1,
                        color: Colors.teal,
                        margin: const EdgeInsets.symmetric(horizontal: 12),
                      ),
                    ),
                    const Text(
                      "Enter your verification code",
                      style: TextStyle(fontSize: 18, color: Colors.black, fontWeight: FontWeight.bold),
                    ),
                    Expanded(
                      child: Container(
                        height: 1,
                        color: Colors.teal,
                        margin: const EdgeInsets.symmetric(horizontal: 12),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              otpField(),
              const SizedBox(
                height: 40,
              ),
              Center(
                child: RichText(
                    text: TextSpan(
                  children: [
                    const TextSpan(
                      text: "Send OTP again in ",
                      style: TextStyle(fontSize: 16, color: Colors.black),
                    ),
                    TextSpan(
                      text: "00:$start",
                      style: const TextStyle(fontSize: 16, color: Colors.teal,fontWeight: FontWeight.bold),
                    ),
                    const TextSpan(
                      text: " sec ",
                      style: TextStyle(fontSize: 16, color: Colors.teal),
                    ),
                  ],
                )),
              ),
              const SizedBox(
                height: 20,
              ),
              button(),
              const SizedBox(
                height: 40,
              ),
              InkWell(
                onTap: () async {
                  await authService.signInwithPhoneNumber(
                      verificationIdFinal, smsCode, context);
                    
                  Get.off(()=> const ProfilePage());
                },
                child: Container(
                  height: 50,
                  width: MediaQuery.of(context).size.width - 60,
                  decoration: BoxDecoration(
                      color: Colors.teal,
                      borderRadius: BorderRadius.circular(20)),
                  child: const Center(
                    child: Text(
                      "Done",
                      style: TextStyle(
                          fontSize: 17,
                          color: Colors.white,
                          fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void startTimer() {
    const onsec = Duration(seconds: 1);
    Timer _timer = Timer.periodic(onsec, (timer) {
      if (start == 0) {
        setState(() {
          timer.cancel();
          wait = true;
        });
      } else {
        setState(() {
          start--;
        });
      }
    });
  }

  Widget otpField() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: OTPTextField(
          length: 6,
          width: MediaQuery.of(context).size.width,
          fieldWidth: 40,
          otpFieldStyle: OtpFieldStyle(
      backgroundColor: Colors.grey.shade200,
      borderColor: Colors.white,
          ),
          style: const TextStyle(fontSize: 17, color: Colors.white),
          textFieldAlignment: MainAxisAlignment.spaceAround,
          fieldStyle: FieldStyle.underline,
          keyboardType: TextInputType.number,
        
          onChanged: (pin) {
            if(pin.length == 6) {
              smsCode = pin;
            }
          },
          onCompleted: (pin) {
      
      print("Completed: " + pin);
      setState(() {
        smsCode = pin;
      });
          },
        ),
    );
  }

  Widget button(){
    return InkWell(
            onTap: wait
                ? null
                : () async {
                    setState(() {
                      start = 30;
                      wait = false;
                      buttonName = "Request OTP";
                    });
                  },
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
              child: Text(
                buttonName,
                style: TextStyle(
                  color: wait ? Colors.black54 : Colors.teal,
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          );
  }

  void setData(String verificationId) {
    setState(() {
      verificationIdFinal = verificationId;
    });
    startTimer();
  }
}