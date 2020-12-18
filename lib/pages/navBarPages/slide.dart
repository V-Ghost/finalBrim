import 'package:flutter/material.dart';

class Slide extends StatefulWidget {
  Slide({Key key}) : super(key: key);

  _SlideState createState() => _SlideState();
}

class _SlideState extends State<Slide> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Text("slide"),
    );
  }
}