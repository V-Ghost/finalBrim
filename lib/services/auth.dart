import 'dart:io';

import 'package:myapp/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:myapp/Models/users.dart';

class AuthService {
  final String uid;
 AuthService({this.uid});
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // create user obj based on firebase user
  // User _userFromFirebaseUser(FirebaseUser user) {
  //   return user != null ? User(uid: user.uid) : null;
  // }

  // auth change user stream
  // Stream<User> get user {
  //   return _auth.onAuthStateChanged
  //     //.map((FirebaseUser user) => _userFromFirebaseUser(user));
  //     .map(_userFromFirebaseUser);
  // }

  // sign in anon
  // Future signInAnon() async {
  //   try {
  //     AuthResult result = await _auth.signInAnonymously();
  //     FirebaseUser user = result.user;
  //     return _userFromFirebaseUser(user);
  //   } catch (e) {
  //     print(e.toString());
  //     return null;
  //   }
  // }

  // sign in with email and password
  // Future registerWithEmailAndPassword(Users u, File _image) async {
  //   try {
  //     // FirebaseUser user = result.user;
  //     final User user = (await _auth.createUserWithEmailAndPassword(
  //             email: u.email, password: u.password))
  //         .user;
  //     String fileUrl = await DatabaseService().uploadFile(_image);
  //     print("fileurl");
  //     print(fileUrl);
  //     u.picture = fileUrl;
  //     await DatabaseService(uid: user.uid).updateUserData(u);

  //     // print(user);
  //     return user ?? "signup not successful";
  //   } catch (error) {
  //     print(error.toString());
  //     return error.toString();
  //   }
  // }

  Future loginInWithPhoneNumber(Users u) async {
    try {
      final AuthCredential credential = PhoneAuthProvider.credential(
        verificationId: u.verificationId,
        smsCode: u.smsCode,
      );
      final User user = (await _auth.signInWithCredential(credential)).user;
      return user ?? "Login not successful";
    } catch (error) {
      print(error.toString());
      return error.toString();
    }
  }

  Future signInWithPhoneNumber(Users u) async {
    try {
       print("we move");
      final AuthCredential credential = PhoneAuthProvider.credential(
        verificationId: u.verificationId,
        smsCode: u.smsCode,
      );
      final User user = (await _auth.signInWithCredential(credential)).user;
      print("we start");
      print("${user.uid}");
      print(u.userName);
      print(u.dob);
      dynamic fileUrl = await DatabaseService().uploadFile(u.image);
   
      // u.image = fileUrl;

      // await DatabaseService(uid: user.uid).updateUserData(u);
      // return user ?? "signup not successful";

      print("fileurl");
      print(fileUrl);
       print("${user.uid}");
      u.picture = fileUrl;
      await DatabaseService(uid: user.uid).updateUserData(u);
    } catch (error) {
      print(error.toString());
      return error.toString();
    }
  }

// Future<bool> getUser() async {
//    DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
//         .collection('users')
//         .doc(uid)
//         .get();
//   if (documentSnapshot.exists) {
//     return true;
//   }else{
//     return false;
//   }
// }
  // sign out
  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (error) {
      print(error.toString());
      return null;
    }
  }
}
