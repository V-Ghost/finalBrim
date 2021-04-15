import 'package:flutter/material.dart';

class ReceivedComment extends StatelessWidget {
  final String content;
  final String imageAddress;
  final String comment;
  final bool isImage;
  const ReceivedComment({
    Key key,
    this.content,
    this.comment,
    this.isImage,
    this.imageAddress,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Padding(
      padding:
          const EdgeInsets.only(right: 75.0, left: 8.0, top: 8.0, bottom: 8.0),
      child: ClipRRect(
        borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(0),
            bottomRight: Radius.circular(15),
            topLeft: Radius.circular(15),
            topRight: Radius.circular(15)),
        child: Container(
            // decoration: BoxDecoration(
            //           borderRadius: BorderRadius.all(Radius.circular(20)),
            //           border: Border.all(
            //             color: Colors.black,
            //           ),
            //         ),
          // decoration: BoxDecoration(
          //     gradient: LinearGradient(
          //         begin: Alignment.centerLeft,
          //         end: Alignment.centerRight,
          //         colors: [Colors.grey[200], Colors.grey])
          //         ),
         color:  Color(0xffcacac8),
          // margin: const EdgeInsets.only(left: 10.0),
          child: Stack(
            children: <Widget>[
               Padding(
                      padding: const EdgeInsets.only(
                          right: 8.0, left: 8.0, top: 8.0, bottom: 15.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                            child: Container(
                              
                              child: Text(comment,
                              style: TextStyle(color: Colors.white),
                              ),)
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            content,
                          )
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
