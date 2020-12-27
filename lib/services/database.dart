import 'package:myapp/Models/CoOrdinates.dart';
import 'package:myapp/Models/brim.dart';
import 'package:myapp/Models/status.dart';
import 'package:myapp/Models/userInfo.dart';
import 'package:myapp/Models/users.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:path/path.dart' as Path;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class DatabaseService {
  final String uid;
  DatabaseService({this.uid});
  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection('users');

  Future<dynamic> updateUserData(Users u) async {
    try {
      await userCollection.doc(uid).set({
        'username': u.userName,
        'bio': u.bio,
        'picture': u.picture,
        'dob': u.dob,
        'gender': u.gender,
      }).then((result) {
        return true;
      });
    } catch (error) {
      print(error.toString());
      return false;
    }
  }

  Future<dynamic> uploadFile(File _image) async {
    try {
      // String _uploadedFileURL;
      // firebase_storage.Reference storageReference =
      //     FirebaseStorage.instance.ref().child('avatar/$uid');
      // firebase_storage.UploadTask uploadTask = storageReference.putFile(_image);
      
      // _uploadedFileURL = await storageReference.getDownloadURL();
   
     String _uploadedFileURL;
    firebase_storage.Reference storageReference =
        FirebaseStorage.instance.ref().child('avatar/$uid');
   
        storageReference.putFile(_image).whenComplete(() async {
      _uploadedFileURL = await storageReference.getDownloadURL();
    }).catchError((onError) {
      print(onError.toString());
      return onError.toString();
    });
       print('File Upppppppppppppppppppppppppppppppppppppppppppppppploaded');
      return _uploadedFileURL;
    } catch (error) {

      return error;
    }
  }

  Future<void> locationUpdate(Position position) async {
    UserInfos u;
    SharedPreferences myPrefs = await SharedPreferences.getInstance();
    final databaseReference =
        FirebaseDatabase.instance.reference().child("userInfo");
    final coordinates = new Coordinates(position.latitude, position.longitude);
    var addresses =
        await Geocoder.local.findAddressesFromCoordinates(coordinates);
    var first = addresses.first;

    print(first.locality);
    await databaseReference.child("userStatus").child(uid).update({
      'latitiude': '${position.latitude.toString()}',
      'longitude': '${position.longitude.toString()}',
      'country': '${first.countryName}',
      'AdminArea': '${first.adminArea}',
      'subadminArea': '${first.adminArea}',
      'thoroughfare': '${first.thoroughfare}',
      'feature': '${first.featureName}',
      'locality': '${first.locality}',
      'sublocality': '${first.subLocality}',
      'lastChanged': DateTime.now().toUtc().toString(),
    });
    // if (first.featureName == null) {
    //   String location = myPrefs.getString("location");
    //   if (myPrefs.getString("location") != null) {
    //      await databaseReference.child(location).child(uid).remove();
    //     await databaseReference.child("unknownLocation").child(uid).set({
    //     'latitiude': '${position.latitude.toString()}',
    //     'longitude': '${position.longitude.toString()}',
    //   });
    //   myPrefs.setString("location", "unknownLocation");
    //   }else{
    //     await databaseReference.child("unknownLocation").child(uid).set({
    //     'latitiude': '${position.latitude.toString()}',
    //     'longitude': '${position.longitude.toString()}',
    //   });
    //   myPrefs.setString("location", "unknownLocation");
    //   }

    // } else {
    //   // double distanceInMeters = Geolocator.distanceBetween(
    //   //     5.6569033, 5.6569033, 5.6569535, 5.6569031);
    //   // print(distanceInMeters);
    //   String location = myPrefs.getString("location");
    //   if (myPrefs.getString("location") != null) {
    //     await databaseReference.child(location).child(uid).remove();
    //     await databaseReference.child("${first.featureName}").child(uid).set({
    //       'latitiude': '${position.latitude.toString()}',
    //       'longitude': '${position.longitude.toString()}',
    //     });
    //     myPrefs.setString("location", "${first.featureName}");
    //   }
    //   else{
    //    await databaseReference.child("${first.featureName}").child(uid).set({
    //       'latitiude': '${position.latitude.toString()}',
    //       'longitude': '${position.longitude.toString()}',
    //     });
    //     myPrefs.setString("location", "${first.featureName}");
    // }
    // }

    //to get nearest user use the location node
  }

  Future<void> saveDeviceToken() async {
    final FirebaseMessaging _fcm = FirebaseMessaging();

    // Get the token for this device
    String fcmToken = await _fcm.getToken();

    // Save it to Firestore
    if (fcmToken != null) {
      var tokens = userCollection.doc(uid).collection('tokens').doc(fcmToken);

      await tokens.set({
        'token': fcmToken,
        'platform': Platform.operatingSystem,
        // optional
      });
    }
  }

  Future<void> onlineUpdate() async {
    // Position position = await Geolocator.getCurrentPosition(
    //     desiredAccuracy: LocationAccuracy.high);
    // final coordinates = new Coordinates(position.latitude, position.longitude);
    // var addresses = await Geocoder.local.findAddressesFromCoordinates(coordinates);
    // var first = addresses.first;
    final databaseReference = FirebaseDatabase.instance
        .reference()
        .child("userInfo")
        .child("userStatus")
        .child(uid);
    databaseReference.update({
      'status': 'online',
      'lastChanged': DateTime.now().toUtc().toString(),
    });
  }

  Future<bool> doesBrimMessageExistAlready(String user) async {
    QuerySnapshot query = await FirebaseFirestore.instance
        .collection("chats")
        .where('participant2', isEqualTo: user)
        .get();

    QuerySnapshot query2 = await FirebaseFirestore.instance
        .collection("chats")
        .where('participant1', isEqualTo: user)
        .get();
    // query.docs.forEach((value) {
    //   print("query");
    //   print(value.data());
    // });
    // query2.docs.forEach((value) {
    //   print("query2");
    //   print(value.data());
    // });
    if (query.docs.isEmpty && query2.docs.isEmpty) {
      return false;
    } else {
      return true;
    }
  }

  Future<Map<dynamic, dynamic>> getNearbyUsers() async {
    final databaseReference = FirebaseDatabase.instance
        .reference()
        .child("userInfo")
        .child("userStatus");

    final myData = databaseReference.child(uid);

    DataSnapshot snapshot = await myData.once();

    Map<dynamic, dynamic> users = new Map();

    Map<dynamic, dynamic> values = snapshot.value;

    final nearYou = databaseReference
        .orderByChild("AdminArea")
        .equalTo(values['AdminArea']);
    DataSnapshot snapshot1 = await nearYou.once();
    Map<dynamic, dynamic> nearYouValues = snapshot1.value;

    nearYouValues = await removeUsersAlreadyTexted(nearYouValues);
    // print(values['adminArea']);
    // print(nearYouValues);
    nearYouValues.forEach((key, values) async {
      // var check =  doesBrimMessageExistAlready(key);

      print(key != uid);
      //  print(check);
      if (key != uid) {
        CoOrdinates u = new CoOrdinates();
        Users x = new Users();
        double latitiude = double.parse(values["latitiude"]);

        double longitude = double.parse(values["longitude"]);
        u.latitiude = latitiude;

        u.longitude = longitude;
        x.position = u;
        users[key] = x;
      }
    });

    //  print(users);
    print(" 1st");

    //  print(users["t3MYcrmwZ9VemLCSOPRI2bOxD9s2"].bio);
    //   print(users["t3MYcrmwZ9VemLCSOPRI2bOxD9s2"].position.longitude);
    //   print("eii");
    return users;
  }

  Future<Map<dynamic, dynamic>> removeUsersAlreadyTexted(
      Map<dynamic, dynamic> users) async {
    users.forEach((key, values) async {
      var check = await doesBrimMessageExistAlready(key);
      // print("it's true");
      //  print(check);
      if (check == true) {
        users.remove(key);
      }
    });
    return users;
  }

  Future<Map<dynamic, dynamic>> retrieveOtherInfo(
      Map<dynamic, dynamic> users) async {
    Users temp;
    users.forEach((key, value) async {
      DocumentSnapshot documentSnapshot =
          await FirebaseFirestore.instance.collection('users').doc(key).get();
      temp = Users.fromMap(documentSnapshot.data());
      users[key].bio = temp.bio;
      // print(users[key].bio);
      // print(temp.bio);
      users[key].picture = temp.picture;
      //  print(value.picture);
      // print(temp.picture);
      value.userName = temp.userName;
      //  print(value.userName);
      // print(temp.userName);
      // print(documentSnapshot.data());
      // print("2nd");
    });
    // print("ah");
    return users;
  }

  Future<Users> getUserInfo(String user) async {
    DocumentSnapshot documentSnapshot =
        await FirebaseFirestore.instance.collection('users').doc(user).get();

    Users u = new Users();
    Users temp = new Users();

    temp = Users.fromMap(documentSnapshot.data());
    u.picture = temp.picture;
    u.userName = temp.userName;
    u.bio = temp.bio;

    u.gender = temp.gender;
    return u;
  }
}
