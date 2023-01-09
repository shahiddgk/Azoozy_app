import 'package:flutter/material.dart';

class MessageField extends StatefulWidget {
  MessageField(this._messageController,{Key? key}) : super(key: key);
  TextEditingController _messageController;
  @override
  _MessageFieldState createState() => _MessageFieldState();
}

class _MessageFieldState extends State<MessageField> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 10,),
        const Padding(
            padding: EdgeInsets.symmetric(horizontal: 5),
            child: Text("Message",style: TextStyle(fontSize: 18),)),
        const SizedBox(height: 5,),
        Card(
          color: Colors.white,
          elevation: 1,
          child: TextFormField(
            maxLines: 4,
            controller: widget._messageController,
            validator: (value) {
              if(value!.isEmpty) {
                return "Field Can't be empty";
              } else {
                return null;
              }
            },
            decoration: const InputDecoration(
                border: InputBorder.none,
                //hintText: 'Enter Message',
                contentPadding: EdgeInsets.only(left: 5,top: 2,bottom: 2,right: 5)
            ),
          ),
        ),
      ],
    );
  }
}
