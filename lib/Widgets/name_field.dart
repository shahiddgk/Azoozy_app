import 'package:flutter/material.dart';

class NameField extends StatefulWidget {
   NameField(this.title,this._nameController,this.hint,this.passField,{Key? key}) : super(key: key);
  TextEditingController _nameController;
  String hint;
  bool passField;
   String title;

  @override
  _NameFieldState createState() => _NameFieldState();
}

class _NameFieldState extends State<NameField> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
            padding: EdgeInsets.symmetric(horizontal: 5),
            child: Text(widget.title,style: TextStyle(fontSize: 18),)),
        const SizedBox(height: 5,),
        Card(
          color: Colors.white,
          elevation: 1,
          child: TextFormField(
            obscureText: widget.passField,
            controller: widget._nameController,
            textAlign: TextAlign.start,
            validator: (value) {
              if(value!.isEmpty) {
                return "Field Can't be empty";
              } else {
                return null;
              }
            },
            decoration: InputDecoration(
                border: InputBorder.none,
                hintText: widget.hint,
                contentPadding: EdgeInsets.only(left: 5,top: 2,bottom: 2,right: 5)
            ),
          ),
        ),
      ],
    );
  }
}
