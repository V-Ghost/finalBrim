import 'package:myapp/Models/brim.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';

class BrimService {
  final String uid;
  BrimService({this.uid});

  Future<dynamic> sendBrim(Brim b) async {
    
  }

  Future<dynamic> broadcastBrim(Brim b) async {
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      final coordinates =
          new Coordinates(position.latitude, position.longitude);
      var addresses =
          await Geocoder.local.findAddressesFromCoordinates(coordinates);
      var first = addresses.first;
      String id = DateTime.now().millisecondsSinceEpoch.toString() + uid;
      final databaseReference =
          FirebaseDatabase.instance.reference().child("brims");
      await databaseReference.child(id).set({
        'message': '${b.message}',
        'country': '${first.countryName}',
        'AdminArea': '${first.adminArea}',
        'subadminArea': '${first.adminArea}',
        'thoroughfare': '${first.thoroughfare}',
        'date': ServerValue.timestamp,
        'user': '${b.userId}'
      }).then((_) {
        return null;
      });
    } catch (error) {
      return error;
    }
  }

  Future<void> retrieveBrims() async {
    Brim d1;
    final databaseReference =
        FirebaseDatabase.instance.reference().child("brims");
    databaseReference.once().then((DataSnapshot snapshot) {});
  }
}
