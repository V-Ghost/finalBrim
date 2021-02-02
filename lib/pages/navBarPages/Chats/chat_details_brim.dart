import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:myapp/widgets/blurFilter.dart';
import 'package:myapp/Models/message.dart';
import 'package:myapp/Models/users.dart';
import 'package:myapp/pages/navBarPages/Chats/chat_details.dart';
import 'package:myapp/services/chatService.dart';
import 'package:myapp/services/database.dart';
import 'package:provider/provider.dart';

class ChatDetailsBrim extends StatefulWidget {
  final String messageId;
  final bool isParticipant1;
  final Users receipent;
  ChatDetailsBrim({this.messageId, this.isParticipant1, this.receipent});
  @override
  _ChatDetailsBrimState createState() => _ChatDetailsBrimState();
}

class _ChatDetailsBrimState extends State<ChatDetailsBrim> {
  int length;
  bool lastMessageMe;
  bool isComment = false;
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
    //print("okadddy");
    //print(u.currentUser.userName);
    user = FirebaseAuth.instance.currentUser;
    //keyboardVisibilityController = KeyboardVisibilityController();
    ChatService().readMessage(widget.messageId, widget.isParticipant1);
    //detectKeyBoard();
    //ChatService().changeBrimtoFriend(widget.messageId);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Timer(
          Duration(milliseconds: 500),
          () => _scrollController
              .jumpTo(_scrollController.position.maxScrollExtent));
      print("finish");
    });
    // print(u.currentUser.userName);
    // TODO: implement initState
    super.initState();
  }

  Stream getYourChats(String messageId) {
    var snapshot = FirebaseFirestore.instance
        .collection("chats")
        .doc(messageId)
        .collection("messages")
        .orderBy("time", descending: false)
        .snapshots();
    snapshot.length.then((onValue) {
      length = onValue;
      // print(length);
    });
    // print("okay");
    // print(length);
    snapshot.last.then((onValue) {
      //print(onValue);
    });
    // snapshot.forEach((value){
    // print("from chats");
    //  print( value.docs);
    // });
    // snapshot.docs[index].data()["from"]
    return snapshot;
  }

  // void detectKeyBoard() {
  //   // keyboardVisibilityController.onChange.listen((bool visible) {
  //   //   print('Keyboard visibility update. Is visible: ${visible}');
  //   //   // Timer(
  //   //   //     Duration(milliseconds: 500),
  //   //   //     () => _scrollController
  //   //   //         .jumpTo(_scrollController.position.maxScrollExtent));
  //   //   // setState(() {});
  //   // });
  // }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  // void scrollToBottom() {
  //  _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
  // }

  // void chooseFile() async {
  //   await ImagePicker.pickImage(source: ImageSource.gallery)
  //       .then((image) async {
  //     if (image != null) {
  //       Message m = new Message();
  //       m.image = image;
  //       m.message = _textController.text;
  //       m.from = user.uid;
  //       m.read = false;
  //       m.date = DateTime.now().toUtc();
  //       var result = await ChatService().sendChatsText(m, widget.messageId,widget.isParticipant1);
  //       if (result is String) {
  //         Fluttertoast.showToast(
  //             msg: "Unable to send message",
  //             toastLength: Toast.LENGTH_SHORT,
  //             gravity: ToastGravity.CENTER,
  //             timeInSecForIosWeb: 3,
  //             backgroundColor: Colors.red,
  //             textColor: Colors.white,
  //             fontSize: 16.0);
  //       } else {
  //         _formKey.currentState.reset();
  //       }

  //       setState(() {
  //         // loading = true;
  //       });
  //     }
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    ChatService().readMessage(widget.messageId, widget.isParticipant1);

    return Scaffold(
      appBar: AppBar(
        elevation: 0.4,
        iconTheme: IconThemeData(color: Colors.grey),
        backgroundColor: Colors.white,
        title: Row(
          children: <Widget>[
            BlurFilter(
              child: Container(
                width: 40,
                height: 40,
                margin: EdgeInsets.fromLTRB(0, 5, 10, 0),
                child: CircleAvatar(
                radius: 2,
                backgroundImage: NetworkImage("${u.currentUser.picture}"),
                backgroundColor: Colors.purple,
              ),
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(10, 0, 0, 0),
              child: u.currentUser == null
                  ? Text(widget.receipent.userName)
                  : Text(
                      '${u.currentUser.userName}',
                      style: TextStyle(color: Colors.black),
                    ),
            ),
            Expanded(child: Container()),
            InkWell(
              onTap: () {
                return showCupertinoModalPopup<void>(
                  context: context,
                  builder: (BuildContext context) {
                    return CupertinoActionSheet(
                      title: Text('Add Friend'),
                      message: Text(
                          'Are you sure you want to add this user to your friends? NB. Your profile picture becomes visible'),
                      actions: <Widget>[
                        CupertinoActionSheetAction(
                          child: Text('Yes'),
                          onPressed: () async {
                            var result = await ChatService().permit(
                                widget.messageId, widget.isParticipant1);

                            if (result == true) {
                              //print("eii pemit");
                              var permit = await ChatService()
                                  .checkPermit(widget.messageId);

                              // print(permit);
                              if (permit == true) {
                                var change = await ChatService()
                                    .changeBrimtoFriend(widget.messageId);
                                //print("heeerrree");
                                if (change == true) {
                                  // print("heeerrree aggaainn");
                                  Navigator.of(context).pop();
                                  Navigator.push(
                                      context,
                                      CupertinoPageRoute(
                                        builder: (context) => ChatDetails(
                                          messageId: widget.messageId,
                                          isParticipant1: widget.isParticipant1,
                                        ),
                                      ));
                                } else {
                                  Navigator.of(context).pop();
                                  Fluttertoast.showToast(
                                      msg: "Sorry :( an error was encountered",
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.BOTTOM,
                                      timeInSecForIosWeb: 3,
                                      backgroundColor: Colors.red,
                                      textColor: Colors.white,
                                      fontSize: 16.0);
                                }
                              } else {
                                Navigator.of(context).pop();
                                Fluttertoast.showToast(
                                    msg: "Waiting for this user to add you",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.BOTTOM,
                                    timeInSecForIosWeb: 3,
                                    backgroundColor: Colors.red,
                                    textColor: Colors.white,
                                    fontSize: 16.0);
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
                      ],
                      cancelButton: CupertinoActionSheetAction(
                        isDefaultAction: true,
                        child: Text('Cancel'),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    );
                  },
                );
              },
              child: Container(
                margin: EdgeInsets.fromLTRB(0, 0, 15, 0),
                child: Icon(
                  CupertinoIcons.person_add_solid,
                  size: 40,
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
                stream: getYourChats(widget.messageId),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                      physics: BouncingScrollPhysics(),
                      controller: _scrollController,
                      shrinkWrap: true,
                      itemCount: snapshot.data.docs.length,
                      itemBuilder: (BuildContext context, int index) {
                        length = snapshot.data.docs.length;
                        //print(snapshot.data.docs.length);
                        // if (snapshot.data.docs[index].data()["type"] ==
                        //     "image") {
                        //   isImage = true;
                        // }
                        if (snapshot.data.docs[index].data()["type"] ==
                            "comment") {
                          isComment = true;
                        } else {
                          isComment = false;
                        }
                        if (snapshot.data.docs[index].data()["from"] ==
                            user.uid) {
                          isMe = true;
                        } else {
                          isMe = false;
                        }
                        // print(isComment);
                        // print(snapshot.data.docs[index].data()["broadcast"]);
                        return Padding(
                          padding: EdgeInsets.all(10),
                          child: Column(
                            children: <Widget>[
                              isComment
                                  ? Bubble(
                                      message: snapshot.data.docs[index]
                                          .data()["message"],
                                      isMe: isMe,
                                      isComment: isComment,
                                      comment: snapshot.data.docs[index]
                                          .data()["broadcast"],
                                    )
                                  : Bubble(
                                      message: snapshot.data.docs[index]
                                          .data()["message"],
                                      isMe: isMe,
                                      isComment: false,
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
          Expanded(
            child: Container(),
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
                  // IconButton(
                  //   //onPressed: () {},
                  //   icon: Icon(
                  //     Icons.image,
                  //     color: Colors.purple,
                  //   ),
                  // ),
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
                      // ChatService().getChatlength(widget.messageId);
                      if (_textController.text != "") {
                        // length =
                        //     await ChatService().getChatlength(widget.messageId);
                        if (length < 100) {
                          Message m = new Message();

                          if (isMe == true) {
                            m.message = _textController.text;
                            m.from = user.uid;
                            m.read = false;
                            m.date = DateTime.now().toUtc();

                            var result = await ChatService().sendChatsText(
                                m, widget.messageId, widget.isParticipant1);
                            print("send not");
                            print(u.userName);
                            print(u.currentUser.uid);

                            DatabaseService().sendNotification(
                                u.userName, u.currentUser.uid, m.message, null);
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
                              _textController.clear();
                              Timer(
                                  Duration(milliseconds: 500),
                                  () => _scrollController.jumpTo(
                                      _scrollController
                                          .position.maxScrollExtent));
                            }
                          } else {
                            Fluttertoast.showToast(
                                msg:
                                    "You need to be friends to send back to back messages",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.CENTER,
                                timeInSecForIosWeb: 3,
                                backgroundColor: Colors.red,
                                textColor: Colors.white,
                                fontSize: 16.0);
                          }
                        } else {
                          Fluttertoast.showToast(
                              msg:
                                  "Text Limit Reached :( You need to be friends to keep on messaging each other",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.CENTER,
                              timeInSecForIosWeb: 3,
                              backgroundColor: Colors.red,
                              textColor: Colors.white,
                              fontSize: 16.0);
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
  final bool isComment;
  final String comment;
  Bubble({this.message, this.isMe, this.isComment, this.comment});

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
                                Colors.green,
                                Colors.green,
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
                  child: isComment
                      ? Column(
                          crossAxisAlignment: isMe
                              ? CrossAxisAlignment.end
                              : CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                              padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
                              decoration: BoxDecoration(
                                  color: Colors.purple,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(8))),
                              height: 30,
                              child: Container(
                                margin: EdgeInsets.fromLTRB(0, 5, 0, 0),
                                child: Text(
                                  comment,
                                  textAlign:
                                      isMe ? TextAlign.end : TextAlign.start,
                                  style: TextStyle(
                                    color: isMe ? Colors.white : Colors.grey,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              message,
                              textAlign: isMe ? TextAlign.end : TextAlign.start,
                              style: TextStyle(
                                color: isMe ? Colors.white : Colors.grey,
                              ),
                            )
                          ],
                        )
                      : Column(
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
