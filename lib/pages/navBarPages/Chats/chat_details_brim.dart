import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';

import 'package:myapp/Models/message.dart';
import 'package:myapp/Models/users.dart';
import 'package:myapp/services/chatService.dart';
import 'package:provider/provider.dart';

class ChatDetailsBrim extends StatefulWidget {
  final String messageId;
  final bool isParticipant1;
  ChatDetailsBrim({this.messageId, this.isParticipant1});
  @override
  _ChatDetailsBrimState createState() => _ChatDetailsBrimState();
}

class _ChatDetailsBrimState extends State<ChatDetailsBrim> {
  Users u;
  User user;
  bool isMe;
  bool isImage;
  double h;
  // String messageId = widget.messageId;
  final TextEditingController _textController = TextEditingController();
  ScrollController _scrollController = new ScrollController();
  final _formKey = GlobalKey<FormState>();
  var keyboardVisibilityController;
  @override
  void initState() {
    h = 540;
    u = Provider.of<Users>(context, listen: false);
    Timer(
        Duration(milliseconds: 500),
        () => _scrollController
            .jumpTo(_scrollController.position.maxScrollExtent));
    user = FirebaseAuth.instance.currentUser;
    keyboardVisibilityController = KeyboardVisibilityController();
    detectKeyBoard();

    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //  scrollToBottom();
    //  print("finish");
    // });
    // print(u.currentUser.userName);
    // TODO: implement initState
    super.initState();
  }

  void detectKeyBoard() {
    keyboardVisibilityController.onChange.listen((bool visible) {
      print('Keyboard visibility update. Is visible: ${visible}');
      Timer(
          Duration(milliseconds: 500),
          () => _scrollController
              .jumpTo(_scrollController.position.maxScrollExtent));
      setState(() {});
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  // void scrollToBottom() {
  //  _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
  // }

  void chooseFile() async {
    await ImagePicker.pickImage(source: ImageSource.gallery)
        .then((image) async {
      if (image != null) {
        Message m = new Message();
        m.image = image;
        m.message = _textController.text;
        m.from = user.uid;
        m.read = false;
        m.date = DateTime.now().toUtc();
        var result = await ChatService().sendChatsText(m, widget.messageId);
        if (result is String) {
          Fluttertoast.showToast(
              msg: "Unable to send message",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 3,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 16.0);
        } else {
          _formKey.currentState.reset();
        }

        setState(() {
          // loading = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.4,
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,
        title: Row(
          children: <Widget>[
            Container(
              width: 40,
              height: 40,
              margin: EdgeInsets.fromLTRB(0, 5, 10, 0),
              child: CircleAvatar(
                backgroundImage: NetworkImage('${u.currentUser.picture}'),
                backgroundColor: Colors.grey[200],
                minRadius: 30,
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(10, 0, 0, 0),
              child: Text(
                '${u.currentUser.userName}',
                style: TextStyle(color: Colors.black),
              ),
            ),
            Expanded(child: Container()),
            InkWell(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    // return object of type Dialog
                    return AlertDialog(
                      title: new Text("Add This User"),
                      content: new Text(
                          "This user would be able to see your profile picture"),
                      actions: <Widget>[
                        new InkWell(
                          child: new Text("Add User"),
                          onTap: () async {
                            var result = await ChatService().permit(
                                widget.messageId, widget.isParticipant1);
                            
                            if (result == true) {
                              print("eii pemit");
                             var permit =  await ChatService().checkPermit(widget.messageId);

                               if(permit == true){
                                  print("yesss");
                               }else{
                                   Navigator.of(context).pop();
                               }
                              //  Navigator.of(context).pop();
                            } else if (result is String) {
                              Fluttertoast.showToast(
                                  msg: "Unable to add user",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.BOTTOM,
                                  timeInSecForIosWeb: 3,
                                  backgroundColor: Colors.red,
                                  textColor: Colors.white,
                                  fontSize: 16.0);
                                   Navigator.of(context).pop();
                            }
                         
                           
                            // print(permit);
                            
                            //  if(permit==true){
                            //    print("ookkkaayay");
                            //  }else{
                            //       print(" not  ookkkaayay");
                            //  }
                           
                          },
                        ),
                        // usually buttons at the bottom of the dialog
                        new FlatButton(
                          child: new Text("Close"),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    );
                  },
                );
              },
              child: Container(
                margin: EdgeInsets.fromLTRB(0, 0, 15, 0),
                child: Icon(
                  CupertinoIcons.lock,
                  color: Colors.grey,
                  semanticLabel: 'Add user',
                ),
              ),
            )
          ],
        ),
      ),
      body: Stack(
        children: <Widget>[
          Container(
            color: Colors.white,
            // height: 540,
            margin: EdgeInsets.fromLTRB(0, 0, 0, 60),
            child: StreamBuilder<QuerySnapshot>(
                stream: ChatService().getYourChats(widget.messageId),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                      physics: BouncingScrollPhysics(),
                      controller: _scrollController,
                      shrinkWrap: true,
                      itemCount: snapshot.data.docs.length,
                      itemBuilder: (BuildContext context, int index) {
                        if (snapshot.data.docs[index].data()["type"] ==
                            "image") {
                          isImage = true;
                        }
                        if (snapshot.data.docs[index].data()["from"] ==
                            user.uid) {
                          isMe = true;
                        } else {
                          isMe = false;
                        }

                        return Padding(
                          padding: EdgeInsets.all(10),
                          child: Column(
                            children: <Widget>[
                              Bubble(
                                message:
                                    snapshot.data.docs[index].data()["message"],
                                isMe: isMe,
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Icon(Icons.error),
                    );
                  }
                  return CircularProgressIndicator();
                }),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            width: MediaQuery.of(context).size.width,
            child: Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(color: Colors.white, boxShadow: [
                BoxShadow(
                  color: Colors.grey[300],
                  offset: Offset(-2, 0),
                  blurRadius: 5,
                ),
              ]),
              child: Row(
                children: <Widget>[
                  // IconButton(
                  //   onPressed: () {},
                  //   icon: Icon(
                  //     Icons.camera,
                  //     color: Color(0xff3E8DF3),
                  //   ),
                  // ),
                  IconButton(
                    onPressed: chooseFile,
                    icon: Icon(
                      Icons.image,
                      color: Colors.purple,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 15),
                  ),
                  Expanded(
                    child: Form(
                      key: _formKey,
                      child: TextFormField(
                        autofocus: false,
                        keyboardType: TextInputType.text,
                        controller: _textController,
                        decoration: InputDecoration(
                          hintText: 'Enter Message',
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () async {
                      if (_formKey.currentState.validate()) {
                        Message m = new Message();
                        m.message = _textController.text;
                        m.from = user.uid;
                        m.read = false;
                        m.date = DateTime.now().toUtc();

                        var result = await ChatService()
                            .sendChatsText(m, widget.messageId);
                        if (result is String) {
                          Fluttertoast.showToast(
                              msg: "Unable to send message",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.CENTER,
                              timeInSecForIosWeb: 3,
                              backgroundColor: Colors.red,
                              textColor: Colors.white,
                              fontSize: 16.0);
                        } else {
                          _formKey.currentState.reset();
                        }
                      }
                    },
                    icon: Icon(
                      Icons.send,
                      color: Colors.purple,
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

class Bubble extends StatelessWidget {
  final bool isMe;
  final String message;

  Bubble({this.message, this.isMe});

  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {},
      child: Container(
        margin: EdgeInsets.all(5),
        padding: isMe ? EdgeInsets.only(left: 40) : EdgeInsets.only(right: 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Column(
              mainAxisAlignment:
                  isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
              crossAxisAlignment:
                  isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    gradient: isMe
                        ? LinearGradient(
                            begin: Alignment.topRight,
                            end: Alignment.bottomLeft,
                            stops: [
                                0.1,
                                1
                              ],
                            colors: [
                                Colors.blueAccent,
                                Colors.blue,
                              ])
                        : LinearGradient(
                            begin: Alignment.topRight,
                            end: Alignment.bottomLeft,
                            stops: [
                                0.1,
                                1
                              ],
                            colors: [
                                Color(0xFFEBF5FC),
                                Color(0xFFEBF5FC),
                              ]),
                    borderRadius: isMe
                        ? BorderRadius.only(
                            topRight: Radius.circular(15),
                            topLeft: Radius.circular(15),
                            bottomRight: Radius.circular(0),
                            bottomLeft: Radius.circular(15),
                          )
                        : BorderRadius.only(
                            topRight: Radius.circular(15),
                            topLeft: Radius.circular(15),
                            bottomRight: Radius.circular(15),
                            bottomLeft: Radius.circular(0),
                          ),
                  ),
                  child: Column(
                    crossAxisAlignment: isMe
                        ? CrossAxisAlignment.end
                        : CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        message,
                        textAlign: isMe ? TextAlign.end : TextAlign.start,
                        style: TextStyle(
                          color: isMe ? Colors.white : Colors.grey,
                        ),
                      )
                    ],
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
