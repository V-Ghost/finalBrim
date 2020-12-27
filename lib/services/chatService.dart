import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:myapp/Models/message.dart';
import 'package:uuid/uuid.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class ChatService {
  final String uid;
  ChatService({this.uid});

  Future<dynamic> sendChatsText(Message m, String messageId) async {
    var uuid = Uuid();
    FirebaseFirestore.instance
        .collection("chats")
        .doc(messageId)
        .collection("messages")
        .doc(uuid.v1())
        .set({
      'message': m.message,
      'from': m.from,
      'type': "text",
      'read': false,
      'time': m.date,
    }).then((onValue) {
      return true;
    }).catchError((onError) {
      print(onError.toString());
      return onError.toString();
    });
  }

  Future<dynamic> permit(String messageId, bool isParticipant1) async {
    String permit;
    if (isParticipant1 == true) {
      permit = "permit1";
    } else {
      permit = "permit2";
    }
    try {
      await FirebaseFirestore.instance
          .collection("chats")
          .doc(messageId)
          .update({
        permit: true,
      });
      // checkPermit(messageId);
      print("done");
      return true;
    } catch (error) {
      print(error.toString());
      return error.toString();
    }
  }

  Future<dynamic> checkPermit(String messageId) async {
    var query = await FirebaseFirestore.instance
        .collection("chats")
        .doc(messageId)
        .get();
   // print(query.data()['permit1']);

   
    //  await query.forEach((value){
    //     print("chats");
    //    print(value.data());
    //    print(value.data()["permit1"]);
    //     print(value.data()["permit2"]);
    if (query.data()['permit1'] == true && query.data()['permit2'] == true) {
     return true;
    } else {
     return false;
    }
   
  }

  Future<dynamic> sendChatsFile(Message m, String messageId) async {
    var uuid = Uuid();
    String _uploadedFileURL;
    firebase_storage.Reference storageReference =
        FirebaseStorage.instance.ref().child('chat/${uuid.v1()}');

    storageReference.putFile(m.image).whenComplete(() async {
      _uploadedFileURL = await storageReference.getDownloadURL();
    }).catchError((onError) {
      print(onError.toString());
      return onError.toString();
    });

    FirebaseFirestore.instance
        .collection("chats")
        .doc(messageId)
        .collection("messages")
        .doc(uuid.v1())
        .set({
      'message': _uploadedFileURL,
      'image': m.message,
      'from': m.from,
      'type': "image",
      'read': false,
      'time': m.date,
    }).then((onValue) {
      return true;
    }).catchError((onError) {
      print(onError.toString());
      return onError.toString();
    });
  }

  Stream chatsStream() {
    return FirebaseFirestore.instance
        .collection("chats")
        .where('type', isEqualTo: "brim")
        .snapshots();
  }

  Stream getYourChats(String messageId) {
    return FirebaseFirestore.instance
        .collection("chats")
        .doc(messageId)
        .collection("messages")
        .orderBy("time", descending: false)
        .snapshots();
  }

  Future<int> getChatlength(String messageId) async {
     var query= await  FirebaseFirestore.instance
        .collection("chats")
        .doc(messageId)
        .collection("messages").get();
        print(query.size);
        return query.size;
  }
}
