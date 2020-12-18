import 'package:myapp/Models/users.dart';
import 'package:myapp/pages/register/userDetails/registration3.dart';
import 'package:myapp/widgets/raisedGradientButton.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:provider/provider.dart';

class Registration1 extends StatefulWidget {
  Registration1({Key key}) : super(key: key);

  _Registration1State createState() => _Registration1State();
}

class _Registration1State extends State<Registration1> {
  final TextEditingController _bioController = TextEditingController();
   final _formKey = GlobalKey<FormState>();
  double progress;
  final bioValidator = MultiValidator([
    RequiredValidator(errorText: 'Enter your bio'),
    MaxLengthValidator(70, errorText: 'Not more than 60 characters'),
  ]);
  double opacity = 0;
    Users u;
  @override
  void initState() {
     u = Provider.of<Users>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        progress = MediaQuery.of(context).size.height * 0.2;
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
                opacity: opacity ,
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
                        "Your Bio",
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
                              controller: _bioController,
                              decoration: new InputDecoration(
                                prefixIcon: Icon(Icons.person),
                                labelText: "Enter bio here",
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
                              validator: bioValidator,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.all(10),
                        child: Text(
                          "your bio would be made visible to other users",
                           textAlign: TextAlign.center ,
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
                              u.bio = _bioController.text;
                              Navigator.push(
                              context,
                              CupertinoPageRoute(
                                  builder: (context) => Registration3()),
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
