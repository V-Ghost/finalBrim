import 'package:flutter/material.dart';

class Setting extends ChangeNotifier{
   bool _firstRun;
   bool _brimNotification;
   



   
 Setting get instance => this;


    bool get firstRun => _firstRun;

      
  set firstRun(bool value) {
    _firstRun = value;
    notifyListeners();
  }

   bool get brimNotification => _brimNotification;

  set brimNotification(bool value) {
    _brimNotification = value;
    notifyListeners();
  }
}