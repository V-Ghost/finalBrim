import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:myapp/pages/navBarPages/Chats/viewImage.dart';
// import 'package:simple_chat_application/Global/Colors.dart' as MyColors;
// import 'package:simple_chat_application/Global/Settings.dart' as Settings;

class ReceivedMessageWidget extends StatelessWidget {
  final String content;
  final String imageAddress;
  // final String time;
  final bool isImage;
  const ReceivedMessageWidget({
    Key key,
    this.content,
    this.isImage,
    this.imageAddress,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Padding(
      padding:
          const EdgeInsets.only(right: 75.0, left: 8.0, top: 8.0, bottom: 0),
      child: ClipRRect(
        borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(0),
            bottomRight: Radius.circular(15),
            topLeft: Radius.circular(15),
            topRight: Radius.circular(15)),
        child: Container(
          //  decoration: BoxDecoration(
          //       gradient: LinearGradient(
          //           begin: Alignment.centerLeft,
          //           end: Alignment.centerRight,
          //           colors: [const Color(0xFF6C7689), const Color(0xFF3A364B)])),
          color: Color(0xffcacac8),
          child: Stack(
            children: <Widget>[
              !isImage
                  ? Padding(
                      padding: const EdgeInsets.only(
                          right: 15.0, left: 15.0, top: 8.0, bottom: 8.0),
                      child: Text(
                        content,
                        style: TextStyle(color: Colors.black,fontSize: 15),
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.only(
                          right: 15.0, left: 15.0, top: 8.0, bottom: 8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          InkWell(
                            onTap: (){
                               Navigator.push(
                                  context,
                                  CupertinoPageRoute(
                                      builder: (context) => ViewImage(
                                            imageUrl:
                                                imageAddress,
                                          )),
                                );
                            },
                            child: ClipRRect(
                              
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5)),
                              child: Image.network(
                                imageAddress,
                                height: 130,
                                width: 130,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                           content == null?Text(
                              content,
                            ): Text(
                              content,
                               style: TextStyle(color: Colors.black,fontSize: 15),
                            ),
                        ],
                      ),
                    ),
              // Positioned(
              //   bottom: 1,
              //   right: 10,
              //   child: Text(
              //     time,
              //     style: TextStyle(
              //         fontSize: 10, color: Colors.black.withOpacity(0.6)),
              //   ),
              // )
            ],
          ),
        ),
      ),
    ));
  }
}
