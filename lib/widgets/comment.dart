import 'package:flutter/material.dart';

class Comment extends StatelessWidget {
  final String content;
  final String imageAddress;
  final String comment;
  final Color color;
  final bool isImage;
  const Comment({
    Key key,
    this.content,
    this.comment,
    this.imageAddress,
    this.isImage, this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.only(
            right: 8.0, left: 50.0, top: 4.0, bottom: 4.0),
        child: ClipRRect(
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(15),
              bottomRight: Radius.circular(0),
              topLeft: Radius.circular(15),
              topRight: Radius.circular(15)),
          child: Container(
             decoration: BoxDecoration(
               color: color),
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
                             style: TextStyle(color: Colors.black),
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
      ),
    );
  }
}
