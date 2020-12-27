import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myapp/Models/users.dart';
import 'package:myapp/services/database.dart';

class TestStream {
  final String uid;

  TestStream({this.uid}) {
    // Users u = new Users();
    Users temp = new Users();

    FirebaseFirestore.instance
        .collection("chats")
        .where('type', isEqualTo: "brim")
        .snapshots()
        .listen((onData) {
      onData.docs.forEach((data) {
        String otherUser;

        if (data["participant1"] == uid) {
          otherUser = data["participant1"].toString();
        }
        if (data["participant2"] == uid) {
          otherUser = data["participant2"].toString();
        }

        DatabaseService().getUserInfo(otherUser).then((u){
          print("please");
        _controller.sink.add(u);
        });
      
      });
    });
  }
  Stream get stream {
    return _controller.stream;
  }

  var count = 1;
  final _controller = StreamController<Users>();
}
