import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myapp/Models/brim.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:myapp/Models/broadcastMessage.dart';
import 'package:myapp/Models/users.dart';
import 'package:myapp/services/database.dart';
import 'package:uuid/uuid.dart';
import 'package:intl/intl.dart';

class BrimService {
  final String uid;
  BrimService({this.uid});

  Future<dynamic> sendBrim(Brim b) async {
    try {
      var check = await DatabaseService(uid: uid)
          .doesBrimMessageExistAlready(b.userId2);
      if (check != true) {
        var uuid = Uuid();
        var array = [b.userId1,b.userId2];
        var unique = b.userId1 + b.userId2;
        var u1 = Uuid();
        print(b.userId2);
        CollectionReference userCollection =
            FirebaseFirestore.instance.collection('chats');
        await userCollection.doc(unique).set({
          'participant1': b.userId1,
          'participant2': b.userId2,
          'type': 'brim',
          'permit1': true,
          'permit2': false,
          'latest': b.date,
          'newMessage1': true,
          'members': array,
        });
        await userCollection
            .doc(unique)
            .collection('messages')
            .doc(uuid.v1())
            .set({
          'message': b.message,
          'from': b.sender,
          'type': "text",
          'read': false,
          'time': b.date,
        }).then((onValue) {
          return null;
        });
      } else {
        return "You have already sent a brim to this user";
      }
    } catch (error) {
      print(error.toString());
      return false;
    }
  }

  Future<dynamic> sendComment(Brim b) async {
    try {
      var unique = b.userId1 + b.userId2;
      var unique1 = b.userId2 + b.userId1;
       var array = [b.userId1,b.userId2];
      var query = await FirebaseFirestore.instance
          .collection("chats")
          .where('participant1', isEqualTo: b.userId1)
          .where('participant2', isEqualTo: b.userId2)
          .get();

      var query1 = await FirebaseFirestore.instance
          .collection("chats")
          .where('participant2', isEqualTo: b.userId1)
          .where('participant1', isEqualTo: b.userId2)
          .get();
      // var query1 = await FirebaseFirestore.instance
      //     .collection("chats")
      //     .where('members', arrayContainsAny: [b.userId2]).get();
      // bool greater = false;
      // int q = await query.docs.length.toInt();
      // print("length for q : $q");
      // print(b.userId2);
      // int q1 = await query1.docs.length.toInt();
      // print("length for q1 : $q1");
      // if (q > q1) {
      //   print("query is greater");
      //   greater = true;//user1
      // }
      //     .doesBrimMessageExistAlready(b.userId2);
      //print("about to");
      if (query.docs.isNotEmpty) {
        query.docs.forEach((data) async {
          print("unique");
          print(unique);
          print(data.data());

          if (data.data().containsKey("latestMessage"))  {
           var uuid = Uuid();

        print("triggerd false");

       // var u1 = Uuid();
        print(b.userId2);
        CollectionReference userCollection =
            FirebaseFirestore.instance.collection('chats');
        await userCollection.doc(unique).set({
          'participant1': b.userId1,
          'participant2': b.userId2,
            'members': array,
          'type': 'friends',
          'permit1': true,
          'permit2': false,
          'latestMessage': b.date,
          'newMessage1': true,
        });
        await userCollection
            .doc(unique)
            .collection('messages')
            .doc(uuid.v1())
            .set({
          'message': b.message,
          'from': b.sender,
          'type': "comment",
          'read': false,
          'time': b.date,
          'broadcast': b.broadcast,
        });
          } else if (data.data().containsKey("latest")) {
            var uuid = Uuid();

        print("triggerd false");

       // var u1 = Uuid();
        print(b.userId2);
        CollectionReference userCollection =
            FirebaseFirestore.instance.collection('chats');
        await userCollection.doc(unique).set({
          'participant1': b.userId1,
          'participant2': b.userId2,
            'members': array,
          'type': 'brim',
          'permit1': true,
          'permit2': false,
          'latest': b.date,
          'newMessage1': true,
        });
        await userCollection
            .doc(unique)
            .collection('messages')
            .doc(uuid.v1())
            .set({
          'message': b.message,
          'from': b.sender,
          'type': "comment",
          'read': false,
          'time': b.date,
          'broadcast': b.broadcast,
        });
          }
        });
      }else if(query1.docs.isNotEmpty ){
      query1.docs.forEach((data) async {
          print("unique1");
          print(unique1);
          print(data.data());

            if (data.data().containsKey("latestMessage"))  {
           var uuid = Uuid();

        print("triggerd false");

       // var u1 = Uuid();
        print(b.userId2);
        CollectionReference userCollection =
            FirebaseFirestore.instance.collection('chats');
        await userCollection.doc(unique1).set({
          'participant1': b.userId1,
          'participant2': b.userId2,
           'members': array,
          'type': 'friends',
          'permit1': true,
          'permit2': false,
          'latestMessage': b.date,
          'newMessage1': true,
        });
        await userCollection
            .doc(unique1)
            .collection('messages')
            .doc(uuid.v1())
            .set({
          'message': b.message,
          'from': b.sender,
          'type': "comment",
          'read': false,
          'time': b.date,
          'broadcast': b.broadcast,
        });
          } else if (data.data().containsKey("latest")) {
            var uuid = Uuid();

        print("triggerd false");

       // var u1 = Uuid();
        print(b.userId2);
        CollectionReference userCollection =
            FirebaseFirestore.instance.collection('chats');
        await userCollection.doc(unique1).set({
          'participant1': b.userId1,
          'participant2': b.userId2,
           'members': array,
          'type': 'brim',
          'permit1': true,
          'permit2': false,
          'latest': b.date,
          'newMessage1': true,
        });
        await userCollection
            .doc(unique1)
            .collection('messages')
            .doc(uuid.v1())
            .set({
          'message': b.message,
          'from': b.sender,
          'type': "comment",
          'read': false,
          'time': b.date,
          'broadcast': b.broadcast,
        });
          }
        });
      } else {
         var uuid = Uuid();

        print("triggerd false");

       // var u1 = Uuid();
        print(b.userId2);
        CollectionReference userCollection =
            FirebaseFirestore.instance.collection('chats');
        await userCollection.doc(unique).set({
          'participant1': b.userId1,
          'participant2': b.userId2,
            'members': array,
          'type': 'brim',
          'permit1': true,
          'permit2': false,
          'latest': b.date,
          'newMessage1': true,
        });
        await userCollection
            .doc(unique)
            .collection('messages')
            .doc(uuid.v1())
            .set({
          'message': b.message,
          'from': b.sender,
          'type': "comment",
          'read': false,
          'time': b.date,
          'broadcast': b.broadcast,
        });
          
        
      }
      //else {
      //   query1.docs.forEach((data) {
      //     print("entered1");
      //     print(data.data());
      //     if (data.data().isNotEmpty) {
      //     } else {

      //     }
      //   });
      // }

      // if (check..) {
      //   var uuid = Uuid();

      //   print("triggerd false");

      //  // var u1 = Uuid();
      //   print(b.userId2);
      //   CollectionReference userCollection =
      //       FirebaseFirestore.instance.collection('chats');
      //   await userCollection.doc(unique).set({
      //     'participant1': b.userId1,
      //     'participant2': b.userId2,

      //     'type': 'brim',
      //     'permit1': true,
      //     'permit2': false,
      //     'latest': b.date,
      //     'newMessage1': true,
      //   });
      //   await userCollection
      //       .doc(unique)
      //       .collection('messages')
      //       .doc(uuid.v1())
      //       .set({
      //     'message': b.message,
      //     'from': b.sender,
      //     'type': "comment",
      //     'read': false,
      //     'time': b.date,
      //     'broadcast': b.broadcast,
      //   });
      // } else {
      //    print("triggered true");
      //    var uuid = Uuid();

      //   var u1 = Uuid();

      //   //print(b.userId2);
      //   CollectionReference userCollection =
      //       FirebaseFirestore.instance.collection('chats');
      //   await userCollection.doc(check.data).set({
      //     'participant1': b.userId1,
      //     'participant2': b.userId2,

      //     'type': 'friends',
      //     'permit1': true,
      //     'permit2': false,
      //     'latestMessage': b.date,
      //     'newMessage1': true,
      //   });
      //   await userCollection
      //       .doc(check.data)
      //       .collection('messages')
      //       .doc(uuid.v1())
      //       .set({
      //     'message': b.message,
      //     'from': b.sender,
      //     'type': "comment",
      //     'read': false,
      //     'time': b.date,
      //     'broadcast': b.broadcast,
      //   });
      // }
    } catch (error) {
      print("error occured");
      print(error.toString());
      return error.toString();
    }
  }

  // Future<dynamic> startChat(Brim b) async {
  //   var uuid = Uuid();

  //   CollectionReference userCollection =
  //       FirebaseFirestore.instance.collection('users');
  //   userCollection.doc(uid).collection('chats').doc(uuid.v1()).set({
  //     'participant1': b.userId1,
  //     'participant2': b.userId2,
  //   }).then((result) async {
  //     return null;
  //   });
  // }
  Future<Users> retrieveUserInfo(String user) async {
    Users temp;
    DocumentSnapshot documentSnapshot =
        await FirebaseFirestore.instance.collection('users').doc(user).get();

    temp = Users.fromMap(documentSnapshot.data());

    return temp;
  }

  Future<dynamic> broadcastBrim(Brim b) async {
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      final coordinates =
          new Coordinates(position.latitude, position.longitude);
      // var addresses =
      //     await Geocoder.local.findAddressesFromCoordinates(coordinates);
      // var first = addresses.first;
      String id = DateTime.now().millisecondsSinceEpoch.toString() + uid;
      final databaseReference =
          FirebaseDatabase.instance.reference().child("brims");
      await databaseReference.child(id).set({
        'message': '${b.message}',
        'latitude': position.latitude.toString(),
        'longitude': position.longitude.toString(),
        'date': "${b.date}",
        'user': '${b.userId1}'
      }).then((_) {
        return null;
      });
    } catch (error) {
      return error;
    }
  }

  Future<List<BroadCastMessage>> getBroadcasts() async {
    List<BroadCastMessage> broadcasts = [];

    final databaseReference =
        FirebaseDatabase.instance.reference().child("brims");
    DataSnapshot snapshot = await databaseReference.once();
    Map<dynamic, dynamic> values = snapshot.value;
    if (values != null) {
      values.forEach((key, value) {
        var now = new DateTime.now();
        BroadCastMessage d1 = new BroadCastMessage();
        // d1.message = value["message"];
        // d1.user = value["user"];
        d1 = BroadCastMessage.fromMap(value);
        DateTime tempDate = new DateFormat("yyyy-MM-dd hh:mm:ss")
            .parse(value["date"].toString());
        if (DatabaseService()
            .convertUTCToLocalDateTime(tempDate)
            .isBefore(now.subtract(Duration(days: 1)))) {
          FirebaseDatabase.instance
              .reference()
              .child("brims")
              .child(key)
              .remove();
        }
        // d1.time = value["date"];
        broadcasts.add(d1);
      });
    }

    return broadcasts;
  }
}
