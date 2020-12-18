import 'package:flutter/material.dart';

class Brim extends ChangeNotifier {
  String _message;
  String _userId;
  DateTime _date;

  String get message => _message;
  Brim();
  set message(String value) {
    _message = value;
    notifyListeners();
  }

  String get userId => _userId;

  set userId(String value) {
    _userId = value;
    notifyListeners();
  }

  DateTime get date => _date;

  set date(DateTime value) {
    _date = value;
    notifyListeners();
  }

  Brim.fromMap(Map<String, dynamic> data) {
    //sets all private values to values of the input map
    _message = data['message'];
    _userId = data['userId'];
    _date = data['date'];
    notifyListeners();
  }
}
