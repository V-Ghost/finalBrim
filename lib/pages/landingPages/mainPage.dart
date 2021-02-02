import 'dart:async';
import 'dart:io';
import 'package:myapp/Models/CoOrdinates.dart';
import 'package:myapp/Models/setting.dart';
import 'package:myapp/main.dart';
import 'package:myapp/pages/navBarPages/brimPage.dart';
import 'package:myapp/pages/navBarPages/chats.dart';
import 'package:myapp/pages/navBarPages/mapPage.dart';
import 'package:myapp/pages/navBarPages/slide.dart';
import 'package:myapp/pages/register/loginUi.dart';
import 'package:myapp/services/chatService.dart';
import 'package:myapp/services/database.dart';

import 'package:myapp/Models/users.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MainPage extends StatefulWidget {
  MainPage({Key key}) : super(key: key);

  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> with WidgetsBindingObserver {
  final Geolocator geolocator = Geolocator();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  Position _currentPosition;
  StreamSubscription positionStream;
  Users u;
  User user;
  Setting firstRun;
  int _selectedIndex = 0;
  static List<Widget> _widgetOptions = <Widget>[MapPage(), Chats(), Slide()];
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  bool isLocationServiceEnabled;
  LocationPermission permission;
  double height;
  Future _dialog;
  SharedPreferences myPrefs;
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  StreamSubscription iosSubscription;
  @override
  void initState() {
    user = FirebaseAuth.instance.currentUser;
    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        // final notification = message['notification'];
        // print("onMessage: $message");
        // String n = message['notification']['title'];
        // print("new noootiiifiiicccaa");
        // print(message['data']['type']);
        // if (message['data']['type'].toString() == "brim") {
        //   showDialog(
        //     context: context,
        //     builder: (BuildContext context) {
        //       // return object of type Dialog
        //       return AlertDialog(
        //         title: new Text(message['notification']['title']),
        //         content: new Text(message['notification']['body']),
        //         actions: <Widget>[
        //           // usually buttons at the bottom of the dialog
        //           new FlatButton(
        //             child: new Text("Close"),
        //             onPressed: () {
        //               Navigator.of(context).pop();
        //             },
        //           ),
        //         ],
        //       );
        //     },
        //   );
        // }
        //if(message['data']['type'] == )
        //     showDialog(
        //   context: context,
        //   builder: (BuildContext context) {
        //     // return object of type Dialog
        //     return AlertDialog(
        //       title: new Text(message['notification']['title']),
        //       content: new Text(message['notification']['body']),
        //       actions: <Widget>[
        //         // usually buttons at the bottom of the dialog
        //         new FlatButton(
        //           child: new Text("Close"),
        //           onPressed: () {
        //             Navigator.of(context).pop();
        //           },
        //         ),
        //       ],
        //     );
        //   },
        // );
      },
      onLaunch: (Map<String, dynamic> message) async {
        // final notification = message['data'];
        if (message['data']['type'].toString() != null) {
          Navigator.push(
            context,
            CupertinoPageRoute(
              builder: (context) => Chats(),
            ),
          );
        }
      },
      onResume: (Map<String, dynamic> message) async {
        //  final notification = message['data'];
        print("onMessage: $message");
      },
    );
    if (Platform.isIOS) {
      iosSubscription =
          _firebaseMessaging.onIosSettingsRegistered.listen((data) {
        DatabaseService(uid: user.uid).saveDeviceToken();
      });

      _firebaseMessaging.requestNotificationPermissions(
          const IosNotificationSettings(sound: true, badge: true, alert: true));
    } else {
      print("hii ios");
      DatabaseService(uid: user.uid).saveDeviceToken();
    }

    WidgetsBinding.instance.addObserver(this);

    u = Provider.of<Users>(context, listen: false);

    firstRun = Provider.of<Setting>(context, listen: false);
    const oneSec = const Duration(seconds: 40);
    // new Timer.periodic(oneSec, (Timer t) =>  DatabaseService(uid : user.uid).onlineUpdate());
    print('first');
    final databaseReference = FirebaseDatabase.instance
        .reference()
        .child("userInfo")
        .child("userStatus")
        .child(user.uid);

    databaseReference.onDisconnect().update({
      'status': 'offline',
      'lastChanged': DateTime.now().toUtc().toString()
    }).then((_) async {});
    DatabaseService(uid: user.uid).onlineUpdate();
    DatabaseService(uid: user.uid).saveDeviceToken();
    super.initState();
  }

  @override
  void dispose() {
    positionStream?.cancel();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      print("object");
      _listenForLocation(context);
    }
  }

  _listenForLocation(BuildContext context) async {
    // SharedPreferences myPrefs = await SharedPreferences.getInstance();
    // String location = myPrefs.getString("location");
    // print(location);
    // if (myPrefs.getString("location") != null) {
    //   final databaseReference =
    //       FirebaseDatabase.instance.reference().child("userInfo").child(location).child(user.uid);
    //   databaseReference.onValue.listen((data) {
    //     print("it change ooo");
    //   });
    // }

    isLocationServiceEnabled = await Geolocator.isLocationServiceEnabled();
    if (isLocationServiceEnabled) {
      // setState(() {

      // });
      if (_dialog != null) {
        Navigator.of(context).pop();
        _dialog = null;
      }

      // permission = await Geolocator.requestPermission();
      positionStream = Geolocator.getPositionStream(
              desiredAccuracy: LocationAccuracy.best, distanceFilter: 5)
          .listen((Position position) {
        DatabaseService(uid: user.uid).locationUpdate(position);
      });
    } else {
      if (_dialog == null) {
        _dialog = showMyDialog(context);
        await _dialog;
        print('found');
      } else {
        //do nothing
        print('not found');
      }
      print("falsee");
    }
  }

  checkPermissionsAndLocation() async {
    isLocationServiceEnabled = await Geolocator.isLocationServiceEnabled();
    permission = await Geolocator.requestPermission();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    _listenForLocation(context);
    //  print(firstRun.firstRun);
    return Scaffold(
      body: WillPopScope(
        onWillPop: () async {
          await SystemNavigator.pop();
        },
        child: Scaffold(
          key: _scaffoldKey,

          // drawer: Drawer(
          //   child: ListView(
          //     padding: EdgeInsets.zero,
          //     children: <Widget>[
          //       DrawerHeader(
          //         padding: const EdgeInsets.only(
          //             top: 30, bottom: 30, left: 90, right: 90),
          //         child: CircleAvatar(
          //           radius: 2,
          //           backgroundImage: NetworkImage("${u.picture}"),
          //           backgroundColor: Colors.purple,
          //         ),
          //         decoration: BoxDecoration(
          //             // color: Colors.white,
          //             ),
          //       ),
          //       ListTile(
          //         title: Text('Log Out'),
          //         leading: Icon(
          //           CupertinoIcons.fullscreen_exit,
          //           color: Colors.grey,
          //           semanticLabel: 'Text to announce in accessibility modes',
          //         ),
          //         onTap: () async {

          //           await  _auth.signOut();

          //             Navigator.push(
          //                     context,
          //                     CupertinoPageRoute(
          //                         settings: RouteSettings(name: "Foo"),
          //                         builder: (context) => LoginUI()),
          //                   );

          //         },
          //       ),

          //     ],
          //   ),
          // ),
          // floatingActionButton: FloatingActionButton(
          //   child: Text("LOGOUT !!!"),
          //   onPressed: () {
          //     final FirebaseAuth _auth = FirebaseAuth.instance;

          //     _auth.signOut();
          //     runApp(MyApp());
          //     // Navigator.popUntil(context, ModalRoute.withName('/gettingStarted'));
          //   },
          // ),
          body: Center(
            child: _widgetOptions.elementAt(_selectedIndex),
          ),
          bottomNavigationBar: BottomNavigationBar(
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(
                  CupertinoIcons.location_solid,
                  size: 30,
                ),
                title: Text('Brim'),
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.chat_bubble_outline,
                  size: 30,
                ),
                title: Text('Chat'),
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  CupertinoIcons.eye,
                  size: 30,
                ),
                title: Text('Broadcast'),
              ),
            ],
            currentIndex: _selectedIndex,
            selectedItemColor: Colors.purple,
            unselectedItemColor: Colors.black,
            type: BottomNavigationBarType.fixed,
            showSelectedLabels: false,
            showUnselectedLabels: false,
            backgroundColor: Colors.white,
            elevation: 0,
            onTap: _onItemTapped,
          ),
        ),
      ),
    );
  }

  Future showMyDialog(BuildContext context) {
    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Location Error'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text("please turn on location setting"),
              ],
            ),
          ),
          actions: <Widget>[
            // GestureDetector(
            //   child: Text('Close'),
            //   onTap: () {
            //     Navigator.of(context).pop();
            //   },
            // ),

            GestureDetector(
              child: Text('go to setting'),
              onTap: () async {
                await Geolocator.openLocationSettings();
              },
            ),
          ],
        );
      },
    );
  }
}
