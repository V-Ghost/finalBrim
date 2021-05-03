import 'package:myapp/Models/users.dart';
import 'package:myapp/pages/landingPages/homepage.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:myapp/services/auth.dart';
import 'package:myapp/services/database.dart';
import 'package:myapp/widgets/loading.dart';
import 'package:myapp/widgets/raisedGradientButton.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:provider/provider.dart';
import 'dart:async';
import 'dart:io';

class EnterCode extends StatefulWidget {
  EnterCode({Key key}) : super(key: key);

  _EnterCodeState createState() => _EnterCodeState();
}

class _EnterCodeState extends State<EnterCode> {
  Users u;
  final TextEditingController _smsCodeController = TextEditingController();
  String phoneNumber;
  final _formKey = GlobalKey<FormState>();
  bool loading = false;
  User user;
  String _verificationId = "";
  final FirebaseAuth _auth = FirebaseAuth.instance;
  AuthService _service = new AuthService();
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  StreamSubscription iosSubscription;
  @override
  void initState() {
    u = Provider.of<Users>(context, listen: false);
    user = FirebaseAuth.instance.currentUser;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _verifyPhoneNumber(context);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    return Scaffold(
        body: Stack(
      children: [
        Container(
          //     margin: EdgeInsets.only(top:h/15),
          height: h * 0.7,
          width: w,
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
        Container(
          margin: EdgeInsets.only(
            top: h * 0.14,
          ),
          child: Column(
            children: [
              Center(
                child: Text(
                  "Enter your Code ",
                  style: TextStyle(fontSize: 32, color: Colors.white),
                ),
              ),
              Center(
                child: Text(
                  "${u.phoneNumber} ",
                  style: TextStyle(fontSize: 15, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
        Container(
          margin: EdgeInsets.only(
            top: h * 0.5,
          ),
          child: loading
              ? Center(
                  child: CircularProgressIndicator(
                    backgroundColor: Colors.white,
                  ),
                )
              : ListView(
                  children: [
                    Form(
                      key: _formKey,
                      child: TextFormField(
                        keyboardType: TextInputType.number,
                        controller: _smsCodeController,
                        decoration: new InputDecoration(
                          icon: Icon(Icons.verified_user),
                          labelText: "Your SMS Code",
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
                        validator: RequiredValidator(
                            errorText: 'Your SMS Code pleeaasee?'),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Fluttertoast.showToast(
                            msg: " Code has been resent",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIosWeb: 3,
                            backgroundColor: Colors.blue,
                            textColor: Colors.white,
                            fontSize: 16.0);
                        _verifyPhoneNumber(context);
                      },
                      child: Container(
                        margin: EdgeInsets.only(right: 10, top: 8),
                        alignment: Alignment.centerRight,
                        child: Text(
                          "Resend",
                          style: TextStyle(fontSize: 15, color: Colors.black87),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(35.0),
                      child: RaisedGradientButton(
                          width: 200,
                          child: Text(
                            'Continue',
                            style: TextStyle(color: Colors.white),
                          ),
                          gradient: LinearGradient(
                            colors: <Color>[Colors.purple[800], Colors.purple],
                          ),
                          onPressed: () async {
                            if (_formKey.currentState.validate()) {
                              u.smsCode = _smsCodeController.text;
                              u.verificationId = _verificationId;
                              setState(() {
                                loading = true;
                              });
                              dynamic result =
                                  await _service.loginInWithPhoneNumber(u);
                              if (result is String) {
                                print("object shit");
                                print(result);
                                setState(() {
                                  loading = false;
                                });
                                return Fluttertoast.showToast(
                                    msg:
                                        " Sorry :( An error occured when logging in",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.BOTTOM,
                                    timeInSecForIosWeb: 3,
                                    backgroundColor: Colors.red,
                                    textColor: Colors.white,
                                    fontSize: 16.0);
                              } else {
                                 user = FirebaseAuth.instance.currentUser;
                                print("ahhn");
                                if (Platform.isIOS) {
                                  iosSubscription = _firebaseMessaging
                                      .onIosSettingsRegistered
                                      .listen((data) {
                                    DatabaseService(uid: user.uid)
                                        .saveDeviceToken();
                                  });

                                  _firebaseMessaging
                                      .requestNotificationPermissions(
                                          const IosNotificationSettings(
                                              sound: true,
                                              badge: true,
                                              alert: true));
                                } else {
                                  //print("hii ios");
                                  DatabaseService(uid: user.uid)
                                      .saveDeviceToken();
                                }
                                setState(() {
                                  loading = false;
                                });
                                Navigator.push(
                                  context,
                                  CupertinoPageRoute(
                                      builder: (context) => Homepage()),
                                );
                              }
                              // Navigator.push(
                              //   context,
                              //   CupertinoPageRoute(builder: (context) => EnterCode()),
                              // );
                            }
                          }),
                    ),
                  ],
                ),
        )
      ],
    ));
  }

  Future<void> _verifyPhoneNumber(BuildContext context) async {
    PhoneVerificationCompleted verificationCompleted =
        (PhoneAuthCredential phoneAuthCredential) async {
      await _auth.signInWithCredential(phoneAuthCredential);
      Fluttertoast.showToast(
          msg:
              "Phone number automatically verified and user signed in: ${phoneAuthCredential}",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 3,
          backgroundColor: Colors.blue,
          textColor: Colors.white,
          fontSize: 16.0);
      Navigator.push(
        context,
        CupertinoPageRoute(builder: (context) => Homepage()),
      );
    };

    PhoneVerificationFailed verificationFailed =
        (FirebaseAuthException authException) {
      Fluttertoast.showToast(
          msg:
              "'Phone number verification failed. Code: ${authException.code}. Message: ${authException.message}",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 3,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    };

    PhoneCodeSent codeSent =
        (String verificationId, [int forceResendingToken]) async {
      Fluttertoast.showToast(
          msg: "Please check your phone for the verification code.",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 3,
          backgroundColor: Colors.purple,
          textColor: Colors.white,
          fontSize: 16.0);

      _verificationId = verificationId;
    };

    PhoneCodeAutoRetrievalTimeout codeAutoRetrievalTimeout =
        (String verificationId) {
      // Fluttertoast.showToast(
      //     msg: "codeAutoRetrievalTimeout",
      //     toastLength: Toast.LENGTH_SHORT,
      //     gravity: ToastGravity.BOTTOM,
      //     timeInSecForIosWeb: 3,
      //     backgroundColor: Colors.red,
      //     textColor: Colors.white,
      //     fontSize: 16.0);
      _verificationId = verificationId;
    };

    try {
      await _auth.verifyPhoneNumber(
          phoneNumber: u.phoneNumber,
          timeout: const Duration(seconds: 5),
          verificationCompleted: verificationCompleted,
          verificationFailed: verificationFailed,
          codeSent: codeSent,
          codeAutoRetrievalTimeout: codeAutoRetrievalTimeout);
    } catch (e) {
      Fluttertoast.showToast(
          msg: "Failed to Verify Phone Number: $e",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 3,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
      // _scaffoldKey.currentState.showSnackBar(SnackBar(
      //   content: Text("Failed to Verify Phone Number: $e"),
      // ));
    }
  }
}
