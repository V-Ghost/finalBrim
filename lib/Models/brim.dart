import 'package:flutter/material.dart';

class Brim extends ChangeNotifier {
  String _message;
  String _broadcast;
  String _userId1;
   String _userId2;
   String _sender;
  DateTime _date;


  Brim();

  String get broadcast => _broadcast;
 
  set broadcast(String value) {
    _broadcast = value;
    notifyListeners();
  }

  String get message => _message;
 
  set message(String value) {
    _message = value;
    notifyListeners();
  }

  String get userId1 => _userId1;

  set userId1(String value) {
    _userId1 = value;
    notifyListeners();
  }

  String get sender => _sender;

  set sender(String value) {
    _sender = value;
    notifyListeners();
  }

  String get userId2 => _userId2;

  set userId2(String value) {
    _userId2 = value;
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
    _userId1 = data['participant1'];
    _userId2 = data['participant2'];
    _date = data['date'];
    notifyListeners();
  }
}
