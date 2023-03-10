import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

// ignore: must_be_immutable
class DetailsText extends StatefulWidget {
  DetailsText(this.details,{Key? key}) : super(key: key);

  String details;

  @override
  _DetailsTextState createState() => _DetailsTextState();
}

class _DetailsTextState extends State<DetailsText> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: MediaQuery.of(context).size.height/14),
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 20,left: 10),
              child: Align(
                  alignment: Alignment.topLeft,
                  child: Container(
                      width: MediaQuery.of(context).size.width/2,
                      child: Image.network("https://azoozy.com/assets/images/azoozyblack.png"))),
            ),
            const SizedBox(height: 20,),
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Html(data: widget.details,)),
          ],
        ),
      ),
    );
  }
}
