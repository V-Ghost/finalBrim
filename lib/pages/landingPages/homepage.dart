import 'dart:async';
import 'package:myapp/Models/setting.dart';
import 'package:myapp/Models/users.dart';
import 'package:myapp/pages/landingPages/mainPage.dart';
import 'package:myapp/pages/register/loginUi.dart';
import 'package:myapp/pages/register/userDetails/registerationPage.dart';
import 'package:myapp/pages/signup.dart';
import 'package:myapp/services/database.dart';
import 'package:myapp/widgets/errorWidget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:myapp/services/auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Homepage extends StatefulWidget {
  Homepage({Key key}) : super(key: key);

  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  Setting firstRun;
  User user;
  bool registered;
  Users u;
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  Future<void> getUserDetails() async {
    //await AuthService(uid: user.uid).signOut();
    SharedPreferences myPrefs = await SharedPreferences.getInstance();
    print("how");
    var oneDayAgo =
        Timestamp.fromDate(DateTime.now().toUtc().subtract(Duration(days: 1)));
    var query = await FirebaseFirestore.instance
        .collection('chats')
        .where('type', isEqualTo: 'brim')
        .where('members', arrayContains: user.uid)
        .get();
    query.docs.forEach((data) async {
      print("data");
      print(data.data());

      //DatabaseService().sendNotification();
      var now = new DateTime.now();
      if (data.data().isNotEmpty) {
        if (DatabaseService()
            .convertUTCToLocalDateTime(data.data()['latest'].toDate())
            .isBefore(now.subtract(Duration(days: 1)))) {
          print("delting here");
          print(data.id);

          var query = await FirebaseFirestore.instance
              .collection('chats')
              .doc(data.id)
              .collection("messages")
              .get();
          query.docs.forEach((doc) {
            FirebaseFirestore.instance
                .collection('chats')
                .doc(data.id)
                .collection("messages")
                .doc(doc.id)
                .delete();
          });
          FirebaseFirestore.instance.collection('chats').doc(data.id).delete();
          // print("eii hun");
          // print(query.;

          // query.data().forEach((key,value){
          //     print("ma deletii");
          //     print(key);
          //     print(value);
          // });

        }
      }
      //var nextCheck = new DateTime(now  .getYear(), now.getMonth(), now.getDate() + 1);
    });
    if (myPrefs.getBool('loggedIn')) {
      Users temp;
      DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      print(documentSnapshot.data());
      if (documentSnapshot.exists) {
        temp = Users.fromMap(documentSnapshot.data());
        u.picture = temp.picture;
        u.userName = temp.userName;
        u.bio = temp.bio;
        u.dob = temp.dob;
        u.gender = temp.gender;

        user = FirebaseAuth.instance.currentUser;
        SharedPreferences myPrefs = await SharedPreferences.getInstance();
        firstRun.firstRun = myPrefs.getBool('isFirstRun');
        print(firstRun.firstRun);
        myPrefs.setBool("isFirstRun", false);
        print(u.picture);
        registered = true;
      } else {
        registered = false;
      }
    } else {
      Navigator.push(
        context,
        CupertinoPageRoute(builder: (context) => LoginUI()),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    u = Provider.of<Users>(context, listen: false);
    firstRun = Provider.of<Setting>(context, listen: false);
    print("open");
    // user = Provider.of<User>(context, listen: false);
    user = FirebaseAuth.instance.currentUser;
   
    // u = DatabaseService(uid: user.uid).getUserDetails();
    // print(user.uid);
    // _getCurrentLocation();
  }

  @override
  void dispose() {
    super.dispose();
  }

  // int _selectedIndex = 0;
  // static List<Widget> _widgetOptions = <Widget>[myappPage(), Chats(), Slide()];
  // _getCurrentLocation() {
  //   Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
  //       .then((Position position) {
  //     setState(() {
  //       _currentPosition = position;
  //     });
  //   }).catchError((e) {
  //     print(e);
  //   });
  // }

  // void _onItemTapped(int index) {
  //   setState(() {
  //     _selectedIndex = index;
  //   });
  // }

  //  _scaffoldKey.currentState.openDrawer();
  @override
  Widget build(BuildContext context) {
    print("i conf");
    return FutureBuilder(
        future: getUserDetails(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Scaffold(
              body: Center(
                  child: ShowError(
                size: 100,
                color: Colors.grey,
                error: snapshot.error.toString(),
              )),
            );
          }

          if (snapshot.connectionState == ConnectionState.done) {
            return registered ? MainPage() : RegisterationPage();
          }
          return Container(
            color: Colors.white,
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        });
  }
}
