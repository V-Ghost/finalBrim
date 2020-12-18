import 'package:myapp/Models/users.dart';
import 'package:myapp/pages/register/userDetails/registration2.dart';
import 'package:myapp/widgets/raisedGradientButton.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

class Registration3 extends StatefulWidget {
  Registration3({Key key}) : super(key: key);

  _Registration3State createState() => _Registration3State();
}

class _Registration3State extends State<Registration3> {
  
  double progress;
   bool dateSelected = false;
  int age;
    Users u;
  DateTime selectedDate = DateTime.now();
  double opacity = 0;
  @override
  void initState() {
     u = Provider.of<Users>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        progress = MediaQuery.of(context).size.height * 0.3;
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
                        "Your Date of Birth",
                        style: TextStyle(
                          letterSpacing: 0.7,
                          color: Colors.grey,
                          fontSize: 32,
                        ),
                      ),
                      SizedBox(
                        height: 40,
                      ),
                       Row(
                            children: [
                              Expanded(
                                child: Container(

                                ),
                              ),
                              RaisedButton(
                                // color: Color.,
                                // color:  #FF7181,
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
                              
                               Expanded(
                                child: Container(
                                  
                                ),
                              ),
                            ],
                          ),
                      Container(
                        margin: EdgeInsets.all(10),
                        child: Text(
                          "your date of birth and age would NOT be made visible to other users",
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
                            
                            if(age == null){
                             return Fluttertoast.showToast(
                                    msg:
                                        " Sorry :( You are have select your age",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.BOTTOM,
                                    timeInSecForIosWeb: 3,
                                    backgroundColor: Colors.black87,
                                    textColor: Colors.white,
                                    fontSize: 16.0);
                            }else{
                              if(age < 16) {
                                 return Fluttertoast.showToast(
                                    msg:
                                        " Sorry :( You are under aged",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.BOTTOM,
                                    timeInSecForIosWeb: 3,
                                    backgroundColor: Colors.red,
                                    textColor: Colors.white,
                                    fontSize: 16.0);
                              }else{
                               u.dob = selectedDate;
                                Navigator.push(
                              context,
                              CupertinoPageRoute(
                                  builder: (context) => Registration2()),
                            );
                              } 
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
}