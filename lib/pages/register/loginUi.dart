import 'package:country_code_picker/country_code_picker.dart';
import 'package:myapp/Models/users.dart';
import 'package:myapp/pages/register/userDetails/enterCode.dart';

import 'package:myapp/widgets/raisedGradientButton.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/services.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:provider/provider.dart';

class LoginUI extends StatefulWidget {
  @override
  _LoginUIState createState() => _LoginUIState();
}

class _LoginUIState extends State<LoginUI> with TickerProviderStateMixin {
  final TextEditingController _phoneNumberController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  Users u;
  String countryCode = "+233";
  @override
  void initState() {
    u = Provider.of<Users>(context, listen: false);
    print("open ui");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;

    return Scaffold(
      resizeToAvoidBottomPadding: true,
      body: WillPopScope(
        onWillPop: () async {
          await SystemNavigator.pop();
        },
        child: Stack(
          children: <Widget>[
            SafeArea(
              child: Container(
                //     margin: EdgeInsets.only(top:h/15),
                height: h / 1.2,
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
            ),
            Container(
              margin: EdgeInsets.only(top: w / 3.5),
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Center(
                      // padding: const EdgeInsets.only(left:110),
                      child: Container(
                        height: 70,
                        width: 50,
                        child: Image(
                            image: AssetImage(
                          'lib/images/brim0.png',
                        )),
                      ),
                    ),
                    Center(
                      child: Container(
                        margin: EdgeInsets.only(top: 10),
                        child: Text(
                          "Welcome to Brim",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 32,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: h / 2),
              child: ListView(
                children: [
                  Row(
                    children: [
                      Container(
                        child: CountryCodePicker(
                            onChanged:(code){
                              setState(() {
                              countryCode = code.dialCode;
                              });
                            },
                            // Initial selection and favorite can be one of code ('IT') OR dial_code('+39')
                            initialSelection: 'GH',
                            favorite: ['+234', 'NG'],
                            // optional. Shows only country name and flag
                            showCountryOnly: false,
                            // optional. Shows only country name and flag when popup is closed.
                            showOnlyCountryWhenClosed: false,
                            // optional. aligns the flag and the Text left
                            alignLeft: false,
                            // onInit: (code){
                            //   setState(() {
                            //   countryCode = code.dialCode;
                            //   print("done");
                            //   print(code.dialCode);
                            //   });
                            // }
                            ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8, right: 20),
                          child: Form(
                            key: _formKey,
                            child: TextFormField(
                              controller: _phoneNumberController,
                              decoration: new InputDecoration(
                                // icon: Icon(Icons.phone),
                                labelText: "PhoneNumber ",
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.blue),
                                ),
                                // enabledBorder: const OutlineInputBorder(
                                //   borderRadius:
                                //       BorderRadius.all(Radius.circular(20.0)),
                                //   borderSide: const BorderSide(
                                //     color: Colors.grey,
                                //   ),
                                // ),
                                // focusedBorder: OutlineInputBorder(
                                //   // borderRadius:
                                //   //     BorderRadius.all(Radius.circular(10.0)),
                                //   // borderSide: BorderSide(color: Colors.blue),
                                // ),
                              ),
                              validator: RequiredValidator(
                                  errorText: 'Your phone number pleeaasee?'),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Center(
                    child: Text(
                      "We will send you a text with a verification code",
                      style: TextStyle(
                          fontWeight: FontWeight.w300, color: Colors.grey),
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
                        onPressed: () {
                          if (_formKey.currentState.validate()) {
                            u.phoneNumber = countryCode + _phoneNumberController.text;
                            // print(countryCode);
                            // print(u.phoneNumber);
                            Navigator.push(
                              context,
                              CupertinoPageRoute(
                                  builder: (context) => EnterCode()),
                            );
                          }
                        }),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
