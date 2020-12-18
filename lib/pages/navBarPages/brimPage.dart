import 'package:myapp/Models/users.dart';
import 'package:myapp/pages/sendBrims.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BrimPage extends StatefulWidget {
  BrimPage({Key key}) : super(key: key);

  _BrimPageState createState() => _BrimPageState();
}

class _BrimPageState extends State<BrimPage> {
  Users u;

  @override
  void initState() {
    super.initState();
    u = Provider.of<Users>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            CupertinoPageRoute(builder: (context) => SendBrims()),
          );
        },
        child: Icon(Icons.send),
        backgroundColor: Colors.purple,
      ),
      body: u.userName == null ? Text("brims") : Text(u.userName),
    );
  }
}
