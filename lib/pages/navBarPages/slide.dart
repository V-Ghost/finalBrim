import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:myapp/Models/broadcastMessage.dart';
import 'package:myapp/Models/users.dart';
import 'package:myapp/services/brimService.dart';
import 'package:myapp/widgets/raisedGradientButton.dart';

class Slide extends StatefulWidget {
  Slide({Key key}) : super(key: key);

  _SlideState createState() => _SlideState();
}

class _SlideState extends State<Slide> {
  List<BroadCastMessage> broadcasts = [];
  List<Widget> w = [];
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
    // BrimService().getBroadcasts().then((onValue){
    //  onValue.forEach((f){
    //   print(f.message);
    //  });
    // });
    // TODO: implement initState
    super.initState();
  }

  Future<void> getBroadcast() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    broadcasts = await BrimService().getBroadcasts();

    broadcasts.forEach((b) async {
      // await BrimService().retrieveUserInfo(b.user);
      print(position.latitude);
      print(b.latitiude);
      // double distanceInMeters = Geolocator.distanceBetween(
      //     position.latitude, position.longitude, b.latitiude, b.longitude);
      Widget x = Container(
          decoration: BoxDecoration(color: Colors.white, boxShadow: [
            BoxShadow(
              color: Colors.black38,
              offset: Offset(-1, 1),
              blurRadius: 10,
            )
          ]),
          child: FutureBuilder<Users>(
              future: BrimService().retrieveUserInfo(b.user),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Column(
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
                                Text(
                                  "Bio : ${snapshot.data.bio}",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  "100 km from You",
                                  style: TextStyle(color: Colors.grey),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.all(15),
                        child: Text(
                          "${b.message}",
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                      Expanded(
                        child: Container(),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                            minHeight: 20,
                            maxHeight: 50,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: RaisedGradientButton(
                                width: 150,
                                child: Text(
                                  'Send Comment',
                                  style: TextStyle(color: Colors.white),
                                ),
                                gradient: LinearGradient(
                                  colors: <Color>[
                                    Colors.blueAccent,
                                    Colors.blue
                                  ],
                                ),
                                onPressed: () {}),
                          ),
                        ),
                      )
                    ],
                  );
                }
                if (snapshot.hasError) {
                  return Center(
                    child: Icon(Icons.error),
                  );
                }
                // if(snapshot.connectionState == ConnectionState.waiting){
                //      CircularProgressIndicator();
                // }

                return Center(child: CircularProgressIndicator());
              }));
      w.add(x);
    });

    return broadcasts;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            // Add your onPressed code here!
          },
          child: Icon(Icons.remove_red_eye),
          backgroundColor: Colors.purple,
        ),
        body: SafeArea(
          child: FutureBuilder(
              future: getBroadcast(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return ListWheelScrollView(
                    physics: BouncingScrollPhysics(),
                    itemExtent: 250,
                    // useMagnifier: true,
                    diameterRatio: 2,
                    // magnification: 1.5,
                    children: w,
                  );
                }
                if (snapshot.hasError) {
                  return Center(
                    child: Icon(Icons.error),
                  );
                }
                // if(snapshot.connectionState == ConnectionState.waiting){
                //      CircularProgressIndicator();
                // }

                return Center(child: CircularProgressIndicator());
              }),
        ));
  }
}
