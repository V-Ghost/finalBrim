import 'dart:io';

import 'package:firebase_database/firebase_database.dart';
import 'package:myapp/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:myapp/Models/users.dart';

class AuthService {
  final String uid;
 AuthService({this.uid});
  final FirebaseAuth _auth = FirebaseAuth.instance;

 

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
  Future<void> signOut() async {
    try {
     await FirebaseDatabase.instance
        .reference()
        .child("userInfo")
        .child("userStatus").child(uid).remove();
      return await _auth.signOut();
    } catch (error) {
      print(error.toString());
      return null;
    }
  }
}
