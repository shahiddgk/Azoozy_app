import 'package:flutter/material.dart';
import 'package:translator/translator.dart';

class HomeScreenText extends StatefulWidget {
   HomeScreenText(this.text,this.onTap,this.closeButton,this.closeButtonTap,this.language,{Key? key}) : super(key: key);
  String? text;
  Function onTap;
  bool closeButton;
  Function closeButtonTap;
  String language;

  @override
  _HomeScreenTextState createState() => _HomeScreenTextState();
}

class _HomeScreenTextState extends State<HomeScreenText> {

  GoogleTranslator translator = GoogleTranslator();
  String output = "";
  String language = "";

  // String trans(String text) {
  //   translator
  //       .translate(text, to: "ar")
  //       .then((value) {
  //     setState(() {
  //       output = value.text;
  //     });
  //   });
  //   return output;
  // }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5),
      child: GestureDetector(

        onTap: () {
          widget.onTap();
        },

        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 10),
          alignment: Alignment.center,
          padding: EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
              border: Border.all(color: Colors.white,width: 3),
              borderRadius: BorderRadius.circular(20)
          ),
          child:  Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              mainAxisAlignment:widget.closeButton ? MainAxisAlignment.spaceBetween : MainAxisAlignment.center,
              children: [
                Expanded(child:Text( widget.text ?? '' ,style: const TextStyle(color: Colors.white))),

               widget.closeButton ?const Icon(Icons.clear,color: Colors.white,) : const Icon(Icons.clear,color: Color(0xFF000028),),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
