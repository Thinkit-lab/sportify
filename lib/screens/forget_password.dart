// ignore_for_file: depend_on_referenced_packages, library_private_types_in_public_api, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sportify/screens/login.dart';
import 'package:sportify/service/auth.dart';

class ForgetPassword extends StatefulWidget {
  const ForgetPassword({super.key});

  @override
  _ForgetPasswordState createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  final _formKey = GlobalKey<FormState>();
  final authService = AuthService();

  @override
  void initState() {
    super.initState();
  }

  // form values
  final _email = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.grey[200]!.withOpacity(0.5),
          child: const Icon(
            Icons.arrow_back,
          ),
          onPressed: () async {
            Get.back();
          },
        ),
        backgroundColor: Colors.teal,
        body: Column(mainAxisSize: MainAxisSize.max, children: [
          const SizedBox(
            height: 50,
          ),
          Padding(
              padding: const EdgeInsets.only(right: 20.0, left: 20.0),
              child: Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      const Text(
                        'Forgot Password',
                        style: TextStyle(fontSize: 20.0),
                      ),
                      const SizedBox(height: 40.0),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[200]!.withOpacity(0.5),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(20.0)),
                        ),
                        child: TextFormField(
                          decoration: const InputDecoration(
                              contentPadding: EdgeInsets.only(left: 20.0),
                              hintText: 'Email'),
                          controller: _email,
                          validator: (val) =>
                              val!.isEmpty ? 'Please enter an email' : null,
                        ),
                      ),
                      const SizedBox(height: 20.0),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(30.0),
                          onTap: () async {
                            const CircularProgressIndicator();

                            if (_formKey.currentState!.validate()) {
                              await authService.resetPassword(
                                  email: _email.text.trim());
                            }

                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('A password reset link was sent to your email'),
                              ),
                            );
                            Get.off(()=> const Login());
                          },
                          child: Container(
                            height: 50.0,
                            width: double.infinity,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30.0),
                              gradient: LinearGradient(
                                begin: Alignment.centerLeft,
                                end: Alignment.bottomRight,
                                stops: const [0.1, 0.5, 0.9],
                                colors: [
                                  Colors.black87.withOpacity(0.8),
                                  Colors.black87.withOpacity(0.8),
                                  Colors.black87.withOpacity(0.8),
                                ],
                              ),
                            ),
                            child: const Text(
                              'Send',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16.0,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  )))
        ]));
  }
}
