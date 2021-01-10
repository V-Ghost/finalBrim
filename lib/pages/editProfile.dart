import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:myapp/Models/users.dart';
import 'package:myapp/services/database.dart';
import 'package:myapp/widgets/raisedGradientButton.dart';
import 'package:provider/provider.dart';

class EditProfile extends StatefulWidget {
  EditProfile({Key key}) : super(key: key);

  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final TextEditingController _bioController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  double progress;
  final bioValidator = MultiValidator([
    RequiredValidator(errorText: 'Enter your bio'),
    MaxLengthValidator(70, errorText: 'Not more than 60 characters'),
  ]);
  double opacity = 0;
  Users u;
  User user;
  File _image;
  bool loading = false;
  bool loading1 = false;
  bool showButton = false;
  bool bioLoading = false;
  double buttonOpacity = 0;
  String bio;
  @override
  void initState() {
    u = Provider.of<Users>(context, listen: false);
    user = FirebaseAuth.instance.currentUser;
    print("bio");
    print(u.bio);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        progress = MediaQuery.of(context).size.height * 0.4;
        opacity = 1;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    return Scaffold(
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
                    Text(
                      "Edit Profile",
                      style: TextStyle(
                        letterSpacing: 0.7,
                        color: Colors.grey,
                        fontSize: 32,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    loading1
                        ? CircularProgressIndicator()
                        : Align(
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
                                                  child: Image.network(
                                                    u.picture,
                                                    fit: BoxFit.cover,
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
                      height: 30,
                    ),
                    bioLoading
                        ? CircularProgressIndicator()
                        : Form(
                            key: _formKey,
                            child: Container(
                              margin: EdgeInsets.only(right: 15, left: 15),
                              child: Material(
                                elevation: 20.0,
                                shadowColor: Colors.black,
                                child: TextFormField(
                                  onChanged: (val) {
                                    setState(() {
                                      showButton = true;
                                      buttonOpacity = 1;
                                    });
                                    bio = val;
                                  },
                                  // controller: _bioController,
                                  initialValue: u.bio,
                                  decoration: new InputDecoration(
                                    prefixIcon: Icon(Icons.person),
                                    labelText: "Enter bio here",
                                    enabledBorder: const OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(20.0)),
                                      borderSide: const BorderSide(
                                        color: Colors.white,
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10.0)),
                                      borderSide:
                                          BorderSide(color: Colors.white),
                                    ),
                                  ),
                                  validator: bioValidator,
                                ),
                              ),
                            ),
                          ),
                    SizedBox(
                      height: 40,
                    ),
                    IgnorePointer(
                      ignoring: !showButton,
                      child: AnimatedOpacity(
                        opacity: buttonOpacity,
                        duration: Duration(milliseconds: 1500),
                        child: RaisedGradientButton(
                          width: 200,
                          child: Text(
                            'Save new Bio',
                            style: TextStyle(color: Colors.white),
                          ),
                          gradient: LinearGradient(
                            colors: <Color>[
                              Colors.pink[800],
                              Colors.pinkAccent
                            ],
                          ),
                          onPressed: () async {
                            if (_formKey.currentState.validate()) {
                              u.bio = bio;
                               bioLoading = true;
                              bool done = await DatabaseService(uid: user.uid)
                                  .updateUserData(u);
                                 
                              if (done is String) {
                                setState(() {
                                  bioLoading = false;
                                 
                                });
                                Fluttertoast.showToast(
                                    msg:
                                        "  Sorry :( An error occured uploading bio",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.CENTER,
                                    timeInSecForIosWeb: 3,
                                    backgroundColor: Colors.red,
                                    textColor: Colors.white,
                                    fontSize: 16.0);
                              } else {
                                setState(() {
                                  bioLoading = false;
                                });
                                Fluttertoast.showToast(
                                    msg: "New bio uploaded",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.CENTER,
                                    timeInSecForIosWeb: 3,
                                    backgroundColor: Colors.blue,
                                    textColor: Colors.white,
                                    fontSize: 16.0);
                              }
                            }
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
                right: 143,
                top: 255,
                child: GestureDetector(
                    onTap: chooseFile,
                    child: Icon(
                      Icons.edit,
                      color: Colors.white,
                      size: 37,
                    ))),
          ],
        ),
      ),
    );
  }

  void chooseFile() async {
    await ImagePicker.pickImage(source: ImageSource.gallery).then((image) {
      if (image != null) {
        _image = image;
        setState(() {
          loading = true;
        });
        DatabaseService(uid: user.uid).uploadFile(image).then((result) async {
          if (result is String) {
            u.picture = result;

            bool done = await DatabaseService(uid: user.uid).updateUserData(u);
            if (done is String) {
              setState(() {
                loading = false;
                _image = null;
              });
              Fluttertoast.showToast(
                  msg: "  Sorry :( An error occured uploading picture",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.CENTER,
                  timeInSecForIosWeb: 3,
                  backgroundColor: Colors.red,
                  textColor: Colors.white,
                  fontSize: 16.0);
            } else {
              setState(() {
                loading = false;
              });
              Fluttertoast.showToast(
                  msg: "New profile picture uploaded",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.CENTER,
                  timeInSecForIosWeb: 3,
                  backgroundColor: Colors.blue,
                  textColor: Colors.white,
                  fontSize: 16.0);
            }
            print("result here");
            print(result);
          } else {
            setState(() {
              loading = false;
              _image = null;
            });
            Fluttertoast.showToast(
                msg: " Sorry :( An error occured uploading picture",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.CENTER,
                timeInSecForIosWeb: 3,
                backgroundColor: Colors.red,
                textColor: Colors.white,
                fontSize: 16.0);
            print(result);
          }
        });
      }
    });
  }
}
