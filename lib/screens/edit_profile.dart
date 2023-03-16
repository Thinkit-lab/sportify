// ignore_for_file: depend_on_referenced_packages, library_private_types_in_public_api

import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../service/dataBase.dart';
import 'profile_show.dart';

class SettingsForm extends StatefulWidget {
  const SettingsForm({super.key});

  @override
  _SettingsFormState createState() => _SettingsFormState();
}

class _SettingsFormState extends State<SettingsForm> {
  final _formKey = GlobalKey<FormState>();
  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection('users');

  String? name;
  String? email;
  String? phoneNumber;
  String? password;
  String? dob;
  String? interest;

  @override
  void initState() {
    super.initState();
    _initData();
  }

  // form values
  final _currentName = TextEditingController();
  final _oldPassword = TextEditingController();
  final _currentPassword = TextEditingController();

  final firebaseAuth = FirebaseAuth.instance;
  TimeOfDay selectedTime = TimeOfDay.now();

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.grey[200]!.withOpacity(0.5),
          child: const Icon(Icons.arrow_back,),
          onPressed: () async {
            Get.back();
          },
        ),
      backgroundColor: Colors.teal,
      body: Column(

        mainAxisSize: MainAxisSize.max,
        children: [
          const SizedBox(
            height: 50,
          ),
          Padding(
            padding: const EdgeInsets.only(right: 20.0, left: 20.0),
            child: WillPopScope(
              onWillPop: () async {
                    bool exitStatus = onWillPop();
                    if (exitStatus) {
                      exit(0);
                    }
                    return true;
                  },
              child: FutureBuilder(
                  future: getUserById(),
                  // stream: DatabaseService(uid: firebaseAuth.currentUser!.uid).userData,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState != ConnectionState.done) {
                      return const Text("Loading data...Please wait");
                    } else {
                      print("Inside form");
                      // UserData? userData = snapshot.data;
                      return Form(
                        key: _formKey,
                        child: Column(
                          children: <Widget>[
                            const Text(
                              'Update your Profile',
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
                                    hintText: 'Enter new username'),
                                controller: _currentName,
                                validator: (val) =>
                                    val!.isEmpty ? 'Please enter a name' : null,
                              ),
                            ),
                            const SizedBox(height: 20.0),
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.grey[200]!.withOpacity(0.5),
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(20.0)),
                              ),
                              child: TextFormField(
                                decoration: const InputDecoration(
                                    contentPadding: EdgeInsets.only(left: 20.0),
                                    hintText: 'Enter old password'),
                                controller: _oldPassword,
                                validator: (val) => val!.isEmpty
                                    ? 'Please enter a password'
                                    : null,
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.grey[200]!.withOpacity(0.5),
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(20.0)),
                              ),
                              child: TextFormField(
                                decoration: const InputDecoration(
                                    contentPadding: EdgeInsets.only(left: 20.0),
                                    hintText: 'Enter new password'),
                                // initialValue: '',
                                controller: _currentPassword,
                                validator: (val) => val!.isEmpty
                                    ? 'Please enter a password'
                                    : null,
                              ),
                            ),
                            const SizedBox(height: 20.0),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20.0),
                              child: InkWell(
                                borderRadius: BorderRadius.circular(30.0),
                                onTap: () async {
                                  if (_formKey.currentState!.validate() &&
                                      _oldPassword.text.trim() == password) {
                                    firebaseAuth.currentUser!.updatePassword(
                                        _currentPassword.text.trim());
                                    await DatabaseService(
                                            uid: firebaseAuth.currentUser!.uid)
                                        .updateUserData(
                                            _currentName.text.trim(),
                                            email!,
                                            phoneNumber!,
                                            _currentPassword.text.trim(),
                                            dob!,
                                            interest!);
                                    Get.off(() => const ProfilePage());
                                  } else {
                                    throw Exception("Invalid old password");
                                  }
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
                                    'Update',
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
                        ),
                      );
                    }
                  }),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _initData() async {
    try {
      // _timezone = await FlutterNativeTimezone.getLocalTimezone();
    } catch (e) {
      print('Could not get the local timezone');
    }
  }

   onWillPop() {
    return false;
  }

  getUserById() async {
    await userCollection.doc(firebaseAuth.currentUser!.uid).get().then((ds) {
      name = (ds.data() as dynamic)['name'];
      email = (ds.data() as dynamic)['email'];
      phoneNumber = (ds.data() as dynamic)['phoneNumber'];
      password = (ds.data() as dynamic)['password'];
      dob = (ds.data() as dynamic)['dob'];
      interest = (ds.data() as dynamic)['interest'];
    }).catchError((e) {
      print(e);
    });
  }

}
