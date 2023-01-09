import 'package:flutter/material.dart';

// ignore: must_be_immutable
class SmallButton extends StatefulWidget {
  SmallButton(this.title,this._onPressed,{Key? key}) : super(key: key);

  String title;
  Function _onPressed;

  @override
  _SmallButtonState createState() => _SmallButtonState();
}

class _SmallButtonState extends State<SmallButton> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 10,),
        Align(
          alignment: Alignment.center,
          child: ElevatedButton(
            onPressed: (){
              widget._onPressed();
            },style: ButtonStyle(
            // backgroundColor: MaterialStateProperty.all<Color>(const Color(
            //     0xFFC1272D)),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                    // side: const BorderSide(color: Color(
                    //     0xFFC1272D))
                  )
              )
          ),
            child:  Text(widget.title),),
        )
      ],
    );
  }
}
