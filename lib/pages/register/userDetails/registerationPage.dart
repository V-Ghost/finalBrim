import 'package:myapp/Models/users.dart';
import 'package:myapp/pages/register/userDetails/registration1.dart';
import 'package:myapp/widgets/raisedGradientButton.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:provider/provider.dart';

class RegisterationPage extends StatefulWidget {
  RegisterationPage({Key key}) : super(key: key);

  _RegisterationPageState createState() => _RegisterationPageState();
}

class _RegisterationPageState extends State<RegisterationPage> {
  final TextEditingController _fNameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  double progress;
  double opacity = 0;
  Users u;
  @override
  void initState() {
    u = Provider.of<Users>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        progress = MediaQuery.of(context).size.height * 0.1;
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
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Stack(
            children: [
              SafeArea(
                child: AnimatedContainer(
                  //     margin: EdgeInsets.only(top:h/15),
                  height: progress == null ? 0 : progress,
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
                        height: h * 0.09,
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
                        "What is your first name?",
                        style: TextStyle(
                          letterSpacing: 0.7,
                          color: Colors.grey,
                          fontSize: 32,
                        ),
                      ),
                      SizedBox(
                        height: 40,
                      ),
                      Form(
                        key: _formKey,
                        child: Container(
                          margin: EdgeInsets.only(right: 15, left: 15),
                          child: Material(
                            elevation: 20.0,
                            shadowColor: Colors.black,
                            child: TextFormField(
                              keyboardType: TextInputType.multiline,
                              maxLines: null,
                              textInputAction: TextInputAction.newline,
                              controller: _fNameController,
                              decoration: new InputDecoration(
                                prefixIcon: Icon(Icons.person),
                                labelText: "eg. Bryan",
                                enabledBorder: const OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20.0)),
                                  borderSide: const BorderSide(
                                    color: Colors.white,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10.0)),
                                  borderSide: BorderSide(color: Colors.white),
                                ),
                              ),
                              validator: RequiredValidator(
                                  errorText: 'Your name pleeaasee?'),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.all(10),
                        child: Column(
                          children: [
                            Text(
                              "your first Name would be made visible to other users",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                letterSpacing: 0.7,
                                color: Colors.grey,
                                fontSize: 15,
                              ),
                            ),
                            Text(
                              "You won't be able to change your name after registration",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                letterSpacing: 0.7,
                                color: Colors.grey,
                                fontSize: 15,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 70,
                      ),
                      RaisedGradientButton(
                          width: 200,
                          child: Text(
                            'Next',
                            style: TextStyle(color: Colors.white),
                          ),
                          gradient: LinearGradient(
                            colors: <Color>[Colors.purple[800], Colors.purple],
                          ),
                          onPressed: () {
                            if (_formKey.currentState.validate()) {
                              u.userName = _fNameController.text;
                              Navigator.push(
                                context,
                                CupertinoPageRoute(
                                    builder: (context) => Registration1()),
                              );
                            }
                          }),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
