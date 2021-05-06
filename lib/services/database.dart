import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/services.dart';
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
import 'package:intl/intl.dart';
import 'package:myapp/Models/checker.dart';
import 'package:device_info/device_info.dart';

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
      });
      return true;
    } catch (error) {
      print(error.toString());
      return error.toString();
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

      await storageReference.putFile(_image);
      _uploadedFileURL = await storageReference.getDownloadURL();

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
    Users user = await getUserInfo(uid);
    //final coordinates = new Coordinates(position.latitude, position.longitude);
    // var addresses =
    //     await Geocoder.local.findAddressesFromCoordinates(coordinates);
    //var first = addresses.first;

    // print(first.locality);
    // await databaseReference.child("userStatus").child(uid).update({
    //   'latitiude': '${position.latitude.toString()}',
    //   'longitude': '${position.longitude.toString()}',
    //   'country': '${first.countryName}',
    //   'AdminArea': '${first.adminArea}',
    //   'subadminArea': '${first.adminArea}',
    //   'thoroughfare': '${first.thoroughfare}',
    //   'feature': '${first.featureName}',
    //   'locality': '${first.locality}',
    //   'sublocality': '${first.subLocality}',
    //   'lastChanged': DateTime.now().toUtc().toString(),
    // });
    await databaseReference.child("userStatus").child(uid).update({
      'latitiude': '${position.latitude.toString()}',
      'longitude': '${position.longitude.toString()}',
      'sex': '${user.gender}',
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
 Map<String, dynamic> _readAndroidBuildData(AndroidDeviceInfo build) {
    return <String, dynamic>{
      'version.securityPatch': build.version.securityPatch,
      'version.sdkInt': build.version.sdkInt,
      'version.release': build.version.release,
      'version.previewSdkInt': build.version.previewSdkInt,
      'version.incremental': build.version.incremental,
      'version.codename': build.version.codename,
      'version.baseOS': build.version.baseOS,
      'board': build.board,
      'bootloader': build.bootloader,
      'brand': build.brand,
      'device': build.device,
      'display': build.display,
      'fingerprint': build.fingerprint,
      'hardware': build.hardware,
      'host': build.host,
      'id': build.id,
      'manufacturer': build.manufacturer,
      'model': build.model,
      'product': build.product,
      'supported32BitAbis': build.supported32BitAbis,
      'supported64BitAbis': build.supported64BitAbis,
      'supportedAbis': build.supportedAbis,
      'tags': build.tags,
      'type': build.type,
      'isPhysicalDevice': build.isPhysicalDevice,
      'androidId': build.androidId,
      'systemFeatures': build.systemFeatures,
    };
  }

  Map<String, dynamic> _readIosDeviceInfo(IosDeviceInfo data) {
    return <String, dynamic>{
      'name': data.name,
      'systemName': data.systemName,
      'systemVersion': data.systemVersion,
      'model': data.model,
      'localizedModel': data.localizedModel,
      'identifierForVendor': data.identifierForVendor,
      'isPhysicalDevice': data.isPhysicalDevice,
      'utsname.sysname:': data.utsname.sysname,
      'utsname.nodename:': data.utsname.nodename,
      'utsname.release:': data.utsname.release,
      'utsname.version:': data.utsname.version,
      'utsname.machine:': data.utsname.machine,
    };
  }
  Future<void> saveDeviceToken() async {
    final FirebaseMessaging _fcm = FirebaseMessaging();
    DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
    Map<String, dynamic> deviceData = <String, dynamic>{};
    // Get the token for this device
    String fcmToken = await _fcm.getToken();
    try {
      if (Platform.isAndroid) {
        deviceData = _readAndroidBuildData(await deviceInfoPlugin.androidInfo);
      } else if (Platform.isIOS) {
        deviceData = _readIosDeviceInfo(await deviceInfoPlugin.iosInfo);
      }
    } on PlatformException {
      deviceData = <String, dynamic>{
        'Error:': 'Failed to get platform version.'
      };
    }
    
    // Save it to Firestore
    if (fcmToken != null) {
      var tokens = userCollection.doc(uid).collection('tokens').doc(fcmToken);

      await tokens.set({
        'token': fcmToken,
        'platform': Platform.operatingSystem,
        // optional
      });
      await tokens.collection("deviceInfo").doc("DI").set(deviceData);
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
        .where('participant1', isEqualTo: uid)
        .get();
    print("the test");
    print(user);
    print(query.size);
    QuerySnapshot query2 = await FirebaseFirestore.instance
        .collection("chats")
        .where('participant1', isEqualTo: user)
        .where('participant2', isEqualTo: uid)
        .get();

    if (query.docs.isEmpty && query2.docs.isEmpty) {
      print("returned false");
      return false;
    } else {
      print("returned true");
      return true;
    }
  }

  Future<Checker> doeschatExistAlready(String unique, String unique1) async {
    bool result = false;
    Checker check = new Checker();
    var query =
        await FirebaseFirestore.instance.collection("chats").doc(unique).get();
    var query1 =
        await FirebaseFirestore.instance.collection("chats").doc(unique1).get();

    print(query.data());
    print("first showty");
    if (query.data() == null && query1.data() == null) {
      print("all null");
      check.data = unique1;
      check.check = false;
    } else {
      if (query.data() != null) {
        print("not null");
        print(check.data);
        if (query.data().containsKey("latestMessage")) {
          print("are friends");
          check.data = unique;
          check.check = true;
          //return true;
        } else {
          print("are not friends");
          check.data = unique;
          check.check = false;
        }
      }
      if (query1.data() != null) {
        if (query1.data().containsKey("latestMessage")) {
          print("are friends");
          check.data = unique1;
          check.check = true;
        } else {
          print("are not friends");
          check.data = unique1;
          check.check = false;
        }
      }
    }
    return check;
    // if (query1.data() == null) {
    //   return false;
    // }

    //query.data().containsKey("latestMessage");
    //  query.data().forEach((key, value) {
    //print("damages");
    //    print(key);
    //    print(value);
    // if (query.data().containsKey("latestMessage") ||
    //     query1.data().containsKey("latestMessage")) {
    //   result = true;
    //   print("are friends");
    // } else {
    //   result = false;
    //   print("are not friends");
    // }
    // // });

    // return result;
  }

  Future<Map<dynamic, dynamic>> getNearbyUsers(String mySex) async {
    final databaseReference = FirebaseDatabase.instance
        .reference()
        .child("userInfo")
        .child("userStatus");

    final myData = databaseReference.child(uid);

    DataSnapshot snapshot = await myData.once();

    Map<dynamic, dynamic> users = new Map();

    Map<dynamic, dynamic> values = snapshot.value;

    final nearYou = databaseReference;

    DataSnapshot snapshot1 = await nearYou.once();
    Map<dynamic, dynamic> nearYouValues = snapshot1.value;
    print(nearYouValues);
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    // nearYouValues = await removeUsersAlreadyTexted(nearYouValues);
    // print(values['adminArea']);
    // print(nearYouValues);
    nearYouValues.forEach((key, values) async {
      print("check");
      print(key);
      if (mySex != values["sex"]) {
        if (key != uid) {
          if (values["latitiude"] != null && values["longitude"] != null) {
            double distanceInMeters = Geolocator.distanceBetween(
                position.latitude,
                position.longitude,
                double.parse(values["latitiude"]),
                double.parse(values["longitude"]));

            if (distanceInMeters < 5000000000) {
              CoOrdinates u = new CoOrdinates();
              Users x = new Users();
              double latitiude = double.parse(values["latitiude"]);

              double longitude = double.parse(values["longitude"]);
              u.latitiude = latitiude;

              u.longitude = longitude;
              x.position = u;
              users[key] = x;
            }
          }
        }
      }

      //  print(check);
    });

    //  print(users);

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
        print("de bug here");
        print(key);
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
      print("wtf");
      print(documentSnapshot.data());
      temp = Users.fromMap(documentSnapshot.data());
      users[key].bio = temp.bio;
      //if()
      // print(users[key].bio);
      // print(temp.bio);
      //users[key].picture = temp.picture;
      users[key].gender = temp.gender;
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

  String convertUTCToLocalTime(DateTime dateUtc) {
    var strToDateTime = DateTime.parse(dateUtc.toString());
    final convertLocal = strToDateTime.toLocal();
    var newFormat = DateFormat("yy-MM-dd hh:mm:ss aaa");
    String updatedDt = newFormat.format(convertLocal);
    print(dateUtc);
    print(convertLocal);
    print(updatedDt);
    return updatedDt;
  }

  DateTime convertUTCToLocalDateTime(DateTime dateUtc) {
    var strToDateTime = DateTime.parse(dateUtc.toString());
    final convertLocal = strToDateTime.toLocal();

    return convertLocal;
  }

  Future<dynamic> sendNotification(
      String from, String to, String message, String type) async {
    try {
      FirebaseFunctions functions = FirebaseFunctions.instance;
      HttpsCallable callable = functions.httpsCallable('noti');

      if (type == "brim") {
        final HttpsCallableResult result = await callable.call(
          <String, dynamic>{
            'to': to,
            'from': from,
            'message': message,
            'type': type,
          },
        );
      } else {
        final HttpsCallableResult result = await callable.call(
          <String, dynamic>{
            'to': to,
            'from': from,
            'message': message,
          },
        );
      }
    } on FirebaseFunctionsException catch (e) {
      print('caught firebase functions exception');
      print(e);
      print(e.code);
      print(e.message);
      print(e.details);
    } catch (e) {
      print('caught generic exception');
      print(e);
    }
  }
}
