// ignore_for_file: depend_on_referenced_packages, library_private_types_in_public_api

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sportify/screens/login.dart';
import 'package:sportify/widget/bottom_nav_bar.dart';

import '../service/auth.dart';
import '../service/dataBase.dart';
import "package:get/get.dart";


class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  AuthService authService = AuthService();
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  DatabaseService databaseService = DatabaseService(uid: '');
 final CollectionReference userCollection = FirebaseFirestore.instance.collection('users');

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  String ? name;
  String ? email;
  String ? interest;
  String ? dob;
  String ? phoneNumber;


  @override
  Widget build(BuildContext context){
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.grey[200]!.withOpacity(0.5),
          child: Icon(Platform.isIOS?Icons.logout : Icons.logout,),
          onPressed: () async {
            await authService.signOut(context: context);
            Get.offAll(()=> const Login());
          },
        ),
        backgroundColor: Colors.teal,
      body: Center(
        child: FutureBuilder(
          future: getUserById(),
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return const Text("Loading data...Please wait");
            } else {
              return
            ListView(
            children: <Widget>[
              Stack(
                children: <Widget>[
                  Column(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Card(
                        color: Colors.teal,
                        margin: const EdgeInsets.all(14),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Container(
                              // height: 90,
                              width: double.infinity,
                              margin: const EdgeInsets.only(top: 40),
                              child: const CircleAvatar(
                                radius: 50,
                                backgroundColor: Colors.white,
                                child: Image(image: AssetImage('assets/logo.png')),
                              )
                            ),
                            const Padding(
                        padding: EdgeInsets.all(4),
                      ),
                      Text(
                        "$name",
                        style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                            fontSize: 20),
                        textAlign: TextAlign.center,
                      ),
                      const Padding(
                        padding: EdgeInsets.all(4),
                      ),
                      Text(
                        "$email",
                        style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w400,
                            fontSize: 16),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 30,),
                          ],
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 10),
                        padding: const EdgeInsets.all(10),
                        child: Card(
                          color: Colors.black87,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                              Column(
                                children: <Widget>[
                                  Container(
                                      padding:
                                          const EdgeInsets.only(top: 15, bottom: 5),
                                      child: const Text("Date of Birth",
                                          style: TextStyle(
                                              color: Colors.white))),
                                  Container(
                                      padding: const EdgeInsets.only(bottom: 15),
                                      child: Text("$dob",
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 16))),
                                ],
                              ),
                              Column(
                                children: <Widget>[
                                  Container(
                                      padding:
                                          const EdgeInsets.only(top: 15, bottom: 5),
                                      child: const Text("Phone Number",
                                          style: TextStyle(
                                              color: Colors.white))),
                                  Container(
                                      padding: const EdgeInsets.only(bottom: 15),
                                      child: Text("$phoneNumber",
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 16))),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
      padding: const EdgeInsets.all(10),
      child: Column(
        children: <Widget>[
          Card(
            color: Colors.black87,
            child: Container(
              alignment: Alignment.topLeft,
              padding: const EdgeInsets.all(15),
              child: Column(
                children: <Widget>[
                  Container(
                    alignment: Alignment.topLeft,
                    child: const Text(
                      "Other Information",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ),
                  const Divider(
                    color: Colors.black38,
                  ),
                  Container(
                      child: Column(
                    children: <Widget>[
                      ListTile(
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                        leading: const Icon(Icons.interests),
                        title: const Text("Interest"),
                        subtitle: Text("$interest"),
                      ),
                    ],
                  ))
                ],
              ),
            ),
          )
        ],
      ),
    )
                    ],
                  )
                ],
              ),
            ],
          );
            }
          },
        ),
      ),
      bottomNavigationBar: const NavigationBarWidget(),
      );
    // );
  }
  


  getUserById () async {
    await userCollection.doc(firebaseAuth.currentUser!.uid).get().then((ds) {
      email = (ds.data() as dynamic)['email'];
      name = (ds.data() as dynamic)['name'];
      dob = (ds.data() as dynamic)['dob'];
      interest = (ds.data() as dynamic)['interest'];
      phoneNumber = (ds.data() as dynamic)['phoneNumber'];
      }).catchError((e) {
        print(e);
      });
  }
}
