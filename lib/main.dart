import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/services.dart';
import 'package:myapp/Models/setting.dart';
import 'package:myapp/Models/users.dart';
import 'package:myapp/pages/landingPages/homepage.dart';
import 'package:myapp/pages/login.dart';
import 'package:myapp/pages/navBarPages/chats.dart';
import 'package:myapp/pages/register/loginUi.dart';
import 'package:myapp/pages/signup.dart';

import 'package:provider/provider.dart';
import 'package:myapp/pages/userDetails.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  bool loggedIn = false;

  Future<dynamic> intialize() async {
    // tz.initializeTimeZones();
      await Firebase.initializeApp();
     
      SharedPreferences myPrefs = await SharedPreferences.getInstance();
       myPrefs.setBool("login", false);
    FirebaseAuth.instance.authStateChanges().listen((User user) {
      if (user == null) {
        loggedIn = false;
          myPrefs.setBool("loggedIn", false);
        print("not logged");
       
      } else {
        loggedIn = true;
          myPrefs.setBool("loggedIn", true);
         print("logged");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: Users().instance,
        ),
        ChangeNotifierProvider.value(
          value: Setting().instance,
        ),
      ],
      child: FutureBuilder(
          future: intialize(),
          builder: (context, snapshot) {
            print("build started");
             print(loggedIn);
            if (snapshot.hasError) {
              return MaterialApp(
                debugShowCheckedModeBanner: false,
                home: Scaffold(
                  body: Center(
                    child: Icon(Icons.error),
                  ),
                ),
              );
            }

            if (snapshot.connectionState == ConnectionState.done) {
              print("done");
              print(loggedIn);
              
              return MaterialApp(
               
                // initialRoute: '/',
                routes: {
                  // When navigating to the "/" route, build the FirstScreen widget.
                  '/login': (context) => Login(),

                  '/start': (context) => MyApp(),
                  // When navigating to the "/second" route, build the SecondScreen widget.
                  '/signup': (context) => UserDetails(),
                  '/chats': (context) => Chats(),
                },
                debugShowCheckedModeBanner: false,
                title: 'Flutter Demo',
                theme: ThemeData(
                  primaryColor: Colors.purple,
                  accentColor: Colors.purpleAccent,
                  buttonColor: Colors.purple,
                  pageTransitionsTheme: PageTransitionsTheme(builders: {
                    TargetPlatform.android: CupertinoPageTransitionsBuilder(),
                    TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
                  }),
                  primarySwatch: Colors.purple,
                  fontFamily: 'Merriweather',
                  // visualDensity: VisualDensity.adaptivePlatformDensity,
                ),
                home: loggedIn ? Homepage() : LoginUI(),
                //  home:  UserDetails(),
              );
            }
            return MaterialApp(
              theme: ThemeData(
                primaryColor: Colors.purple,
                accentColor: Colors.purpleAccent,
                buttonColor: Colors.purple,

                primarySwatch: Colors.purple,

                // visualDensity: VisualDensity.adaptivePlatformDensity,
              ),
              debugShowCheckedModeBanner: false,
              home: Scaffold(
                body: Center(
                  child: CircularProgressIndicator(
                    backgroundColor: Colors.white,
                  ),
                ),
              ),
            );
          }),
    );
  }
}
