import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:myapp/pages/navBarPages/Chats/viewImage.dart';
// import 'package:simple_chat_application/Global/Colors.dart' as myColors;

class SendedMessageWidget extends StatelessWidget {
  final String content;
  final String imageAddress;
  final Color color;
  final bool isImage;
  const SendedMessageWidget({
    Key key,
    this.content,
    this.imageAddress,
    this.isImage,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.only( 
            right: 8.0, left: 50.0, top: 10, bottom: 4.0),
        child: ClipRRect(
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(15),
              bottomRight: Radius.circular(0),
              topLeft: Radius.circular(15),
              topRight: Radius.circular(15)),
          child: Material(
            
            child: Container(
              //color: Colors.green,
              decoration: BoxDecoration(color: color),
              // margin: const EdgeInsets.only(left: 10.0),
              child: Stack(children: <Widget>[
                !isImage
                    ? Padding(
                        padding: const EdgeInsets.only(
                            right: 15.0, left: 15.0, top: 8.0, bottom: 8.0),
                        child: Text(
                          content,
                          style: TextStyle(color: Colors.white,fontSize: 15),
                        ),
                      )
                    : Padding(
                        padding: const EdgeInsets.only(
                            right: 12.0, left: 15.0, top: 8.0, bottom: 8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  CupertinoPageRoute(
                                      builder: (context) => ViewImage(
                                            imageUrl: imageAddress,
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
                            ):  Text(
                              content,
                              style: TextStyle(color: Colors.white,fontSize: 15),
                            ),
                          ],
                        ),
                      ),
                // Positioned(
                //   bottom: 1,
                //   left: 10,
                //   // child: Text(
                //   //   time,
                //   //   style: TextStyle(
                //   //       fontSize: 10, color: Colors.black.withOpacity(0.6)),
                //   // ),
                // )
              ]),
            ),
          ),
        ),
      ),
    );
  }
}
