import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:myapp/Models/users.dart';
import 'package:myapp/pages/navBarPages/Chats/chat_details.dart';
import 'package:myapp/pages/navBarPages/Chats/chat_details_brim.dart';
import 'package:myapp/services/chatService.dart';
import 'package:myapp/services/database.dart';
import 'package:myapp/widgets/custom_heading.dart';
import 'package:provider/provider.dart';

class Chats extends StatefulWidget {
  @override
  _ChatsState createState() => _ChatsState();
}

class _ChatsState extends State<Chats> {
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
  Users u;
  @override
  void initState() {
    user = FirebaseAuth.instance.currentUser;
    u = Provider.of<Users>(context, listen: false);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          // onTap: () {
          //   _scaffoldKey.currentState.openDrawer();
          // },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: CircleAvatar(
              radius: 2,
              backgroundImage: NetworkImage("${u.picture}"),
              backgroundColor: Colors.purple,
            ),
          ),
        ),
        backgroundColor: Colors.white,
        title: const Text('Brim', style: TextStyle(color: Colors.black)),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            // CustomHeading(
            //   title: 'Groups',
            // ),
            Container(
              height: 150,
              child: StreamBuilder<QuerySnapshot>(
                  stream: ChatService().brimStream(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      if (snapshot.data.docs.length == 0) {
                        print("makaveliu");
                        return Center(
                          child: Text(
                            "No Brims here",
                            style: TextStyle(
                              color: Colors.grey,
                            ),
                          ),
                        );
                      } else {
                        print("ooohhhhh");
                        return ListView.builder(
                          itemCount: snapshot.data.docs.length,
                          shrinkWrap: true,
                          physics: BouncingScrollPhysics(),
                          scrollDirection: Axis.horizontal,
                          padding: EdgeInsets.all(15),
                          itemBuilder: (BuildContext context, int index) {
                             if( snapshot.data.docs[index].data()["participant1"].toString()  == user.uid || snapshot.data.docs[index].data()["participant2"].toString()  == user.uid){
                                  return yourBrims(
                                snapshot.data.docs[index].data(), index);
                             }
                             
                          },
                        );
                      }
                    } else if (snapshot.hasError) {
                      return Center(
                        child: Icon(Icons.error),
                      );
                    }
                    return Padding(
                      padding: const EdgeInsets.all(30.0),
                      child: CircularProgressIndicator(),
                    );
                  }),
            ),
            CustomHeading(
              title: 'Friends',
            ),
            StreamBuilder<QuerySnapshot>(
                stream: ChatService().chatsStream(),
                builder: (context, snapshot) {
                 
                  if (snapshot.hasData) {
                    if (snapshot.data.docs.length == 0) {
                     
                      return Center(
                        child: Text(
                          "You have no friends yet",
                          style: TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                      );
                    } else {
                      return ListView.builder(
                        itemCount: snapshot.data.docs.length,
                        shrinkWrap: true,
                        physics: BouncingScrollPhysics(),
                        scrollDirection: Axis.vertical,
                        itemBuilder: (BuildContext context, int index) {
                            if( snapshot.data.docs[index].data()["participant1"].toString()  == user.uid || snapshot.data.docs[index].data()["participant2"].toString()  == user.uid){
                                  return yourChats(
                              snapshot.data.docs[index].data(), index);
                          }
                          
                         // if( snapshot.data.docs[index].data()["participant1"] == user.uid || snapshot.data.docs[index].data()["participant1"])
                         
                        },
                      );
                    }
                  } else if (snapshot.hasError) {
                    print(snapshot.error.toString());
                    return Center(
                      child: Icon(Icons.error),
                    );
                  }
                  return Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: CircularProgressIndicator(),
                  );
                }),
          ],
        ),
      ),
    );
  }

  Widget yourChats(Map<dynamic, dynamic> data, int index) {
    String otherUser;
    String newMessage;
    String messageId;
    bool isParticipant1;
    messageId =
        data["participant1"].toString() + data["participant2"].toString();
    int i = index % color.length;
    print(data);
    if (data["participant1"] == user.uid) {
      otherUser = data["participant2"].toString();
      isParticipant1 = true;
      newMessage = "newMessage1";
    }
    if (data["participant2"] == user.uid) {
      otherUser = data["participant1"].toString();
      isParticipant1 = false;
      newMessage = "newMessage2";
    }
    return otherUser == null
        ? Center(
            child: Text(
              "No Chats here",
              style: TextStyle(
                color: Colors.grey,
              ),
            ),
          )
        : FutureBuilder(
            future: DatabaseService().getUserInfo(otherUser),
            builder: (context, snapshotfuture) {
              if (snapshotfuture.hasData) {
                return Material(
                  child: InkWell(
                    onLongPress: () {
                      return showCupertinoModalPopup<void>(
                        context: context,
                        builder: (BuildContext context) {
                          return CupertinoActionSheet(
                            title: Text('Remove friend'),
                            message: Text(
                                'Are you sure you want to unfriend this user? NB. All your chats would be lost'),
                            actions: <Widget>[
                              CupertinoActionSheetAction(
                                child: Text('Yes'),
                                onPressed: () {/** */},
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
                    onTap: () {
                      u.currentUser = snapshotfuture.data;
                      u.currentUser.uid = otherUser;
                      print("okay");
                      print(otherUser);
                      print(u.currentUser.uid);
                      Navigator.push(
                        context,
                        CupertinoPageRoute(
                          builder: (context) => ChatDetails(
                            messageId: messageId,
                            isParticipant1: isParticipant1,
                          ),
                        ),
                      );
                    },
                    child: Container(
                      margin: EdgeInsets.fromLTRB(15, 5, 15, 5),
                      padding: EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black38,
                            offset: Offset(-1, 1),
                            blurRadius: 10,
                          )
                        ],
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.white,
                      ),
                      child: Row(
                        children: <Widget>[
                          Stack(
                            children: <Widget>[
                              Container(
                                child: CircleAvatar(
                                  backgroundImage: NetworkImage(
                                      '${snapshotfuture.data.picture}'),
                                  minRadius: 35,
                                  backgroundColor: Colors.grey[200],
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 10),
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  snapshotfuture.data.userName,
                                  style: TextStyle(
                                    color: Colors.black,
                                    // fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(top: 5),
                                ),
                                data[newMessage] == true
                                    ? Row(
                                        children: [
                                          Container(
                                            child: Icon(
                                              Icons.messenger,
                                              color: Colors.purple,
                                              size: 15,
                                            ),
                                          ),
                                          SizedBox(
                                            width: 8,
                                          ),
                                          Text(
                                            'New Message',
                                            style: TextStyle(
                                              fontWeight: FontWeight.w800,
                                              color: Colors.purple,
                                              fontSize: 14,
                                            ),
                                          ),
                                        ],
                                      )
                                    : Row(
                                        children: [
                                          Text(
                                            'read',
                                            style: TextStyle(
                                              fontWeight: FontWeight.w800,
                                              color: Colors.blue,
                                              fontSize: 14,
                                            ),
                                          ),
                                          SizedBox(
                                            width: 8,
                                          ),
                                          Icon(
                                            Icons.messenger_outline,
                                            color: Colors.blue,
                                            size: 16,
                                          ),
                                        ],
                                      ),
                                Padding(
                                  padding: EdgeInsets.only(top: 5),
                                ),
                                Text(
                                  DatabaseService().convertUTCToLocalTime(
                                      data["latestMessage"].toDate()),
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 12,
                                  ),
                                )
                              ],
                            ),
                          ),
                          Column(
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.only(right: 15),
                                child: Icon(
                                  Icons.chevron_right,
                                  size: 18,
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                );
              } else if (snapshotfuture.hasError) {
                return Center(
                  child: Text(snapshotfuture.error.toString()),
                );
              }
              return CircularProgressIndicator();
            },
          );
  }

  Widget yourBrims(Map<dynamic, dynamic> data, int index) {
    String otherUser;
    String messageId;
    bool isParticipant1;

    String newMessage;
    messageId =
        data["participant1"].toString() + data["participant2"].toString();
    int i = index % color.length;
    print(data);
    if (data["participant1"] == user.uid) {
      otherUser = data["participant2"].toString();
      isParticipant1 = true;
      newMessage = "newMessage1";
    }
    if (data["participant2"] == user.uid) {
      otherUser = data["participant1"].toString();
      isParticipant1 = false;
      newMessage = "newMessage2";
    }
    print("okay");
    print(isParticipant1);
    return  otherUser == null
        ? Center(
            child: Text(
              "No Brims here",
              style: TextStyle(
                color: Colors.grey,
              ),
            ),
          )
        : FutureBuilder<Users>(
        future: DatabaseService().getUserInfo(otherUser),
        builder: (context, snapshotfuture) {
          if (snapshotfuture.hasData) {
            print(snapshotfuture.data.userName);
            return Column(
              children: <Widget>[
                InkWell(
                  onTap: () {
                    print(snapshotfuture.data.userName);
                    //u.currentUser = snapshotfuture.data;
                    u.currentUser = snapshotfuture.data;
                    u.currentUser.uid = otherUser;
                    Navigator.push(
                      context,
                      CupertinoPageRoute(
                        builder: (context) => ChatDetailsBrim(
                          messageId: messageId,
                          isParticipant1: isParticipant1,
                        ),
                      ),
                    );
                  },
                  child: Stack(
                    children: [
                      Container(
                        width: 100,
                        height: 100,
                        margin: EdgeInsets.only(right: 15),
                        decoration: BoxDecoration(
                          color: color[i],
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black38,
                              offset: Offset(-1, 1),
                              blurRadius: 10,
                            )
                          ],
                          // gradient: LinearGradient(
                          //   begin: Alignment.topRight,
                          //   end: Alignment.bottomRight,
                          //   stops: [0.1, 1],
                          //   colors: [
                          //     Colors.pink,
                          //     Colors.pinkAccent,
                          //   ],
                          // ),
                          borderRadius: BorderRadius.circular(100),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(30),
                          child: Image(
                              image: AssetImage(
                            'lib/images/brim0.png',
                          )),
                        ),
                      ),
                      data[newMessage] == true
                          ? Positioned(
                              left: 13,
                              top: 7,
                              child: Container(
                                width: 15,
                                height: 15,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle),
                              ),
                            )
                          : Container()
                    ],
                  ),
                ),
                Expanded(
                    child: Container(
                        margin: EdgeInsets.only(right: 20),
                        child: Text(snapshotfuture.data.userName)))
              ],
            );
          } else if (snapshotfuture.hasError) {
            return Center(
              child: Text(snapshotfuture.error.toString()),
            );
          }
          return CircularProgressIndicator();
        });
  }
}
