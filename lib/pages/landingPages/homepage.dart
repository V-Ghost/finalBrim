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

class Homepage extends StatefulWidget {
  Homepage({Key key}) : super(key: key);

  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  Setting firstRun;
  User user;
  bool registered;
  Users u;

  Future<void> getUserDetails() async {
    SharedPreferences myPrefs = await SharedPreferences.getInstance();
    print("how");

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
                error: "An Error occured when fetching you data :(",
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
