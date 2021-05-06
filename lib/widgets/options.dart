import 'dart:collection';
import 'dart:ui' as ui;
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:async';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:myapp/Models/users.dart';
import 'package:myapp/pages/editProfile.dart';
import 'package:myapp/pages/register/loginUi.dart';
import 'package:myapp/pages/sendBrims.dart';
import 'package:myapp/services/auth.dart';
import 'package:myapp/services/database.dart';
import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:myapp/widgets/raisedGradientButton.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class OptionsMenu extends StatefulWidget {
  final   Users u;

  OptionsMenu({Key key,this.u}) : super(key: key);

  _OptionsMenuState createState() => _OptionsMenuState();
}

class _OptionsMenuState extends State<OptionsMenu> {
  User user;
   Users u;
  @override
  void initState() {
    user = FirebaseAuth.instance.currentUser;
     u = Provider.of<Users>(context, listen: false);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
          onTap: () {
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              isDismissible: true,
              backgroundColor: Colors.transparent,
              builder: (context) => Container(
                height: MediaQuery.of(context).size.height * 0.8,
                decoration: new BoxDecoration(
                  color: Colors.white,
                  borderRadius: new BorderRadius.only(
                    topLeft: const Radius.circular(25.0),
                    topRight: const Radius.circular(25.0),
                  ),
                ),
                child: ListView(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 40, bottom: 25, left: 110, right: 110),
                      child: Container(
                        height: 70,
                        width: 50,
                        child: Image(
                            image: AssetImage(
                          'lib/images/brim0.png',
                        )),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 40, right: 40),
                      child: ButtonTheme(
                        height: 50,
                        child: RaisedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              CupertinoPageRoute(
                                  builder: (context) => EditProfile()),
                            );
                          },

                          // borderSide: BorderSide(color: Colors.blue),
                          shape: new RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(30.0)),
                          color: Colors.purple,
                          // height: 30,
                          // width: 100,
                          child: Row(
                            children: [
                              Expanded(
                                child: Container(),
                              ),
                              Icon(
                                Icons.person,
                                color: Colors.white,
                              ),
                              SizedBox(
                                width: 20,
                              ),
                              Text(
                                'Edit Profile',
                                style: TextStyle(color: Colors.white),
                              ),
                              Expanded(
                                child: Container(),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 40, right: 40),
                      child: ButtonTheme(
                        height: 50,
                        child: RaisedButton(
                          onPressed: () {
                            return showAboutDialog(
                              //icon: Icon(Icons.info),
                              applicationIcon: ImageIcon(
                                AssetImage("lib/images/brim0.png"),
                                // color: Color(0xFF3A5A98),
                              ),
                              applicationName: 'Brim the LinkApp',
                              applicationVersion: 'version 1.0.0',
                              applicationLegalese: '© 2021 Timisu',
                              context: context,
                              //aboutBoxChildren: aboutBoxChildren,
                            );
                          },

                          // borderSide: BorderSide(color: Colors.blue),
                          shape: new RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(30.0)),
                          color: Colors.pinkAccent,
                          // height: 30,
                          // width: 100,
                          child: Row(
                            children: [
                              Expanded(
                                child: Container(),
                              ),
                              Icon(
                                Icons.info,
                                color: Colors.white,
                              ),
                              SizedBox(
                                width: 20,
                              ),
                              Text(
                                'About Us',
                                style: TextStyle(color: Colors.white),
                              ),
                              Expanded(
                                child: Container(),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 40, right: 40),
                      child: ButtonTheme(
                        height: 50,
                        child: RaisedButton(
                          onPressed: () {},

                          // borderSide: BorderSide(color: Colors.blue),
                          shape: new RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(30.0)),
                          color: Colors.blue,
                          // height: 30,
                          // width: 100,
                          child: Row(
                            children: [
                              Expanded(
                                child: Container(),
                              ),
                              Icon(
                                Icons.contact_page,
                                color: Colors.white,
                              ),
                              SizedBox(
                                width: 20,
                              ),
                              Text(
                                'Contact Us',
                                style: TextStyle(color: Colors.white),
                              ),
                              Expanded(
                                child: Container(),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 40, right: 40),
                      child: ButtonTheme(
                        height: 50,
                        child: RaisedButton(
                          onPressed: () async {
                            return showDialog<void>(
                              context: context,
                              barrierDismissible: true, // user must tap button!
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text('LogOut'),
                                  content: SingleChildScrollView(
                                    child: ListBody(
                                      children: <Widget>[
                                        Text(
                                            'Are you sure you want to log out?'),
                                      ],
                                    ),
                                  ),
                                  actions: <Widget>[
                                    TextButton(
                                      child: Text('Yes'),
                                      onPressed: () async {
                                        await AuthService(uid: user.uid)
                                            .signOut();
                                        Navigator.push(
                                          context,
                                          CupertinoPageRoute(
                                              settings:
                                                  RouteSettings(name: "Foo"),
                                              builder: (context) => LoginUI()),
                                        );
                                      },
                                    ),

                                    TextButton(
                                      child: Text('No'),
                                      onPressed: () async {
                                       Navigator.pop(context);
                                      },
                                    ),
                                  ],
                                );
                              },
                            );
                          },

                          // borderSide: BorderSide(color: Colors.blue),
                          shape: new RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(30.0)),
                          color: Colors.red,
                          // height: 30,
                          // width: 100,
                          child: Row(
                            children: [
                              Expanded(
                                child: Container(),
                              ),
                              Icon(
                                Icons.exit_to_app,
                                color: Colors.white,
                              ),
                              SizedBox(
                                width: 20,
                              ),
                              Text(
                                'Log Out',
                                style: TextStyle(color: Colors.white),
                              ),
                              Expanded(
                                child: Container(),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: CircleAvatar(
              radius: 2,
              backgroundImage: NetworkImage("${widget.u.picture}"),
              backgroundColor: Colors.purple,
            ),
          ),
        );
  }
}