import 'dart:async';
import 'dart:io';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:myapp/widgets/SendedMessageWidget.dart';
import 'package:myapp/widgets/comment.dart';
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
  final textValidator = MultiValidator([
    RequiredValidator(errorText: ''),
  ]);
  int length;
  bool lastMessageMe;
  bool isComment = false;
  Users u;
  User user;
  bool isMe;
  bool isImage;
  double h;
  bool added = false;
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
                          Padding(
                            padding: const EdgeInsets.all(8),
                            child: IconButton(
                              icon: Icon(
                                Icons.arrow_back,
                                color: Colors.white,
                              ),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 0),
                            child: BlurFilter(
                              child: Container(
                                width: 40,
                                height: 30,
                                margin: EdgeInsets.fromLTRB(0, 5, 10, 0),
                                child: CircleAvatar(
                                  radius: 1.5,
                                  backgroundImage:
                                      NetworkImage("${u.currentUser.picture}"),
                                  backgroundColor: Colors.purple,
                                ),
                              ),
                            ),
                          ),
                          // Spacer(),
                          Expanded(
                            child: Container(),
                          ),
                          Column(
                            // crossAxisAlignment: CrossAxisAlignment.center,
                            // mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Expanded(
                                child: Container(),
                              ),
                              Text(
                                '${u.currentUser.userName}',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 20),
                              ),
                              Expanded(
                                child: Container(),
                              ),
                            ],
                          ),
                          Expanded(
                            child: Container(),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 10),
                            child: FutureBuilder(
                                future: ChatService().checkIfAddedAsFriend(
                                    widget.messageId, widget.isParticipant1),
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    //print("check complete");
                                    print(snapshot.data);
                                    return IconButton(
                                      icon: Icon(
                                        Icons.add,
                                        color: snapshot.data
                                            ? Colors.pink
                                            : Colors.white,
                                      ),
                                      onPressed: () {
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
                                                    var result =
                                                        await ChatService().permit(
                                                            widget.messageId,
                                                            widget
                                                                .isParticipant1);
                                                    setState(() {});
                                                    if (result == true) {
                                                      //print("eii pemit");
                                                      var permit =
                                                          await ChatService()
                                                              .checkPermit(widget
                                                                  .messageId);

                                                      // print(permit);
                                                      if (permit == true) {
                                                        var change = await ChatService()
                                                            .changeBrimtoFriend(
                                                                widget
                                                                    .messageId);
                                                        //print("heeerrree");
                                                        if (change == true) {
                                                          Fluttertoast.showToast(
                                                              msg:
                                                                  "You are friends now",
                                                              toastLength: Toast
                                                                  .LENGTH_SHORT,
                                                              gravity:
                                                                  ToastGravity
                                                                      .CENTER,
                                                              timeInSecForIosWeb:
                                                                  3,
                                                              backgroundColor:
                                                                  Colors.blue,
                                                              textColor:
                                                                  Colors.white,
                                                              fontSize: 16.0);
                                                          // print("heeerrree aggaainn");
                                                          // Navigator.of(context).pop();
                                                          // Navigator.push(
                                                          //     context,
                                                          //     CupertinoPageRoute(
                                                          //       builder:
                                                          //           (context) =>
                                                          //               ChatDetails(
                                                          //         messageId: widget
                                                          //             .messageId,
                                                          //         isParticipant1:
                                                          //             widget
                                                          //                 .isParticipant1,
                                                          //       ),
                                                          //     ));
                                                        } else {
                                                          Navigator.of(context)
                                                              .pop();
                                                          Fluttertoast.showToast(
                                                              msg:
                                                                  "Sorry :( an error was encountered",
                                                              toastLength: Toast
                                                                  .LENGTH_SHORT,
                                                              gravity:
                                                                  ToastGravity
                                                                      .BOTTOM,
                                                              timeInSecForIosWeb:
                                                                  3,
                                                              backgroundColor:
                                                                  Colors.red,
                                                              textColor:
                                                                  Colors.white,
                                                              fontSize: 16.0);
                                                        }
                                                      } else {
                                                        // Navigator.of(context).pop();
                                                        Fluttertoast.showToast(
                                                            msg:
                                                                "Waiting for this user to add you",
                                                            toastLength: Toast
                                                                .LENGTH_SHORT,
                                                            gravity:
                                                                ToastGravity
                                                                    .BOTTOM,
                                                            timeInSecForIosWeb:
                                                                3,
                                                            backgroundColor:
                                                                Colors.red,
                                                            textColor:
                                                                Colors.white,
                                                            fontSize: 16.0);
                                                      }
                                                      //  Navigator.of(context).pop();
                                                    } else if (result
                                                        is String) {
                                                      Fluttertoast.showToast(
                                                          msg:
                                                              "Unable to add user",
                                                          toastLength: Toast
                                                              .LENGTH_SHORT,
                                                          gravity: ToastGravity
                                                              .BOTTOM,
                                                          timeInSecForIosWeb: 3,
                                                          backgroundColor:
                                                              Colors.red,
                                                          textColor:
                                                              Colors.white,
                                                          fontSize: 16.0);
                                                      Navigator.of(context)
                                                          .pop();
                                                    }
                                                  },
                                                ),
                                              ],
                                              cancelButton:
                                                  CupertinoActionSheetAction(
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
                                    );
                                  }
                                  if (snapshot.hasError) {
                                    return Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Center(
                                        child: Icon(Icons.error),
                                      ),
                                    );
                                  }
                                  return Padding(
                                    padding: const EdgeInsets.all(20.0),
                                    child: CircularProgressIndicator(),
                                  );
                                }),
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
                                  if (snapshot.data.docs[index]
                                          .data()["type"] ==
                                      "comment") {
                                    isComment = true;
                                  } else {
                                    isComment = false;
                                  }
                                  if (snapshot.data.docs[index]
                                          .data()["from"] ==
                                      user.uid) {
                                    isMe = true;
                                  } else {
                                    isMe = false;
                                  }
                                  return ChatBubble(
                                    message: snapshot.data.docs[index]
                                        .data()["message"],
                                    isMe: isMe,
                                    isComment: isComment,
                                    comment: snapshot.data.docs[index]
                                        .data()["broadcast"],
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
                    decoration: BoxDecoration(
                        // borderRadius: BorderRadius.all(Radius.circular(20)),
                        // border: Border.all(
                        //   color: Colors.blue,
                        // ),
                        ),
                    height: 50,
                    child: Material(
                      elevation: 20.0,
                      shadowColor: Colors.black,
                      child: Form(
                        key: _formKey,
                        child: TextFormField(
                          maxLines: 20,
                          validator: textValidator,
                          controller: _textController,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.all(10.0),
                            //  enabledBorder: const OutlineInputBorder(
                            //     borderRadius:
                            //         BorderRadius.all(Radius.circular(20.0)),
                            //     borderSide: const BorderSide(
                            //       color: Colors.white,
                            //     ),
                            //   ),
                            //   focusedBorder: OutlineInputBorder(
                            //     borderRadius:
                            //         BorderRadius.all(Radius.circular(10.0)),
                            //     borderSide: BorderSide(color: Colors.white),
                            //   ),
                            suffixIcon: IconButton(
                              icon: Icon(
                                Icons.send,
                                color: Colors.blue,
                              ),
                              onPressed: () async {
                                // ChatService().getChatlength(widget.messageId);
                                if (_textController.text != "") {
                                  // length =
                                  //     await ChatService().getChatlength(widget.messageId);
                                  if (length < 25) {
                                    Message m = new Message();

                                   // if (isMe != true) {
                                      m.message = _textController.text;
                                      m.from = user.uid;
                                      m.read = false;
                                      m.date = DateTime.now().toUtc();

                                      var result = await ChatService()
                                          .sendChatsText(m, widget.messageId,
                                              widget.isParticipant1);
                                      print("send not");
                                      print(u.userName);
                                      print(u.currentUser.uid);

                                      DatabaseService().sendNotification(
                                          u.userName,
                                          u.currentUser.uid,
                                          m.message,
                                          null);
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
                                    // } else {
                                    //   Fluttertoast.showToast(
                                    //       msg:
                                    //           "You need to be friends to send back to back messages",
                                    //       toastLength: Toast.LENGTH_SHORT,
                                    //       gravity: ToastGravity.CENTER,
                                    //       timeInSecForIosWeb: 3,
                                    //       backgroundColor: Colors.red,
                                    //       textColor: Colors.white,
                                    //       fontSize: 16.0);
                                    // }
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
                            ),
                            border: InputBorder.none,
                            hintText: "enter your message",
                          ),
                        ),
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
  }
}

class ChatBubble extends StatelessWidget {
  final bool isMe;
  final String message;
  final bool isComment;
  final String comment;
  ChatBubble({this.message, this.isMe, this.isComment, this.comment});
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
                    color: Colors.blue)
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
                    isImage: false,
                    color: Colors.blue,
                  )
                : ReceivedMessageWidget(
                    content: message,
                    isImage: false,
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
