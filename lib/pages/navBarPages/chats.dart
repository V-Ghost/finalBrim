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
                      return ListView.builder(
                        itemCount: snapshot.data.docs.length,
                        shrinkWrap: true,
                        physics: BouncingScrollPhysics(),
                        scrollDirection: Axis.horizontal,
                        padding: EdgeInsets.all(15),
                        itemBuilder: (BuildContext context, int index) {
                          // print(snapshot.data.docs[index].data());
                          return yourBrims(
                              snapshot.data.docs[index].data(), index);
                        },
                      );
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
                    return ListView.builder(
                      itemCount: snapshot.data.docs.length,
                      shrinkWrap: true,
                      physics: BouncingScrollPhysics(),
                      scrollDirection: Axis.vertical,
                      itemBuilder: (BuildContext context, int index) {
                        return yourChats(
                            snapshot.data.docs[index].data(), index);
                      },
                    );
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
    String messageId;
    bool isParticipant1;
    messageId =
        data["participant1"].toString() + data["participant2"].toString();
    int i = index % color.length;
    print(data);
    if (data["participant1"] == user.uid) {
      otherUser = data["participant2"].toString();
      isParticipant1 = true;
    }
    if (data["participant2"] == user.uid) {
      otherUser = data["participant1"].toString();
      isParticipant1 = false;
    }
    return FutureBuilder(
      future: DatabaseService().getUserInfo(otherUser),
      builder: (context, snapshotfuture) {
        if (snapshotfuture.hasData) {
          return Material(
            child: InkWell(
              onTap: () {
                 u.currentUser = snapshotfuture.data;
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
                            backgroundImage:
                                NetworkImage('${snapshotfuture.data.picture}'),
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
                          Row(
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
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 5),
                          ),
                          Text(
                            ChatService().convertUTCToLocalTime(data["latestMessage"].toDate()),
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
            child: Icon(Icons.error),
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
    messageId =
        data["participant1"].toString() + data["participant2"].toString();
    int i = index % color.length;
    print(data);
    if (data["participant1"] == user.uid) {
      otherUser = data["participant2"].toString();
      isParticipant1 = true;
    }
    if (data["participant2"] == user.uid) {
      otherUser = data["participant1"].toString();
      isParticipant1 = false;
    }
    print("okay");
    print(isParticipant1);
    return FutureBuilder<Users>(
        future: DatabaseService().getUserInfo(otherUser),
        builder: (context, snapshotfuture) {
          if (snapshotfuture.hasData) {
            print(snapshotfuture.data.userName);
            return Column(
              children: <Widget>[
                InkWell(
                  onTap: () {
                    print(snapshotfuture.data.userName);
                    u.currentUser = snapshotfuture.data;
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
                      Positioned(
                        left: 13,
                        top: 7,
                        child: Container(
                          width: 15,
                          height: 15,
                          decoration: BoxDecoration(
                              color: Colors.white, shape: BoxShape.circle),
                        ),
                      ),
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
              child: Icon(Icons.error),
            );
          }
          return CircularProgressIndicator();
        });
  }
}
