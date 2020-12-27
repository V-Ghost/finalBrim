import 'dart:io';

import 'package:flutter/material.dart';

class Message extends ChangeNotifier{

  String _message;
  String _from;
  bool _read;
  File _image;
  DateTime _date;
    
 File get image => _image;

  set image(File value) {
    _image = value;
    notifyListeners();
  }

bool get read => _read;
 
  set read(bool value) {
    _read = value;
    notifyListeners();
  }

  String get message => _message;
 
  set message(String value) {
    _message = value;
    notifyListeners();
  }

String get from => _from;
 
  set from(String value) {
    _from = value;
    notifyListeners();
  }


  DateTime get date => _date;
 
  set date(DateTime value) {
    _date = value;
    notifyListeners();
  }


  



}