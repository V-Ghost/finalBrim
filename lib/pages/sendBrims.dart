import 'package:flutter/cupertino.dart';
import 'package:myapp/Models/brim.dart';
import 'package:myapp/Models/status.dart';
import 'package:myapp/Models/users.dart';
import 'package:myapp/pages/navBarPages/Chats/chat_details.dart';
import 'package:myapp/services/brimService.dart';
import 'package:myapp/services/database.dart';
import 'package:myapp/widgets/loading.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:provider/provider.dart';

class SendBrims extends StatefulWidget {
  final String userId;
  const SendBrims({this.userId});
  @override
  _SendBrimsState createState() => _SendBrimsState();
}

class _SendBrimsState extends State<SendBrims> {
  Users u;
  User user;
  bool loading = false;
  double radius = 0;
  final _formKey = GlobalKey<FormState>();
  String message = "";
  Brim b = new Brim();
  BrimService db;
  @override
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.currentUser;
    u = Provider.of<Users>(context, listen: false);
    db = BrimService(uid: user.uid);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        radius = 22;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? Loading()
        : Scaffold(
            body: Padding(
              padding:
                  const EdgeInsets.only(top: 8, bottom: 8, left: 12, right: 12),
              child: ListView(
                children: [
                  Row(
                    children: [
                      SafeArea(
                        child: GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Text("cancel",
                              style: TextStyle(
                                color: Colors.purple,
                                fontSize: 18,
                              )),
                        ),
                      ),
                      Expanded(
                        child: Container(),
                      ),
                      SafeArea(
                        child: RaisedButton(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                          ),
                          onPressed: () async {
                            if (_formKey.currentState.validate()) {
                              Brim b = new Brim();
                              b.date = DateTime.now().toUtc();
                              b.message = message;
                              b.userId1 = user.uid;
                              b.userId2 = widget.userId;
                              b.sender = user.uid;
                              setState(() {
                                print("here");
                                loading = true;
                              });
                              dynamic result = await db.sendBrim(b);

                              if (result == null) {
                                db.retrieveBrims();
                                setState(() {
                                  print("here");
                                  loading = false;
                                });
                                // _formKey.currentState.reset();
                                Fluttertoast.showToast(
                                    msg: "Shoot Successfully fired",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.CENTER,
                                    timeInSecForIosWeb: 3,
                                    backgroundColor: Colors.blue,
                                    textColor: Colors.white,
                                    fontSize: 16.0);
                             
                                Navigator.push(
                                  context,
                                  CupertinoPageRoute(
                                    builder: (context) => ChatDetails(),
                                  ),
                                );
                              } else if( result is String) {
                                setState(() {
                                  loading = false;
                                });
                                Fluttertoast.showToast(
                                    msg:
                                        "$result",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.CENTER,
                                    timeInSecForIosWeb: 3,
                                    backgroundColor: Colors.red,
                                    textColor: Colors.white,
                                    fontSize: 16.0);
                              }else{
                                 setState(() {
                                  loading = false;
                                });
                                Fluttertoast.showToast(
                                    msg:
                                        " Sorry :( An error occured when sending the brim",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.CENTER,
                                    timeInSecForIosWeb: 3,
                                    backgroundColor: Colors.red,
                                    textColor: Colors.white,
                                    fontSize: 16.0);
                              }
                            }
                          },
                          child: Text(
                            "Brim",
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    width: 50,
                    child: Form(
                      key: _formKey,
                      child: TextFormField(
                        onChanged: (val) => message = val,
                        validator:
                            RequiredValidator(errorText: 'Text Field is empty'),
                        autofocus: true,
                        decoration: new InputDecoration(
                          icon: CircleAvatar(
                            radius: radius,
                            backgroundImage: NetworkImage("${u.picture}"),
                            backgroundColor: Colors.purple,
                          ),
                          labelText: "Shoot your shot.....",
                          enabledBorder: const OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(20.0)),
                            borderSide: const BorderSide(
                              color: Colors.grey,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.0)),
                            borderSide: BorderSide(color: Colors.blue),
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
  }
}
