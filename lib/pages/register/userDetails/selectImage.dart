import 'dart:io';
import 'dart:async';
import 'package:myapp/Models/users.dart';

import 'package:myapp/pages/landingPages/homepage.dart';
import 'package:myapp/pages/register/userDetails/registration3.dart';
import 'package:myapp/services/database.dart';
import 'package:myapp/widgets/raisedGradientButton.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class SelectImage extends StatefulWidget {
  SelectImage({Key key}) : super(key: key);

  _SelectImageState createState() => _SelectImageState();
}

class _SelectImageState extends State<SelectImage> {
  final TextEditingController _bioController = TextEditingController();
  double progress;
  Users u;
  User user;
  File _image;
  bool loading = false;
  bool loading1 = false;
  bool showButton = false;
  double buttonOpacity = 0;
  double opacity = 0;
  @override
  void initState() {
    u = Provider.of<Users>(context, listen: false);
    user = FirebaseAuth.instance.currentUser;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        progress = MediaQuery.of(context).size.height * 0.5;
        opacity = 1;
        print("change init");
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    return Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Stack(
            children: [
              SafeArea(
                child: AnimatedContainer(
                  //     margin: EdgeInsets.only(top:h/15),
                  height: progress == null ? h * 0.1 : progress,
                  width: w,
                  duration: Duration(milliseconds: 1500),
                  child: RotatedBox(
                    quarterTurns: 0,
                    child: FlareActor(
                      'lib/images/curve.flr',
                      animation: 'Flow',
                      alignment: Alignment.bottomCenter,
                      fit: BoxFit.fill,
                      // isPaused: x,
                    ),
                  ),
                ),
              ),
              AnimatedOpacity(
                duration: Duration(milliseconds: 2000),
                opacity: opacity,
                child: Container(
                  margin: EdgeInsets.only(top: 100),
                  child: Column(
                    children: [
                      SizedBox(
                        height: h * 0.07,
                      ),
                        Container(
                        height: 70,
                        width: 50,
                        child: Image(
                            image: AssetImage(
                          'lib/images/brim0.png',
                        )),
                      ),
                      Text(
                        "Select Picture",
                        style: TextStyle(
                          letterSpacing: 0.7,
                          color: Colors.grey,
                          fontSize: 32,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      loading1 ? CircularProgressIndicator(): Align(
                        alignment: Alignment.center,
                        child: loading
                            ? Material(
                                elevation: 20.0,
                                shadowColor: Colors.black,
                                child: Stack(
                                  children: [
                                    CircleAvatar(
                                      radius: 80,
                                      backgroundColor: Colors.grey,
                                      child: ClipOval(
                                        child: new SizedBox(
                                            width: 180.0,
                                            height: 180.0,
                                            child: GestureDetector(
                                              onTap: chooseFile,
                                              child: Image.file(
                                                _image,
                                                fit: BoxFit.cover,
                                              ),
                                            )),
                                      ),
                                    ),
                                    CircleAvatar(
                                      radius: 80,
                                      backgroundColor: Colors.black54,
                                    ),
                                    Positioned(
                                      left: 60,
                                      top: 60,
                                      child: CircularProgressIndicator(),
                                    )
                                  ],
                                ),
                              )
                            : CircleAvatar(
                                radius: 80,
                                backgroundColor: Colors.grey,
                                child: ClipOval(
                                  child: new SizedBox(
                                      width: 180.0,
                                      height: 180.0,
                                      child: (_image != null)
                                          ? InkWell(
                                              onTap: chooseFile,
                                              child: Image.file(
                                                _image,
                                                fit: BoxFit.cover,
                                              ),
                                            )
                                          :
                                          //     Image.network(
                                          //   "https://images.unsplash.com/photo-1502164980785-f8aa41d53611?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=500&q=60",
                                          //   fit: BoxFit.fill,
                                          // ),
                                          InkWell(
                                              onTap: chooseFile,
                                              child: Icon(
                                                Icons.camera_alt,
                                                size: 40,
                                                color: Colors.white,
                                              ),
                                            )),
                                ),
                              ),
                      ),
                      Container(
                        margin: EdgeInsets.all(10),
                        child: Text(
                          "This app prioritises privacy so your picture would only be shown with ypour authorization.",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            letterSpacing: 0.7,
                            color: Colors.grey,
                            fontSize: 15,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 70,
                      ),
                      IgnorePointer(
                        ignoring: !showButton,
                        child: AnimatedOpacity(
                          opacity: buttonOpacity,
                          duration: Duration(milliseconds: 1500),
                          child: RaisedGradientButton(
                              width: 200,
                              child: Text(
                                'Finish',
                                style: TextStyle(color: Colors.white),
                              ),
                              gradient: LinearGradient(
                                colors: <Color>[
                                  Colors.pink[800],
                                  Colors.pinkAccent
                                ],
                              ),
                              onPressed: () async {
                                loading1=true;
                                dynamic result = await DatabaseService(uid: user.uid)
                                    .updateUserData(u);
                               
                               
                                // Future.delayed(
                                //     const Duration(milliseconds: 1000), () {


                                //   setState(() {
                                //       progress =
                                //       MediaQuery.of(context).size.height * 0.1;
                                //   });
                                // });
                                if (result) {
                                 setState(() {
                                   loading1 = false;
                                  progress =
                                     h *1.5;
                                  
                                });
                                  Navigator.push(
                                    context,
                                    CupertinoPageRoute(
                                        builder: (context) => Homepage()),
                                  );
                                } else {
                                  Fluttertoast.showToast(
                                      msg:
                                          " Sorry :( An error occured when registering ",
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.CENTER,
                                      timeInSecForIosWeb: 3,
                                      backgroundColor: Colors.red,
                                      textColor: Colors.white,
                                      fontSize: 16.0);
                                }
                                // Navigator.push(
                                //   context,
                                //   CupertinoPageRoute(
                                //       builder: (context) => Registration3()),
                                // );
                                // if (_formKey.currentState.validate()) {
                                //   u.phoneNumber = _phoneNumberController.text;
                                //   Navigator.push(
                                //     context,
                                //     CupertinoPageRoute(
                                //         builder: (context) => EnterCode()),
                                //   );
                                // }
                              }),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ));
  }

  void chooseFile() async {
    await ImagePicker.pickImage(source: ImageSource.gallery).then((image) {
      if (image != null) {
        _image = image;
        setState(() {
          loading = true;
        });
        DatabaseService(uid: user.uid).uploadFile(image).then((result) {
          if (result is String) {
            u.picture = result;
            setState(() {
              loading = false;
              showButton = true;
              buttonOpacity = 1;
            });

            print(result);
          } else {
            Fluttertoast.showToast(
                msg: " Sorry :( An error occured when registering in",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.CENTER,
                timeInSecForIosWeb: 3,
                backgroundColor: Colors.red,
                textColor: Colors.white,
                fontSize: 16.0);
            print(result);
          }
        });

        // if (result is String) {

        //   setState(() {
        //     loading = false;
        //   });
        //   print(result);
        // } else {
        //   Fluttertoast.showToast(
        //       msg: " Sorry :( An error occured when signing in",
        //       toastLength: Toast.LENGTH_SHORT,
        //       gravity: ToastGravity.CENTER,
        //       timeInSecForIosWeb: 3,
        //       backgroundColor: Colors.red,
        //       textColor: Colors.white,
        //       fontSize: 16.0);
        //       print(result);
        // }
      }
    });
  }
}
