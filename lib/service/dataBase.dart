// ignore_for_file: depend_on_referenced_packages

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../model/usermodel.dart';

class DatabaseService {
  final String uid;
  DatabaseService({required this.uid});

  // collection reference
  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection('users');
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  Future<void> updateUserData(
      String name,
      String email,
      String phoneNumber,
      String password,
      String dob,
      String interest
      ) async {
    return await userCollection.doc(uid).set({
      'name': name,
      'email': email,
      'phoneNumber': phoneNumber,
      'password': password,
      'dob': dob,
      'interest': interest,
    });
  }

   Future<void> editUserData(
      String name,
      String password,
      ) async {
    return await userCollection.doc(uid).set({
      'name': name,
      'password': password
    });
  }

  UserData _userDataFromSnapshot(DocumentSnapshot snapshot) {
    return UserData(
        uid: uid,
        name: snapshot.get('name'),
        password: snapshot.get('gender'),
        dob: snapshot.get('dob'));
  }


  Stream<UserData> get userData {
    return userCollection.doc(uid).snapshots().map(_userDataFromSnapshot);
  }

  // getUserById () async {
  //   await userCollection.doc(firebaseAuth.currentUser!.uid).get().then((ds) {
  //     'gender': gender,
  //     'name': name,
  //     'dob': dob,
  //     'birthTime': birthTime,
  //     'birthPlace': birthPlace,
  //     'lat': lat,
  //     'lng': lng,
  //     'timeZone':timeZone,

  //     gender = ds.data['gender'];
  //       print(myEmail);
  //     }).catchError((e) {
  //       print(e);
  //     });
  // }

}
