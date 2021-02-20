import 'dart:async';
import 'dart:io';
import 'package:myapp/widgets/SendedMessageWidget.dart';
import 'package:myapp/widgets/comment.dart';
import 'package:myapp/widgets/blurFilter.dart';
import 'package:myapp/widgets/ReceivedComment.dart';
import 'package:myapp/widgets/ReceivedMessageWidget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:image_picker/image_picker.dart';

import 'package:myapp/Models/message.dart';
import 'package:myapp/Models/users.dart';
import 'package:myapp/pages/navBarPages/Chats/chat_details_brim.dart';
import 'package:myapp/pages/navBarPages/Chats/viewImage.dart';
import 'package:myapp/pages/navBarPages/chats.dart';
import 'package:myapp/services/ChatStream.dart';
import 'package:myapp/services/chatService.dart';
import 'package:myapp/services/database.dart';

import 'package:provider/provider.dart';

class ChatDetails extends StatefulWidget {
  final String messageId;
  final bool isParticipant1;
  final Users receipent;
  ChatDetails({this.messageId, this.isParticipant1, this.receipent});
  @override
  _ChatDetailsState createState() => _ChatDetailsState();
}

class _ChatDetailsState extends State<ChatDetails> {
  ChatStream c;
  int length;
  bool lastMessageMe;
  Users u;
  User user;
  bool isMe;
  bool isImage = false;
  bool isComment = false;
  String test;
  double h;
  bool firstTime = false;
  var lastDocument;
  // String messageId = widget.messageId;
  final TextEditingController _textController = TextEditingController();
  ScrollController _scrollController = new ScrollController();
  final _formKey = GlobalKey<FormState>();
  var keyboardVisibilityController;
  @override
  void initState() {
    h = 540;
    u = Provider.of<Users>(context, listen: false);
    c = new ChatStream(messageId: widget.messageId);
    user = FirebaseAuth.instance.currentUser;
    //keyboardVisibilityController = KeyboardVisibilityController();

    // detectKeyBoard();
    ChatService().readMessage(widget.messageId, widget.isParticipant1);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Timer(
          Duration(milliseconds: 500),
          () => _scrollController
              .jumpTo(_scrollController.position.maxScrollExtent));
      // print("finish");
    });
    _scrollController.addListener(() {
      double maxScroll = _scrollController.position.minScrollExtent;
      double currentScroll = _scrollController.position.pixels;
      double delta = MediaQuery.of(context).size.height * 0.20;
      if (maxScroll == currentScroll) {
        //  print("load messages");
        //  print(lastDocument);
        //  print(test);
        // c.getChats(lastDocument);
      }
    });
    // print(u.currentUser.userName);
    // TODO: implement initState
    super.initState();
  }

  // void detectKeyBoard() {
  //   // keyboardVisibilityController.onChange.listen((bool visible) {
  //   //   print('Keyboard visibility update. Is visible: ${visible}');
  //   //   // Timer(
  //   //   //     Duration(milliseconds: 500),
  //   //   //     () => _scrollController
  //   //   //         .jumpTo(_scrollController.position.maxScrollExtent));
  //   //   setState(() {});
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
        // print(u.currentUser.picture);
        Fluttertoast.showToast(
            msg: "The Image is sending......",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 3,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
        var result = await ChatService()
            .sendChatsFile(m, widget.messageId, widget.isParticipant1);

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
              () => _scrollController
                  .jumpTo(_scrollController.position.maxScrollExtent));
        }

        setState(() {
          // loading = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    ChatService().readMessage(widget.messageId, widget.isParticipant1);
    return Scaffold(
      body: SafeArea(
        child: Container(
          child: Stack(
            fit: StackFit.loose,
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                // mainAxisAlignment: MainAxisAlignment.start,
                // mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  SizedBox(
                    height: 65,
                    child: Container(
                      color: Colors.blue,
                      child: Row(
                        children: <Widget>[
                          IconButton(
                            icon: Icon(
                              Icons.arrow_back,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                          Spacer(),
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
                                          Navigator.of(context).pop();
                                          var result = await ChatService()
                                              .permit(widget.messageId,
                                                  widget.isParticipant1);

                                          if (result == true) {
                                            //print("eii pemit");
                                            var permit = await ChatService()
                                                .checkPermit(widget.messageId);

                                            // print(permit);
                                            if (permit == true) {
                                              var change = await ChatService()
                                                  .changeBrimtoFriend(
                                                      widget.messageId);
                                              //print("heeerrree");
                                              if (change == true) {
                                                // print("heeerrree aggaainn");
                                                //Navigator.of(context).pop();
                                                Navigator.push(
                                                    context,
                                                    CupertinoPageRoute(
                                                      builder: (context) =>
                                                          ChatDetails(
                                                        messageId:
                                                            widget.messageId,
                                                        isParticipant1: widget
                                                            .isParticipant1,
                                                      ),
                                                    ));
                                              } else {
                                                Navigator.of(context).pop();
                                                Fluttertoast.showToast(
                                                    msg:
                                                        "Sorry :( an error was encountered",
                                                    toastLength:
                                                        Toast.LENGTH_SHORT,
                                                    gravity:
                                                        ToastGravity.BOTTOM,
                                                    timeInSecForIosWeb: 3,
                                                    backgroundColor: Colors.red,
                                                    textColor: Colors.white,
                                                    fontSize: 16.0);
                                              }
                                            } else {
                                              // Navigator.of(context).pop();
                                              Fluttertoast.showToast(
                                                  msg:
                                                      "Waiting for this user to add you",
                                                  toastLength:
                                                      Toast.LENGTH_SHORT,
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
                            child: Column(
                              // crossAxisAlignment: CrossAxisAlignment.center,
                              // mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Expanded(
                                  child: Container(),
                                ),
                                // u.currentUser == null
                                //     ? Text(
                                //         widget.receipent.userName,
                                //         style: TextStyle(color: Colors.black),
                                //       )
                                //     :
                                Text(
                                  '${u.currentUser.userName}',
                                  style: TextStyle(color: Colors.black),
                                ),
                                Expanded(
                                  child: Container(),
                                ),
                              ],
                            ),
                          ),
                          Spacer(),
                          Padding(
                            padding:
                                const EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 0.0),
                            child: Container(
                              width: 40,
                              height: 40,
                              margin: EdgeInsets.fromLTRB(0, 5, 10, 0),
                              child: CircleAvatar(
                                radius: 2,
                                backgroundImage:
                                    NetworkImage("${u.currentUser.picture}"),
                                backgroundColor: Colors.purple,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Divider(
                    height: 0,
                    color: Colors.black54,
                  ),
                  Flexible(
                    fit: FlexFit.tight,
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                          // image: DecorationImage(
                          //     image: AssetImage(
                          //         "assets/images/chat-background-1.jpg"),
                          //     fit: BoxFit.cover,
                          //     colorFilter:Colors.white),
                          ),
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
                                  length = snapshot.data.docs.length;
                                  //print(snapshot.data.docs.length);
                                  // if (snapshot.data.docs[index].data()["type"] ==
                                  //     "image") {
                                  //   isImage = true;
                                  // }
                                  //print(snapshot.data.docs.length);
                                  if (snapshot.data.docs[index]
                                          .data()["type"] ==
                                      "comment") {
                                    isComment = true;
                                  } else {
                                    isComment = false;
                                  }
                                  if (snapshot.data.docs[index]
                                          .data()["type"] ==
                                      "image") {
                                    isImage = true;
                                  } else {
                                    isImage = false;
                                  }
                                  if (snapshot.data.docs[index]
                                          .data()["from"] ==
                                      user.uid) {
                                    isMe = true;
                                  } else {
                                    isMe = false;
                                  }
                                  if (firstTime != true) {
                                    if (index == 0) {
                                      // print("we reach");
                                      lastDocument = snapshot.data.docs[index];
                                      test = snapshot.data.docs[index]
                                          .data()["message"];
                                      Timer(
                                          Duration(milliseconds: 500),
                                          () => _scrollController.jumpTo(
                                              _scrollController
                                                  .position.maxScrollExtent));
                                      firstTime = true;
                                    }
                                  }

                                  return ChatBubble(
                                    message: snapshot.data.docs[index]
                                        .data()["message"],
                                    isMe: isMe,
                                    isComment: isComment,
                                    comment: snapshot.data.docs[index]
                                        .data()["broadcast"],
                                    isImage: isImage,
                                    imageAddress:  snapshot.data.docs[index]
                                        .data()["message"],
                                  );
                                  // print(isComment);
                                  // print(snapshot.data.docs[index].data()["broadcast"]);
                                  // return Padding(
                                  //   padding: EdgeInsets.all(10),
                                  //   child: Column(
                                  //     children: <Widget>[
                                  //       isComment
                                  //           ? Bubble(
                                  //               message: snapshot.data.docs[index]
                                  //                   .data()["message"],
                                  //               isMe: isMe,
                                  //               isComment: isComment,
                                  //               comment: snapshot.data.docs[index]
                                  //                   .data()["broadcast"],
                                  //             )
                                  //           : Bubble(
                                  //               message: snapshot.data.docs[index]
                                  //                   .data()["message"],
                                  //               isMe: isMe,
                                  //               isComment: false,
                                  //             ),
                                  //     ],
                                  //   ),
                                  // );
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
                  ),
                  Divider(height: 0, color: Colors.black26),
                  Container(
                    height: 50,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Row(
                        children: [
                          IconButton(
                            onPressed: chooseFile,
                            icon: Icon(
                              Icons.image,
                              color: Colors.purple,
                            ),
                          ),
                          Expanded(
                            child: Form(
                              key: _formKey,
                              child: TextField(
                                maxLines: 20,
                                controller: _textController,
                                decoration: InputDecoration(
                                  suffixIcon: Row(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      IconButton(
                                        icon: Icon(Icons.send),
                                        onPressed: () async {
                                          // ChatService().getChatlength(widget.messageId);
                                          if (_textController.text != "") {
                                            // length =
                                            //     await ChatService().getChatlength(widget.messageId);

                                            Message m = new Message();

                                            m.message = _textController.text;
                                            m.from = user.uid;
                                            m.read = false;
                                            m.date = DateTime.now().toUtc();

                                            var result = await ChatService()
                                                .sendChatsTextFromChats(
                                                    m,
                                                    widget.messageId,
                                                    widget.isParticipant1);
                                            DatabaseService().sendNotification(
                                                u.userName,
                                                u.currentUser.uid,
                                                m.message,
                                                null);
                                            if (result is String) {
                                              Fluttertoast.showToast(
                                                  msg: "Unable to send message",
                                                  toastLength:
                                                      Toast.LENGTH_SHORT,
                                                  gravity: ToastGravity.CENTER,
                                                  timeInSecForIosWeb: 3,
                                                  backgroundColor: Colors.red,
                                                  textColor: Colors.white,
                                                  fontSize: 16.0);
                                            } else {
                                              _textController.clear();
                                              Timer(
                                                  Duration(milliseconds: 500),
                                                  () => _scrollController
                                                      .jumpTo(_scrollController
                                                          .position
                                                          .maxScrollExtent));
                                            }
                                          }
                                        },
                                      ),
                                    ],
                                  ),
                                  border: InputBorder.none,
                                  hintText: "enter your message",
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0.4,
        iconTheme: IconThemeData(color: Colors.grey),
        backgroundColor: Colors.white,
        title: Row(
          children: <Widget>[
            Container(
              width: 40,
              height: 40,
              margin: EdgeInsets.fromLTRB(0, 5, 10, 0),
              child: CircleAvatar(
                radius: 2,
                backgroundImage: NetworkImage("${u.currentUser.picture}"),
                backgroundColor: Colors.purple,
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
          ],
        ),
      ),
      body: Stack(
        children: <Widget>[
          Container(
            color: Colors.white,
            height: 540,
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
                        length = snapshot.data.docs.length;
                        //print(snapshot.data.docs.length);
                        if (snapshot.data.docs[index].data()["type"] ==
                            "comment") {
                          isComment = true;
                        } else {
                          isComment = false;
                        }
                        if (snapshot.data.docs[index].data()["type"] ==
                            "image") {
                          isImage = true;
                        } else {
                          isImage = false;
                        }
                        if (snapshot.data.docs[index].data()["from"] ==
                            user.uid) {
                          isMe = true;
                        } else {
                          isMe = false;
                        }
                        if (firstTime != true) {
                          if (index == 0) {
                            // print("we reach");
                            lastDocument = snapshot.data.docs[index];
                            test = snapshot.data.docs[index].data()["message"];
                            Timer(
                                Duration(milliseconds: 500),
                                () => _scrollController.jumpTo(_scrollController
                                    .position.maxScrollExtent));
                            firstTime = true;
                          }
                        }

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
                                      isImage: isImage,
                                      
                                    )
                                  : Bubble(
                                      message: snapshot.data.docs[index]
                                          .data()["message"],
                                      isMe: isMe,
                                      isComment: isComment,
                                      comment: snapshot.data.docs[index]
                                          .data()["broadcast"],
                                      isImage: isImage,
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

          // Expanded(
          //   child: Container(),
          // ),
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
                      // ChatService().getChatlength(widget.messageId);
                      if (_textController.text != "") {
                        // length =
                        //     await ChatService().getChatlength(widget.messageId);

                        Message m = new Message();

                        m.message = _textController.text;
                        m.from = user.uid;
                        m.read = false;
                        m.date = DateTime.now().toUtc();

                        var result = await ChatService().sendChatsTextFromChats(
                            m, widget.messageId, widget.isParticipant1);
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
                                  _scrollController.position.maxScrollExtent));
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

class ChatBubble extends StatelessWidget {
  final bool isMe;
  final String message;
  final bool isComment;
  final String comment;
  final bool isImage;
  final String imageAddress;
  ChatBubble(
      {this.message, this.isMe, this.isComment, this.comment, this.isImage,this.imageAddress});
  @override
  Widget build(BuildContext context) {
    return isComment
        ? Align(
            alignment: isMe ? Alignment(1, 0) : Alignment(-1, 0),
            child: isMe
                ? Comment(
                    content: message,
                    isImage: false,
                    comment: comment,
                  )
                : ReceivedComment(
                    content: message,
                    isImage: false,
                    comment: comment,
                  ),
          )
        : Align(
            alignment: isMe ? Alignment(1, 0) : Alignment(-1, 0),
            child: isMe
                ? SendedMessageWidget(
                    content: message,
                    isImage: isImage,
                    imageAddress: imageAddress,
                  )
                : ReceivedMessageWidget(
                    content: message,
                    isImage: isImage,
                     imageAddress: imageAddress,
                  ),
          );
  }
}

class Bubble extends StatelessWidget {
  final bool isMe;
  final String message;
  final isImage;
  final bool isComment;
  final String comment;
  Bubble({this.message, this.isMe, this.isImage, this.isComment, this.comment});

  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        if (isImage) {
          Navigator.push(
            context,
            CupertinoPageRoute(
                builder: (context) => ViewImage(
                      imageUrl: message,
                    )),
          );
        }
      },
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
                            isImage
                                ? Image.network(message)
                                : Text(
                                    message,
                                    textAlign:
                                        isMe ? TextAlign.end : TextAlign.start,
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
