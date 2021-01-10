import 'dart:collection';
import 'dart:ui' as ui;
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:async';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:myapp/Models/users.dart';
import 'package:myapp/pages/sendBrims.dart';
import 'package:myapp/services/database.dart';
import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:myapp/widgets/raisedGradientButton.dart';
import 'package:provider/provider.dart';

class MapPage extends StatefulWidget {
  MapPage({Key key}) : super(key: key);

  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  bool isLocationServiceEnabled;
  LocationPermission permission;
  GoogleMapController _mapController;
  Map<dynamic, dynamic> users;
  Set<Marker> _markers = HashSet<Marker>();
  BitmapDescriptor _markerIcon;
  Users u;
  User user;
  String _mapStyle;
  double height;
  double p;
  double width;
  static var _initialPosition;
  double h;
  static var _lastMapPosition = _initialPosition;
  bool hide;
  double opacity;
  bool details;
  String name;
  String bio;
  String user2;
  String gender;
  @override
  void initState() {
    u = Provider.of<Users>(context, listen: false);
    h = 80;
    p = 0;
    name = "";
    bio = "";
    opacity = 0;
    details = false;
    hide = true;
    user2 = "";
    print("eii1");
    print(u.phoneNumber);
    user = FirebaseAuth.instance.currentUser;
    print("eii1");
    _style();
    _getUserLocation();

    // _getNearbyUsers();

    super.initState();
  }

  void _style() async {
    _mapStyle = await rootBundle.loadString('assets/json_assets/map_style.txt');
  }

  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))
        .buffer
        .asUint8List();
  }

  // static final CameraPosition _kGooglePlex = CameraPosition(
  //   target: LatLng(u.position.latitiude, u.position.longitude),
  //   zoom: 14.4746,
  // );
  Route _createRoute() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => SendBrims(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var begin = Offset(0.0, 1.0);
        var end = Offset.zero;
        var curve = Curves.ease;

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }

  void _onMapCreated(GoogleMapController controller) async {
    controller.setMapStyle(_mapStyle);
    _mapController = controller;

    users = await DatabaseService(uid: user.uid).getNearbyUsers();
    //   users.forEach((key,values) async {
    //  var check =  await DatabaseService(uid: user.uid).doesBrimMessageExistAlready(key);
    //   print("it's true");
    //    print(check);
    //  if(check == true){
    //    print("it's true");
    //    print(check);
    //    users.remove(key);
    //  }
    //   });
    print("noo");
    final Uint8List markerIcon =
        await getBytesFromAsset('lib/images/brimPointer.png', 100);
    users.forEach((key, value) async {
      var f = await DatabaseService().retrieveOtherInfo(users);
      //  var check =  await DatabaseService(uid: user.uid).doesBrimMessageExistAlready(key);
      print(f[key].userName);
      //  String name = u[key].userName.toString();
      //  String bio = u[key].bio.toString();

      // print(value.position.latitiude);
      _markers.add(
        Marker(
            markerId: MarkerId(key),
            onTap: () async {
              // print(value.userName.toString());
              // print(value.bio.toString());
              _mapController.animateCamera(CameraUpdate.newLatLngZoom(
                  LatLng(value.position.latitiude, value.position.longitude),
                  15));
              setState(() {
                name = f[key].userName.toString();
                bio = f[key].bio.toString();
                details = true;
                user2 = key.toString();
                gender = f[key].gender.toString();
              });
              print(f[key].gender.toString());
              print("key");
              // _mapController.moveCamera(CameraUpdate.newLatLngZoom(LatLng(value.position.latitiude, value.position.longitude),15));
            },
            position:
                LatLng(value.position.latitiude, value.position.longitude),
            // infoWindow: InfoWindow(
            //   title: value.userName.toString(),
            //   snippet:value.bio.toString(),
            // ),
            icon: BitmapDescriptor.fromBytes(markerIcon)),
      );
    });
    if (mounted) {
      setState(() {});
    }
    ;
  }

  static final CameraPosition _kLake = CameraPosition(
      bearing: 192.8334901395799,
      target: LatLng(37.43296265331129, -122.08832357078792),
      tilt: 59.440717697143555,
      zoom: 19.151926040649414);

  void _setMarkerIcon() async {
    _markerIcon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(size: Size(1, 1)), 'lib/images/brimPointer.png');
  }

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }

  void _getUserLocation() async {
    print("get");
    isLocationServiceEnabled = await Geolocator.isLocationServiceEnabled();

    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    if (isLocationServiceEnabled) {
      if (mounted) {
        setState(() {
          _initialPosition = CameraPosition(
            target: LatLng(position.latitude, position.longitude),
            zoom: 12.4746,
          );
          //print('${placemark[0].name}');
        });
      }
    } else {
      permission = await Geolocator.requestPermission();
      setState(() {});
    }
    //List<Placemark> placemark = await Geolocator.placemarkFromCoordinates(position.latitude, position.longitude);
  }

  // _onCameraMove(CameraPosition position) {
  //   _lastMapPosition = position.target;
  // }

  // void _getNearbyUsers() async {

  //   //  users = await DatabaseService().retrieveOtherInfo(users);
  //   //  print(users);
  //    print(users["t3MYcrmwZ9VemLCSOPRI2bOxD9s2"].position.longitude);

  //   //  print(users["t3MYcrmwZ9VemLCSOPRI2bOxD9s2"].bio);
  //   print("OO");
  //   // print(users);
  // }

  @override
  Widget build(BuildContext context) {
    print("eii");
    // print(u.position.latitiude);
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () {
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              backgroundColor: Colors.transparent,
              builder: (context) => Container(
                height: MediaQuery.of(context).size.height * 0.8,
                decoration: new BoxDecoration(
                  color: Colors.white,
                  borderRadius: new BorderRadius.only(
                    topLeft: const Radius.circular(25.0),
                    topRight: const Radius.circular(25.0),
                  ),
                ),
                child: ListView(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 25, bottom: 25, left: 110, right: 110),
                      child: Material(
                        elevation: 20.0,
                        shadowColor: Colors.black,
                        child: Padding(
                          padding: EdgeInsets.all(10),
                          child: CircleAvatar(
                            radius: 80,
                            backgroundColor: Colors.grey,
                            child: ClipOval(
                              child: SizedBox(
                                  width: 180.0,
                                  height: 180.0,
                                  child: GestureDetector(
                                    child: Image.network(
                                      "${u.picture}",
                                      fit: BoxFit.cover,
                                    ),
                                  )),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 40,right: 40),
                      child: OutlineButton(
                        onPressed: (){},
                        borderSide: BorderSide(color: Colors.blue),
                        shape: new RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(30.0)),
                        color: Colors.blue,
                        // height: 30,
                        // width: 100,
                        child: Text(
                          'Send Brim',
                          style: TextStyle(color: Colors.blue),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
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
      body: _initialPosition == null
          ? Container(
              child: Center(
                child: Text(
                  'loading map..',
                  style: TextStyle(
                      fontFamily: 'Avenir-Medium', color: Colors.grey[400]),
                ),
              ),
            )
          : Stack(
              children: [
                GoogleMap(
                  mapType: MapType.normal,
                  initialCameraPosition: _initialPosition,
                  myLocationEnabled: true,
                  onMapCreated: _onMapCreated,
                  zoomGesturesEnabled: true,
                  markers: _markers,
                  onTap: (LatLng position) {
                    setState(() {
                      details = false;
                      _mapController.animateCamera(CameraUpdate.zoomOut());
                    });
                  },
                ),
                Visibility(
                  visible: details,
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          h = 110;
                          hide = false;
                          opacity = 1;
                          p = 8;
                        });
                      },
                      child: AnimatedContainer(
                        duration: Duration(milliseconds: 1000),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black38,
                                offset: Offset(-1, 1),
                                blurRadius: 10,
                              )
                            ]),
                        width: width,
                        margin:
                            EdgeInsets.only(right: 15, left: 15, bottom: 20),
                        // color: Colors.white70,
                        height: h,
                        child: Row(
                          children: [
                            Padding(
                              padding: EdgeInsets.only(
                                  top: 10, bottom: 10, left: 30, right: 10),
                              child: Image(
                                  width: 50,
                                  height: 50,
                                  image: AssetImage(
                                    'lib/images/brim0.png',
                                  )),
                            ),
                            Expanded(
                              child: Column(
                                children: [
                                  Expanded(
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Container(),
                                        ),
                                        Text(
                                          "$name",
                                          style: TextStyle(
                                            fontSize: 17,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        gender == "Male"
                                            ? Icon(Icons.person)
                                            : Icon(Icons.pregnant_woman),
                                        Expanded(
                                          child: Container(),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      "$bio",
                                      style: TextStyle(
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: EdgeInsets.only(bottom: 10),
                                      child: Visibility(
                                        visible: !hide,
                                        child: AnimatedOpacity(
                                          duration:
                                              Duration(milliseconds: 6000),
                                          opacity: opacity,
                                          child: OutlineButton(
                                              borderSide: BorderSide(
                                                  color: Colors.blue),
                                              shape: new RoundedRectangleBorder(
                                                  borderRadius:
                                                      new BorderRadius.circular(
                                                          30.0)),
                                              color: Colors.blue,
                                              // height: 30,
                                              // width: 100,
                                              child: Text(
                                                'Send Brim',
                                                style: TextStyle(
                                                    color: Colors.blue),
                                              ),
                                              // gradient: LinearGradient(
                                              //   colors: <Color>[
                                              //     Colors.purple[800],
                                              //     Colors.purple
                                              //   ],
                                              // ),
                                              onPressed: () {
                                                Navigator.of(context)
                                                    .push(PageRouteBuilder(
                                                  pageBuilder: (context,
                                                          animation,
                                                          secondaryAnimation) =>
                                                      SendBrims(
                                                    broadcast: false,
                                                    userId: user2,
                                                  ),
                                                  transitionsBuilder: (context,
                                                      animation,
                                                      secondaryAnimation,
                                                      child) {
                                                    var begin =
                                                        Offset(0.0, 1.0);
                                                    var end = Offset.zero;
                                                    var curve = Curves.ease;

                                                    var tween = Tween(
                                                            begin: begin,
                                                            end: end)
                                                        .chain(CurveTween(
                                                            curve: curve));

                                                    return SlideTransition(
                                                      position: animation
                                                          .drive(tween),
                                                      child: child,
                                                    );
                                                  },
                                                ));
                                              }),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
