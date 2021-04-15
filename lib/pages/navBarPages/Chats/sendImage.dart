import 'package:flutter/material.dart';
import 'package:myapp/Models/message.dart';
import 'package:photo_view/photo_view.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:myapp/services/chatService.dart';
import 'package:form_field_validator/form_field_validator.dart';

class SendImage extends StatefulWidget {
  final Message m;
  final String messageId;
  final bool isParticipant1;
  const SendImage({Key key, this.m, this.messageId, this.isParticipant1})
      : super(key: key);

  _SendImageState createState() => _SendImageState();
}

class _SendImageState extends State<SendImage> {
  double w;
  final TextEditingController _textController = TextEditingController();
   final _formKey = GlobalKey<FormState>();
    final textValidator = MultiValidator([
    RequiredValidator(errorText: 'Enter Text'),
   
  ]);
  @override
  Widget build(BuildContext context) {
    w = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Stack(
        children: [
          Align(
            alignment: Alignment.bottomCenter,
            child: Form(
              key: _formKey,
              child: Material(
                elevation: 20.0,
                shadowColor: Colors.black,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  child: TextFormField(
                     validator: textValidator,
                    controller: _textController,
                    decoration: new InputDecoration(
                      suffixIcon: IconButton(
                        onPressed: () async {
                          if(_formKey.currentState.validate())
                          widget.m.message = _textController.text;
                          Fluttertoast.showToast(
                              msg: "The Image is sending......",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.CENTER,
                              timeInSecForIosWeb: 3,
                              backgroundColor: Colors.red,
                              textColor: Colors.white,
                              fontSize: 16.0);
                          var result = await ChatService().sendChatsFile(
                              widget.m,
                              widget.messageId,
                              widget.isParticipant1);
                             Navigator.pop(context);
                          if (result is String) {
                            Fluttertoast.showToast(
                                msg: "Unable to send message",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.CENTER,
                                timeInSecForIosWeb: 3,
                                backgroundColor: Colors.red,
                                textColor: Colors.white,
                                fontSize: 16.0);
                          } else {
                            //Navigator.pop(context);
                          }
                        },
                        icon: Icon(
                          Icons.send,
                          color: Colors.blue,
                        ),
                      ),
                      //prefixIcon: Icon(Icons.person),
                      labelText: "Enter text here",
                      enabledBorder: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20.0)),
                        borderSide: const BorderSide(
                          color: Colors.white,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        borderSide: BorderSide(color: Colors.white),
                      ),
                    ),
                    //validator: bioValidator,
                  ),
                ),
              ),
            ),
          ),
          Center(
            child: Container(
              width: w,
              child: Image.file(
                widget.m.image,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
