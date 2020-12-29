import 'package:flutter/material.dart';
import 'package:myapp/services/brimService.dart';

class Slide extends StatefulWidget {
  Slide({Key key}) : super(key: key);

  _SlideState createState() => _SlideState();
}

class _SlideState extends State<Slide> {
  List<Color> color = [
    Colors.blue,
    Colors.amber,
    Colors.pink,
    Colors.purple,
    Colors.green,
    Colors.red,
    Colors.yellow
  ];

  @override
  void initState() {
    BrimService().getBroadcasts();
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: ListWheelScrollView.useDelegate(
        itemExtent: 250,
        // useMagnifier: true,
        diameterRatio: 2,
        // magnification: 1.5,
        childDelegate: ListWheelChildBuilderDelegate(
            builder: (BuildContext context, int index) {
              
          return Container(
              decoration: BoxDecoration(color: Colors.white, boxShadow: [
                BoxShadow(
                  color: Colors.black38,
                  offset: Offset(-1, 1),
                  blurRadius: 10,
                )
              ]),
              child: Column(
                children: [
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(30, 10, 0, 10),
                        child: Container(
                          height: 70,
                          width: 50,
                          child: Image(
                              image: AssetImage(
                            'lib/images/brim0.png',
                          )),
                        ),
                      ),
                      Expanded(
                        child: Container(),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 10, 30, 10),
                        child: Column(
                          children: [
                            Text("dataaa"),
                            Text("dataaa"),
                            Text(
                              "dataaa",
                              style: TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(15),
                    child: Expanded(
                      child: Text(
                          "dataaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa"),
                    ),
                  ),
                  Expanded(
                    child: Container(),
                  ),
                  ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: 10,
                      maxHeight: 40,
                    ),
                    child: OutlineButton(
                      borderSide: BorderSide(color: Colors.blue),
                      shape: new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(30.0)),
                      color: Colors.blue,

                      // width: 100,
                      child: Text(
                        'Send Comment',
                        style: TextStyle(color: Colors.blue),
                      ),
                      onPressed: () {},
                    ),
                  )
                ],
              ));
        }),
      ),
    ));
  }
}
