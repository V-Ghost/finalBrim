import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'dart:io';

import 'package:myapp/Models/CoOrdinates.dart';

class Users extends ChangeNotifier {
  String _userName;
  String _verificationId;
  String _smsCode;
  File _image;
  String _bio;
  String _picture;
  String _phoneNumber;
  DateTime _dob;
  String _gender;
  String _uid;
  User _user;
  Users _currentUser;
   CoOrdinates _position;
  Users get instance => this;
   
  String get userName => _userName;


Users();

 CoOrdinates get position => _position;

  set position(CoOrdinates value) {
    _position = value;
    notifyListeners();
  }
  set userName(String value) {
    _userName = value;
    notifyListeners();
  }

  User get user => _user;

  set user(User value) {
    _user = value;
    notifyListeners();
  }

  
  Users get currentUser => _currentUser;

  set currentUser(Users value) {
    _currentUser = value;
    notifyListeners();
  }

   String get gender => _gender;

  set gender(String value) {
    _gender = value;
    notifyListeners();
  }

  File get image => _image;

  set image(File value) {
    _image = value;
    notifyListeners();
  }

  String get bio => _bio;

  set bio(String value) {
    _bio = value;
    notifyListeners();
  }

   String get uid => _uid;

  set uid(String value) {
    _uid = value;
    notifyListeners();
  }

  String get picture => _picture;

  set picture(String value) {
    _picture = value;
    notifyListeners();
  }

  DateTime get dob => _dob;

  set dob(DateTime value) {
    _dob = value;
    notifyListeners();
  }

  String get verificationId => _verificationId;

  set verificationId(String value) {
    _verificationId = value;
    notifyListeners();
  }

  set smsCode(String value) {
    _smsCode = value;
    notifyListeners();
  }

  String get smsCode => _smsCode;

   set phoneNumber(String value) {
    _phoneNumber = value;
    notifyListeners();
  }

  String get phoneNumber => _phoneNumber;


  Users.fromMap(Map<String,dynamic> data){
  //sets all private values to values of the input map
_userName = data['username'];
_picture = data['picture'];
_gender = data['gender'];
_dob = data['dob'].toDate();
_bio = data['bio'];
_phoneNumber = data['phoneNumber'];
notifyListeners();
}
}
