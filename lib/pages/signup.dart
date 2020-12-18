import 'package:myapp/Models/users.dart';
import 'package:myapp/pages/landingPages/homepage.dart';

import 'package:myapp/services/auth.dart';
import 'package:myapp/services/database.dart';
import 'package:myapp/widgets/barIndicator.dart';
import 'package:myapp/widgets/loading.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

import 'package:provider/provider.dart';

class SignUp extends StatefulWidget {
  SignUp();

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _formKey = GlobalKey<FormState>();

  String smsCode = '';
  String phoneNumber = '';
  bool verify = false;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  AuthService _service = new AuthService();
  int progress = 33;
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _smsController = TextEditingController();
  bool loading = false;

  String _message = '';
  String _verificationId;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  Users u;
  final passwordValidator = MultiValidator([
    RequiredValidator(errorText: 'password is required'),
    MinLengthValidator(8, errorText: 'password must be at least 8 digits long'),
    PatternValidator(r'(?=.*?[#?!@$%^&*-])',
        errorText: 'passwords must have at least one special character')
  ]);

  @override
  void initState() {
    u = Provider.of<Users>(context, listen: false);

    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        progress = 66;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // setState(() {
    //   progress = 33;
    // });
    if (kIsWeb) {
      return Card(
        child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(bottom: 16),
                  child: const Text('Test sign in with phone number',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  alignment: Alignment.center,
                ),
                Text(
                    "Sign In with Phone Number on Web is currently unsupported")
              ],
            )),
      );
    }
    return loading
        ? Loading()
        : Scaffold(
            key: _scaffoldKey,
            resizeToAvoidBottomPadding: false,
            // appBar: AppBar(
            //   title: Text("SignUp"),
            // ),
            body: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Column(
                children: [
                  Container(
                      width: MediaQuery.of(context).size.width,
                      child: SafeArea(child: barIndicator(progress))),
                  Center(
                    child: Container(
                      width: 300,
                      height: MediaQuery.of(context).size.height,
                      padding: EdgeInsets.only(top: 40),
                      child: Column(
                        children: [
                          Form(
                            key: _formKey,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  "Sign Up",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 32,
                                  ),
                                ),
                                SizedBox(
                                  height: 50,
                                ),
                                TextFormField(
                                  controller: _phoneNumberController,
                                  decoration: InputDecoration(
                                    labelText: 'Phone number (+xxx xxxxxxxx)',
                                  ),
                                  onChanged: (val) => phoneNumber = val,
                                  validator: RequiredValidator(
                                      errorText:
                                          'Your phone number pleeaasee?'),
                                ),
                                Visibility(
                                  visible: verify,
                                  child: TextFormField(
                                    // obscureText: true,
                                    controller: _smsController,
                                    onChanged: (val) => smsCode = val,
                                    decoration: InputDecoration(
                                        labelText: 'Verification code'),
                                    validator: RequiredValidator(
                                        errorText:
                                            'Verifiction code pleeaasee?'),
                                  ),
                                ),
                                SizedBox(
                                  height: 25,
                                ),
                                SignInButtonBuilder(
                                  icon: Icons.contact_phone,
                                  backgroundColor:
                                      Theme.of(context).primaryColor,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18.0),
                                  ),
                                  text: "Verify Number",
                                  onPressed: () async {
                                    if (_formKey.currentState.validate()) {
                                      _verifyPhoneNumber(context);
                                    }
                                  },
                                ),

                                // TextFormField(
                                //   // obscureText: true,
                                //   onChanged: (val) => password2 = val,
                                //   decoration: InputDecoration(
                                //       labelText: 'Can you please Confirm Password?'),
                                //   validator: (val) => MatchValidator(
                                //           errorText:
                                //               'You want to use two different passwords?')
                                //       .validateMatch(password, password2),
                                // ),
                                SizedBox(
                                  height: 40,
                                ),
                                RaisedButton(

                                    // color: Theme.of(context).primaryColor,
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
                                      // _signInWithPhoneNumber();
                                      // _auth.signOut();
                                      if (_formKey.currentState.validate()) {
                                        u.smsCode = _smsController.text;

                                        u.verificationId = _verificationId;
                                        setState(() {
                                          print("here");
                                          loading = true;
                                        });

                                        dynamic result = await _service
                                            .signInWithPhoneNumber(u);

                                        // DatabaseService().uploadFile(u.image);
                                        // DatabaseService().updateUserData(u);
                                        // print("here");
                                        if (result is String) {
                                          print("object shit");
                                          print(result);
                                          setState(() {
                                            loading = false;
                                          });
                                          Fluttertoast.showToast(
                                              msg:
                                                  " Sorry :( An error occured when signing in",
                                              toastLength: Toast.LENGTH_SHORT,
                                              gravity: ToastGravity.CENTER,
                                              timeInSecForIosWeb: 3,
                                              backgroundColor: Colors.red,
                                              textColor: Colors.white,
                                              fontSize: 16.0);
                                        } else {
                                          print("ahhn");
                                          setState(() {
                                            loading = false;
                                          });
                                          Navigator.push(
                                            context,
                                            CupertinoPageRoute(
                                                builder: (context) =>
                                                    Homepage()),
                                          );
                                        }
                                        //   setState(() {
                                        //   progress = 66;
                                        // });
                                        // Navigator.push(
                                        //   context,
                                        //   CupertinoPageRoute(
                                        //       builder: (context) => UserDetails()),
                                        // );

                                      }
                                    }),
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

  void _verifyPhoneNumber(BuildContext context) async {
    setState(() {
      _message = '';
    });

    PhoneVerificationCompleted verificationCompleted =
        (PhoneAuthCredential phoneAuthCredential) async {
      await _auth.signInWithCredential(phoneAuthCredential);
      dynamic fileUrl = await DatabaseService().uploadFile(u.image);
      if (fileUrl is String) {
        u.picture = fileUrl;
        u.picture = fileUrl;
        DatabaseService(uid: FirebaseAuth.instance.currentUser.uid)
            .updateUserData(u);
        Fluttertoast.showToast(
            msg:
                "Phone number automatically verified and user signed in: ${phoneAuthCredential}",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 3,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
        Navigator.push(
          context,
          CupertinoPageRoute(builder: (context) => Homepage()),
        );
      } else {
        Fluttertoast.showToast(
            msg: "Error in signing in",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 3,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
      }

      // _scaffoldKey.currentState.showSnackBar(SnackBar(
      //   content: Text(
      //       "Phone number automatically verified and user signed in: ${phoneAuthCredential}"),
      // ));
    };

    PhoneVerificationFailed verificationFailed =
        (FirebaseAuthException authException) {
      Fluttertoast.showToast(
          msg:
              "'Phone number verification failed. Code: ${authException.code}. Message: ${authException.message}",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 3,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
      // setState(() {
      //   _message =
      //       'Phone number verification failed. Code: ${authException.code}. Message: ${authException.message}';
      // });
    };

    PhoneCodeSent codeSent =
        (String verificationId, [int forceResendingToken]) async {
      setState(() {
        verify = true;
      });
      Fluttertoast.showToast(
          msg: "Please check your phone for the verification code.",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 3,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
      // _scaffoldKey.currentState.showSnackBar(const SnackBar(
      //   content: Text('Please check your phone for the verification code.'),
      // ));
      _verificationId = verificationId;
    };

    PhoneCodeAutoRetrievalTimeout codeAutoRetrievalTimeout =
        (String verificationId) {
      Fluttertoast.showToast(
          msg: "codeAutoRetrievalTimeout",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 3,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
      _verificationId = verificationId;
    };

    try {
      await _auth.verifyPhoneNumber(
          phoneNumber: _phoneNumberController.text,
          timeout: const Duration(seconds: 5),
          verificationCompleted: verificationCompleted,
          verificationFailed: verificationFailed,
          codeSent: codeSent,
          codeAutoRetrievalTimeout: codeAutoRetrievalTimeout);
    } catch (e) {
      Fluttertoast.showToast(
          msg: "Failed to Verify Phone Number: $e",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 3,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
      // _scaffoldKey.currentState.showSnackBar(SnackBar(
      //   content: Text("Failed to Verify Phone Number: $e"),
      // ));
    }
  }

  Widget AlertBox(BuildContext context, String message) {
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
  // void _signInWithPhoneNumber() async {
  //   try {
  //     final AuthCredential credential = PhoneAuthProvider.credential(
  //       verificationId: _verificationId,
  //       smsCode: _smsController.text,
  //     );
  //     final User user = (await _auth.signInWithCredential(credential)).user;

  //   } catch (e) {
  //     print(e);

  //   }
  // }
}
