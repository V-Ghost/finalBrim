import 'package:flutter/material.dart';
import 'package:myapp/Models/users.dart';
import 'package:provider/provider.dart';

class BroadCastComment extends StatefulWidget {
  @override
  _BroadCastCommentState createState() => _BroadCastCommentState();
}

class _BroadCastCommentState extends State<BroadCastComment> {
   Users u;

   @override
  void initState() {
    u = Provider.of<Users>(context, listen: false);
    print(u.userName);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
       body: Center(child: Text("ghana"),),
    );
  }
}