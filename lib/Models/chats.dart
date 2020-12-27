import 'package:flutter/material.dart';

class ChatsModel  extends ChangeNotifier {
  String _participant1;
   String _participant2;
   String _type;

ChatsModel();

String get participant1 => _participant1;
 
  set participant1(String value) {
    _participant1 = value;
    notifyListeners();
  }

  String get participant2 => _participant2;
 
  set participant2(String value) {
    _participant2 = value;
    notifyListeners();
  }

  String get type => _type;
 
  set type(String value) {
    _type = value;
    notifyListeners();
  }

}