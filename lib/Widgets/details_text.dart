import 'package:azoozyapp/constants/Assets.dart';
import 'package:flutter/material.dart';

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
                      child: Image.network(Assets.azoozyBlackImagePath))),
            ),
            const SizedBox(height: 20,),
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Text(widget.details)),
          ],
        ),
      ),
    );
  }
}
