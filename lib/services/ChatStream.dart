import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myapp/Models/users.dart';
import 'package:myapp/services/database.dart';

class ChatStream {
  final String messageId;
  final _controller = StreamController<QuerySnapshot>();
  var _snapshots;
  int overallLength;
  int startingPoint;
  int endingPoint;
  ChatStream({this.messageId}) {
    _snapshots = FirebaseFirestore.instance
        .collection("chats")
        .doc(messageId)
        .collection("messages")
        .orderBy("time", descending: false)
        .limitToLast(10)
        .snapshots();

    _snapshots.listen((onData) {
      _controller.sink.add(onData);
    });
  }
  getChats(DocumentSnapshot lastDocument) async {
    FirebaseFirestore.instance
        .collection("chats")
        .doc(messageId)
        .collection("messages")
        .orderBy("time", descending: false)
        .endBeforeDocument(lastDocument)
        .limitToLast(100)
        .snapshots()
        .forEach((action) {
      _controller.sink.add(action);
    });
  }

  Stream get stream {
    return _controller.stream;
  }
}
