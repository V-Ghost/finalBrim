import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class ViewImage extends StatefulWidget {
  final String imageUrl;

  const ViewImage({Key key, this.imageUrl}) : super(key: key);

  @override
  _ViewImageState createState() => _ViewImageState();
}

class _ViewImageState extends State<ViewImage> {
  double w;
  @override
  Widget build(BuildContext context) {
    w = MediaQuery.of(context).size.width;
    return Scaffold(
     
      body: Center(
        child: Container(
            width: w,
            child: PhotoView(
              imageProvider: CachedNetworkImageProvider(
                  widget.imageUrl),
            )),
      ),
    );
  }
}
