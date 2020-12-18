import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'dart:io';

import 'package:myapp/Models/CoOrdinates.dart';

class UserInfos extends ChangeNotifier {
  double _longitude;
  double _latitiude;
  String _country;
  String _adminArea;
  String _subadminArea;
  String _thoroughfare;
  String _feature;
  String _locality;
  String _sublocality;
  DateTime _lastChanged;
  String _device;
  CoOrdinates _position;

  UserInfos get instance => this;
    UserInfos();
  double get longitude => _longitude;

  set longitude(double value) {
    _longitude = value;
    notifyListeners();
  }

  CoOrdinates get position => _position;

  set position(CoOrdinates value) {
    _position = value;
    notifyListeners();
  }

  double get latitiude => _latitiude;

  set latitiude(double value) {
    _latitiude = value;
    notifyListeners();
  }

  String get country => _country;

  set country(String value) {
    _country = value;
    notifyListeners();
  }

  String get adminArea => _adminArea;

  set adminArea(String value) {
    _adminArea = value;
    notifyListeners();
  }

  String get subadminArea => _subadminArea;

  set subadminArea(String value) {
    _subadminArea = value;
    notifyListeners();
  }

  String get thoroughfare => _thoroughfare;

  set thoroughfare(String value) {
    _thoroughfare = value;
    notifyListeners();
  }

  String get feature => _feature;

  set feature(String value) {
    _feature = value;
    notifyListeners();
  }

  String get locality => _locality;

  set locality(String value) {
    _locality = value;
    notifyListeners();
  }

  String get sublocality => _sublocality;

  set sublocality(String value) {
    _sublocality = value;
    notifyListeners();
  }

  String get device => _device;

  set device(String value) {
    _device = value;
    notifyListeners();
  }

  DateTime get lastChanged => _lastChanged;

  set lastChanged(DateTime value) {
    _lastChanged = value;
    notifyListeners();
  }

  UserInfos.fromMap(Map<String, dynamic> data) {
    _longitude = data['longitud'];

    _latitiude = data['latittude'];

    _country = data['country'];

    _adminArea = data['adminArea'];

    _subadminArea = data['subadminArea'];
    _thoroughfare = data['thoroughfare'];
    _feature = data['feature '];

    _locality = data['locality'];

    _sublocality = data['sublocality'];

    _device = data['device'];

    // _message = data['message'];
    // _userId = data['userId'];
    // _date = data['date'];
    notifyListeners();
  }
}
