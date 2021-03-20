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
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [Colors.grey[200], Colors.grey])),
          //color: Colors.green,
          // margin: const EdgeInsets.only(left: 10.0),
          child: Stack(children: <Widget>[
            !isImage
                ? Padding(
                    padding: const EdgeInsets.only(
                        right: 12.0, left: 23.0, top: 8.0, bottom: 20.0),
                    child: Text(
                      content,
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.only(
                        right: 12.0, left: 23.0, top: 8.0, bottom: 15.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                          child: Image.asset(
                            imageAddress,
                            height: 130,
                            width: 130,
                            fit: BoxFit.cover,
                          ),
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
            Positioned(
              bottom: 1,
              left: 23.0,
              child: Container(
                //constraints: BoxConstraints(minWidth: 30),
                //padding: EdgeInsets.all(5),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5), color: Colors.blue),
                child: Text(
                  comment,
                  style: TextStyle(fontSize: 15, color: Colors.white),
                ),
              ),
            )
          ]),
        ),
      ),
    ));
  }
}
