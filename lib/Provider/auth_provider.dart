import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../Core/route_path.dart';
import '../Database/database_path.dart';
import '../Models/user_model.dart';

class AuthProvider with ChangeNotifier {
  FirebaseAuth get _firebaseAuth => FirebaseAuth.instance;
  FirebaseFirestore get _firebaseStore => FirebaseFirestore.instance;
  String? get currentUserId => FirebaseAuth.instance.currentUser?.uid ?? "";
  List<Users> userList = [];

  Future<bool> signUp(Users users, BuildContext context) async {
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(
          email: users.email!, password: users.password!);
      // userCredential.user?.sendEmailVerification();
      users.uid = currentUserId;
      await _firebaseStore
          .doc('${DatabasePath.userCollection}/$currentUserId')
          .set(users.toJson(), SetOptions(merge: true));
      return true;
    } catch (e) {
      print("SignUp Error is: $e");
      return false;
    }
  }

  Future<bool> logIn(String email, String password) async {
    try {
      // final UserCredential userCredential =
      await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      // if (!(userCredential.user!.emailVerified)) {
      return true;
    } catch (e) {
      print("LogIn Error is: $e");
      return false;
    }
  }

  void logOut() {
    _firebaseAuth.signOut();
  }

  getUsersData(BuildContext context) async {
    final _receivedData =
        await _firebaseStore.collection(DatabasePath.userCollection).get();
    // Users.fromJson(_receivedData as Map<String, dynamic>);
    // return Users.fromJson(_receivedData.docs as Map<String, dynamic>);
    // final allData = _receivedData.docs.map((doc) => doc.data()).toList();
    for (var element in _receivedData.docs) {
      final mapData = Users.fromJson(element.data());
      userList.add(mapData);
    }

    print(userList.length);
    // final allDa = allData as Users;
    // print(allDa);
    notifyListeners();
  }
}
