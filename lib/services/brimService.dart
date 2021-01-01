import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myapp/Models/brim.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:myapp/Models/broadcastMessage.dart';
import 'package:myapp/Models/users.dart';
import 'package:myapp/services/database.dart';
import 'package:uuid/uuid.dart';

class BrimService {
  final String uid;
  BrimService({this.uid});

  Future<dynamic> sendBrim(Brim b) async {
    try {
      var check = await DatabaseService(uid: uid)
          .doesBrimMessageExistAlready(b.userId2);
      if (check != true) {
        var uuid = Uuid();
        var unique = b.userId1 + b.userId2;
        var u1 = Uuid();
        print(b.userId2);
        CollectionReference userCollection =
            FirebaseFirestore.instance.collection('chats');
        await userCollection.doc(unique).set({
          'participant1': b.userId1,
          'participant2': b.userId2,
          'type': 'brim',
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
          'time': DateTime.now().toUtc(),
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

  Future<dynamic> startChat(Brim b) async {
    var uuid = Uuid();

    CollectionReference userCollection =
        FirebaseFirestore.instance.collection('users');
    userCollection.doc(uid).collection('chats').doc(uuid.v1()).set({
      'participant1': b.userId1,
      'participant2': b.userId2,
    }).then((result) async {
      return null;
    });
  }
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
      var addresses =
          await Geocoder.local.findAddressesFromCoordinates(coordinates);
      var first = addresses.first;
      String id = DateTime.now().millisecondsSinceEpoch.toString() + uid;
      final databaseReference =
          FirebaseDatabase.instance.reference().child("brims");
      await databaseReference.child(id).set({
        'message': '${b.message}',
        'latitude': position.latitude.toString(),
        'longitude': position.longitude.toString(),
        'date': DateTime.now().toUtc(),
        'user': '${b.userId1}'
      }).then((_) {
        return null;
      });
    } catch (error) {
      return error;
    }
  }

  Future<List<BroadCastMessage>> getBroadcasts() async {
    List<BroadCastMessage> broadcasts = [] ;
   
    final databaseReference =
        FirebaseDatabase.instance.reference().child("brims");
    DataSnapshot snapshot = await databaseReference.once();
    Map<dynamic, dynamic> values = snapshot.value;
    values.forEach((key, value){
       BroadCastMessage d1 = new BroadCastMessage();
        d1.message = value["message"];
        d1.user =   value["user"];
        // d1.time = value["date"];
        broadcasts.add(d1);
    });

    return broadcasts;
  }
}