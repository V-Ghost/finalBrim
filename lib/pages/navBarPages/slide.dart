import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:geolocator/geolocator.dart';
import 'package:keyboard_attachable/keyboard_attachable.dart';
import 'package:myapp/Models/brim.dart';
import 'package:myapp/Models/broadcastMessage.dart';
import 'package:myapp/Models/users.dart';
import 'package:myapp/pages/navBarPages/Broadcast/broadcastComment.dart';
import 'package:myapp/pages/navBarPages/Chats/chat_details.dart';
import 'package:myapp/pages/navBarPages/Chats/chat_details_brim.dart';
import 'package:myapp/pages/sendBrims.dart';
import 'package:myapp/services/brimService.dart';
import 'package:myapp/services/database.dart';
import 'package:myapp/widgets/raisedGradientButton.dart';
import 'package:provider/provider.dart';

class Slide extends StatefulWidget {
  Slide({Key key}) : super(key: key);

  _SlideState createState() => _SlideState();
}

class _SlideState extends State<Slide> {
  double height;
  Widget theIndex;
  double width;
  bool comment = false;
  List<BroadCastMessage> broadcasts = [];
  List<Widget> w = [];
  List<Users> uList = [];
  List<Color> color = [
    Colors.blue,
    Colors.amber,
    Colors.pink,
    Colors.purple,
    Colors.green,
    Colors.red,
    Colors.yellow
  ];
  User user;
  int selectedItem = 0;
  Users u;
  @override
  void initState() {
    u = Provider.of<Users>(context, listen: false);
    user = FirebaseAuth.instance.currentUser;
    // BrimService().getBroadcasts().then((onValue){
    //  onValue.forEach((f){
    //   print(f.message);
    //  });
    // });
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              CupertinoPageRoute(
                builder: (context) => SendBrims(
                  broadcast: true,
                  userId: u.uid,
                ),
              ),
            );
          },
          child: Icon(Icons.remove_red_eye),
          backgroundColor: Colors.purple,
        ),
        body: SafeArea(
          child: FutureBuilder(
              future: getBroadcast(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return RefreshIndicator(
                    onRefresh: () {
                      w = [];
                      setState(() {});
                      return null;
                    },
                    child: ListView(
                        physics: AlwaysScrollableScrollPhysics(),
                        //physics: BouncingScrollPhysics(),
                        children: w.length == 0
                            ? ListTile(
                                title: Text("No Broadcasts"),
                              )
                            : w),
                  );
                }
                if (snapshot.hasError) {
                  return Center(
                    child: Icon(Icons.error),
                  );
                }
                // if(snapshot.connectionState == ConnectionState.waiting){
                //      CircularProgressIndicator();
                // }

                return Center(child: CircularProgressIndicator());
              }),
        ));
  }

  Future<void> getBroadcast() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    broadcasts = await BrimService().getBroadcasts();
    int i = 0;
    broadcasts.forEach((b) async {
      i++;
      Color f = color[i%color.length]; 
      // await BrimService().retrieveUserInfo(b.user);
      // print(position.latitude);
      // print(b.latitiude);
      // double distanceInMeters = Geolocator.distanceBetween(
      //     position.latitude, position.longitude, b.latitiude, b.longitude);
      Widget x = Padding(
        padding: EdgeInsets.only(top: 20, bottom: 20),
        child: Container(

            height: height * 0.4,
            width: width,
            decoration: BoxDecoration(color: f, boxShadow: [
              BoxShadow(
                color: Colors.black38,
                offset: Offset(-1, 1),
                blurRadius: 10,
              )
            ]),
            child: FutureBuilder<Users>(
                future: BrimService().retrieveUserInfo(b.user),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    uList.add(snapshot.data);
                    double distanceInMeters = Geolocator.distanceBetween(
                        position.latitude,
                        position.longitude,
                        b.latitiude,
                        b.longitude) * 0.001;
                        print("this is the distance");
                        print(distanceInMeters);
                    return Column(
                      children: [
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(30, 10, 0, 10),
                              child: Container(
                                height: 70,
                                width: 50,
                                child: Image(
                                    image: AssetImage(
                                  'lib/images/brim0.png',
                                )),
                              ),
                            ),
                            Expanded(
                              child: Container(),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 10, 30, 10),
                              child: Column(
                                children: [
                                  Text(
                                    "Bio : ${snapshot.data.bio}",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    "${distanceInMeters.toStringAsFixed(1)} km from You",
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.all(15),
                          child: Text(
                            "${b.message}",
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                        Expanded(
                          child: Container(),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ConstrainedBox(
                            constraints: BoxConstraints(
                              minHeight: 20,
                              maxHeight: 50,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: RaisedGradientButton(
                                  width: 150,
                                  child: Text(
                                    'Send Comment',
                                    style: TextStyle(color:  f == Colors.blue? Colors.blue:Colors.white),
                                  ),
                                  gradient: f == Colors.blue?LinearGradient(
                                    colors: <Color>[
                                      Colors.white,
                                      Colors.white
                                    ]) : LinearGradient(
                                    colors: <Color>[
                                      Colors.blueAccent,
                                      Colors.blue
                                    ],
                                  ),
                                  onPressed: () async {
                                    //print("pressed");
                                    // u.currentUser = await DatabaseService()
                                    //     .getUserInfo(b.user);

                                    _modalBottomSheetMenu(b.user, b.message);
                                    // Navigator.push(
                                    //   context,
                                    //   CupertinoPageRoute(
                                    //       builder: (context) =>
                                    //           BroadcastComment(
                                    //             userId: b.user,
                                    //             broadcast: b.message,
                                    //           )),
                                    // );
                                  }),
                            ),
                          ),
                        )
                      ],
                    );
                  }
                  if (snapshot.hasError) {
                    return Center(
                      child: Text(snapshot.error.toString()),
                    );
                  }
                  // if(snapshot.connectionState == ConnectionState.waiting){
                  //      CircularProgressIndicator();
                  // }

                  return Center(child: CircularProgressIndicator());
                })),
      );
      theIndex = x;
      w.add(x);
    });

    return broadcasts;
  }

  void _modalBottomSheetMenu(String userId, String broadcast) {
    bool loading = false;
    double radius = 0;
    final _formKey = GlobalKey<FormState>();
    //String message = "";
    Brim b = new Brim();
    BrimService db = BrimService();
    final TextEditingController _textController = TextEditingController();
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
        ),
        builder: (builder) {
          return loading
              ? CircularProgressIndicator()
              : Container(
                  height: MediaQuery.of(context).size.height * 0.75,
                  child: Padding(
                    padding: const EdgeInsets.only(
                        top: 8, bottom: 8, left: 12, right: 12),
                    child: ListView(
                      children: [
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Text(
                              "Add a comment",
                              style: TextStyle(
                                letterSpacing: 0.7,
                                color: Colors.black,
                                fontSize: 28,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 40,
                        ),
                        Container(
                          width: 50,
                          child: Form(
                            key: _formKey,
                            child: TextFormField(
                              controller: _textController,
                              validator: RequiredValidator(
                                  errorText: 'Text Field is empty'),
                              autofocus: true,
                              decoration: new InputDecoration(
                                icon: CircleAvatar(
                                  radius: radius,
                                  backgroundImage: NetworkImage("${u.picture}"),
                                  backgroundColor: Colors.purple,
                                ),
                                labelText: "What's on your mind?",
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
                        ),
                        Text(
                          "your comment would be sent as a brim",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            letterSpacing: 0.7,
                            color: Colors.grey,
                            fontSize: 10,
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        ButtonTheme(
                          minWidth: 80.0,
                          height: 60,
                          child: RaisedButton(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0),
                            ),
                            onPressed: () async {
                              if (_formKey.currentState.validate()) {
                                 _formKey.currentState.reset();
                                 Navigator.of(context).pop();
                                Brim b = new Brim();
                                b.date = DateTime.now().toUtc();
                                b.message = _textController.text;
                                b.userId1 = user.uid;
                                b.userId2 = userId;
                                b.sender = user.uid;
                                b.broadcast = broadcast;
                                u.currentUser =
                                    await DatabaseService().getUserInfo(userId);
                                // setState(() {
                                //   print("here");
                                //   loading = true;
                                // });
                                dynamic result = await db.sendComment(b);
                                String type = "brim";
                                await DatabaseService().sendNotification(
                                    u.userName, userId, b.message, "brim");

                                
                                if (result is String) {
                                  print("first errror");
                                  Fluttertoast.showToast(
                                      msg: "$result",
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.CENTER,
                                      timeInSecForIosWeb: 3,
                                      backgroundColor: Colors.red,
                                      textColor: Colors.white,
                                      fontSize: 16.0);
                                  // db.retrieveBrims();
                                  // setState(() {
                                  //   print("here");
                                  //   loading = false;
                                  // });
                                  // _formKey.currentState.reset();

                                } else {
                                  Fluttertoast.showToast(
                                      msg: "Comment Successfully Sent",
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.CENTER,
                                      timeInSecForIosWeb: 3,
                                      backgroundColor: Colors.blue,
                                      textColor: Colors.white,
                                      fontSize: 16.0);
                                  var messageId = b.userId1 + b.userId2;
                                  try {
                                    u.currentUser = await DatabaseService()
                                        .getUserInfo(b.userId2);
                                    var unique = b.userId1 + b.userId2;
                                    var check = await DatabaseService()
                                        .doeschatExistAlready(unique);
                                    if (check == true) {
                                      Navigator.push(
                                        context,
                                        CupertinoPageRoute(
                                          builder: (context) => ChatDetails(
                                            receipent: u.currentUser,
                                            messageId: messageId,
                                            isParticipant1: true,
                                          ),
                                        ),
                                      );
                                    } else {
                                      Navigator.push(
                                        context,
                                        CupertinoPageRoute(
                                          builder: (context) => ChatDetailsBrim(
                                            receipent: u.currentUser,
                                            messageId: messageId,
                                            isParticipant1: true,
                                          ),
                                        ),
                                      );
                                    }
                                  } catch (error) {
                                    print("second errror");
                                    Fluttertoast.showToast(
                                        msg: error.toString(),
                                        toastLength: Toast.LENGTH_SHORT,
                                        gravity: ToastGravity.CENTER,
                                        timeInSecForIosWeb: 3,
                                        backgroundColor: Colors.red,
                                        textColor: Colors.white,
                                        fontSize: 16.0);
                                  }
                                  // setState(() {
                                  //   loading = false;
                                  // });

                                }
                                //  else {
                                //   setState(() {
                                //     loading = false;
                                //   });
                                //   Fluttertoast.showToast(
                                //       msg:
                                //           " Sorry :( An error occured when sending your brim",
                                //       toastLength: Toast.LENGTH_SHORT,
                                //       gravity: ToastGravity.CENTER,
                                //       timeInSecForIosWeb: 3,
                                //       backgroundColor: Colors.red,
                                //       textColor: Colors.white,
                                //       fontSize: 16.0);
                                // }
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
                  ),
                );
        });
  }
}
