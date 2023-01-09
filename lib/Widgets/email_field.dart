import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';

class EmailField extends StatefulWidget {
   EmailField(this.title,this._emailController,this.hint,{Key? key}) : super(key: key);
  TextEditingController _emailController;
  String hint;
  String title;
  @override
  _EmailFieldState createState() => _EmailFieldState();
}

class _EmailFieldState extends State<EmailField> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 10,),
         Padding(
            padding: EdgeInsets.symmetric(horizontal: 5),
            child: Text(widget.title,style: TextStyle(fontSize: 18),)),
        const SizedBox(height: 5,),
        Card(
          color: Colors.white,
          elevation: 1,
          child: TextFormField(
            validator: (email)=>EmailValidator.validate(email!) ? null : "Please Enter valid email",
            controller: widget._emailController,
            decoration:  InputDecoration(
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
