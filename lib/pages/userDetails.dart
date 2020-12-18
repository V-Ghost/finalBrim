import 'package:myapp/Models/users.dart';

import 'package:myapp/pages/signup.dart';
import 'package:myapp/services/auth.dart';

import 'package:myapp/widgets/barIndicator.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class UserDetails extends StatefulWidget {
  PageController controller;

  UserDetails({this.controller});

  _UserDetailsState createState() => _UserDetailsState();
}

class _UserDetailsState extends State<UserDetails> {
  final _formKey = GlobalKey<FormState>();
  String bio = '';
  String interests = '';
  String username = '';
  bool dateSelected = false;
  int age;
  DateTime selectedDate = DateTime.now();
  Users u;
  int progress = 0;
  File _image;
  String dropdownValue;

  Future chooseFile() async {
    await ImagePicker.pickImage(source: ImageSource.gallery).then((image) {
      setState(() {
        _image = image;
      });
    });
  }

  calculateAge(DateTime birthDate) {
    DateTime currentDate = DateTime.now();
    int age = currentDate.year - birthDate.year;
    int month1 = currentDate.month;
    int month2 = birthDate.month;
    if (month2 > month1) {
      age--;
    } else if (month1 == month2) {
      int day1 = currentDate.day;
      int day2 = birthDate.day;
      if (day2 > day1) {
        age--;
      }
    }
    return age;
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(1990, 1),
        lastDate: DateTime.now());
    if (picked != null && picked != selectedDate)
      setState(() {
        dateSelected = true;
        selectedDate = picked;
        age = calculateAge(selectedDate);
      });
  }

  final bioValidator = MultiValidator([
    RequiredValidator(errorText: '????????????'),
    MinLengthValidator(10, errorText: 'Not less than 10 characres'),
  ]);

  @override
  void initState() {
    u = Provider.of<Users>(context, listen: false);
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        progress = 33;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // print(u.userName);

    return Scaffold(
      resizeToAvoidBottomPadding: false,
      // appBar: AppBar(
      //   title: Text("LinkAP"),
      // ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          children: [
            Container(
                width: MediaQuery.of(context).size.width,

                // margin: EdgeInsets.only(top: 10),
                child: SafeArea(child: barIndicator(progress))),
            Center(
              child: Container(
                width: 300,
                // height: MediaQuery.of(context).size.height,
                padding: EdgeInsets.only(top: 40),
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: CircleAvatar(
                        radius: 80,
                        backgroundColor: Colors.white,
                        child: ClipOval(
                          child: new SizedBox(
                              width: 180.0,
                              height: 180.0,
                              child: (_image != null)
                                  ? GestureDetector(
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
                                  GestureDetector(
                                    onTap: chooseFile,
                                      child: Icon(
                                         Icons.camera_alt,
                                        size: 40,
                                        color: Colors.grey,
                                      ),
                                    )),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 25,
                    ),
                    // FlatButton(
                    //   onPressed: chooseFile,
                    //   child: Text('edit pic',
                    //       style:
                    //           TextStyle(color: Theme.of(context).primaryColor)),
                    //   textColor: Theme.of(context).primaryColor,
                    //   shape: RoundedRectangleBorder(
                    //       side: BorderSide(
                    //           color: Theme.of(context).primaryColor,
                    //           width: 2,
                    //           style: BorderStyle.solid),
                    //       borderRadius: BorderRadius.circular(50)),
                    // ),
                    Form(
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            "Linkapp Account details.....",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 32,
                            ),
                          ),
                          SizedBox(
                            height: 50,
                          ),
                          TextFormField(
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'What is your first name?',
                            ),
                            onChanged: (val) => username = val,
                            validator: RequiredValidator(
                                errorText: 'you don' + 't have a first name?'),
                          ),
                          TextFormField(
                            maxLines: 3,
                            // obscureText: true,
                            onChanged: (val) => bio = val,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                                labelText:
                                    'Tell us something about you(your bio)'),
                            validator: bioValidator,
                          ),
                          DropdownButtonFormField(
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                hintStyle: TextStyle(color: Colors.black54),
                                hintText: "Gender",
                              ),
                              isExpanded: true,
                              value: dropdownValue,

                              // icon: Icon(Icons.arrow_downward),
                              // iconSize: 20,
                              onChanged: (String newValue) {
                                setState(() {
                                  dropdownValue = newValue;
                                });
                              },
                              items: <String>[
                                'Male',
                                'Female',
                              ].map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList()),
                          TextFormField(
                            // obscureText: true,
                            onChanged: (val) => interests = val,
                            decoration:
                                InputDecoration(labelText: 'Your interests???'),
                            validator: RequiredValidator(
                                errorText: 'loool you have no interests??'),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              RaisedButton(
                                elevation: 10,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18),
                                ),
                                onPressed: () => _selectDate(context),
                                child: Icon(
                                  Icons.calendar_today,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              if (!dateSelected)
                                Text(
                                  "Select your date of birth",
                                  style: TextStyle(
                                      fontSize: 15, color: Colors.black54),
                                ),
                              if (dateSelected)
                                Text(
                                  "$age year(s) old",
                                  style: TextStyle(
                                      fontSize: 15, color: Colors.black54),
                                ),
                              SizedBox(
                                height: 20.0,
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 40,
                          ),
                          RaisedButton(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18.0),
                              ),
                              child: Text(
                                "Next",
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                              onPressed: () async {
                                // widget.controller.animateToPage(1,
                                //     duration: Duration(milliseconds: 500),
                                //     curve: Curves.ease);
                                // Navigator.push(
                                //   context,
                                //   CupertinoPageRoute(
                                //       builder: (context) => dobSelector()),
                                // );
                                if (_formKey.currentState.validate()) {
                                  if (dropdownValue != null) {
                                    if (_image != null) {
                                      if (age != null) {
                                        if (age < 16) {
                                          return AlertBox(
                                              context, "you are under aged");
                                        } else {
                                          u.gender = dropdownValue;
                                          u.userName = username;
                                          u.bio = bio;
                                          
                                          u.image = _image;
                                          u.dob = selectedDate;

                                          setState(() {
                                            progress = 66;
                                          });
                                          Navigator.push(
                                            context,
                                            CupertinoPageRoute(
                                                builder: (context) => SignUp()),
                                          );
                                          //   // _formKey.currentState.reset();
                                          // setState(() {
                                          //   loading = true;
                                          // });
                                          // dynamic result = await _auth
                                          //     .signInWithPhoneNumber(
                                          //         u, _image);
                                          // // print("here");
                                          // if (result is String) {
                                          //   print("object shit");
                                          //   print(result);
                                          //   setState(() {
                                          //     loading = false;
                                          //   });
                                          //   return AlertBox(
                                          //       context, result);
                                          // } else {
                                          //   print("ahhn");
                                          //   setState(() {
                                          //     loading = false;
                                          //   });

                                        }
                                      } else {
                                        return AlertBox(
                                            context, "Select your age");
                                      }
                                    } else {
                                      return AlertBox(
                                          context, "Select your picture");
                                    }
                                  } else {
                                    return AlertBox(
                                        context, "Select your gender");
                                  }
                                }
                              }

                              //   // _formKey.currentState.reset();

                              ),
                          SizedBox(
                            height: 200,
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void AlertBox(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Sign Up Error'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(message),
              ],
            ),
          ),
          actions: <Widget>[
            GestureDetector(
              child: Text('Close'),
              onTap: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
