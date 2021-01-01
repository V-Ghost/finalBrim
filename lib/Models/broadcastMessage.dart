class BroadCastMessage {
  String _message;
  double _longitude;
  double _latitiude;
  DateTime _time;
  String _user;


BroadCastMessage();
  String get user => _user;

  set user(String value) {
    _user = value;
  }

  DateTime get time => _time;

  set time(DateTime value) {
    _time = value;
  }

  double get longitude => _longitude;

  set longitude(double value) {
    _longitude = value;
  }

  double get latitiude => _latitiude;

  set latitiude(double value) {
    _latitiude = value;
  }

  String get message => _message;

  set message(String value) {
    _message = value;
  }

  BroadCastMessage.fromMap(Map<String, dynamic> data) {
    _longitude = data['longitud'];

    _latitiude = data['latittude'];

    _message = data['message'];
    _user = data['user'];
    _time = data['time'];
  }
}
