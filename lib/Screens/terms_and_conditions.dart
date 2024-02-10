import 'package:azoozy_app/Widgets/details_page.dart';
import 'package:azoozy_app/Widgets/loader_widget.dart';
import 'package:azoozy_app/network/http_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:translator/translator.dart';

class TermsAndCondition extends StatefulWidget {
  const TermsAndCondition({Key? key}) : super(key: key);

  @override
  _TermsAndConditionState createState() => _TermsAndConditionState();
}

class _TermsAndConditionState extends State<TermsAndCondition> {

  GoogleTranslator translator = GoogleTranslator();
  String language1 = "English";
  bool _isUserDataLoading = true;
  bool _isLoading = true;
  String data = "";

  String output2 = "";

  String trans(String text) {
    translator
        .translate(text, to: "ar")
        .then((value) {
      setState(() {
        output2 = value.text;
      });
    });
    return output2;
  }

  @override
  void initState() {
    getSharedPrefence();

    Future.delayed(const Duration(seconds: 3),() {
      getTermsData();
    });
    super.initState();
  }

  void getTermsData() {
    print('Get Terms data ==========>');
    setState(() {
      _isLoading = true;
    });

    HTTPManager().getTerms(language1).then((value) {

      print(value);
      setState(() {
        _isLoading = false;
        data = value;
      });

    }).catchError((e) {
      print(e);
      setState(() {
        _isLoading = false;
        showToast(
          e.toString(),
          textStyle: TextStyle(color: Colors.black),
          context: context,
          isHideKeyboard: true,
          toastHorizontalMargin: 10,
          backgroundColor: Colors.red,
          reverseAnimation: StyledToastAnimation.fade,
          position: StyledToastPosition.top,
          duration: const Duration(seconds: 3),

        );
      });
    });

  }

  Future<void> getSharedPrefence() async {
    setState(() {
      _isUserDataLoading = true;
    });
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    setState(() {

      language1 = sharedPreferences.getString("Language")!;
      _isUserDataLoading = false;
    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:  Text(language1 == "English" ? "Term & condition" :"الأحكام والشروط"),
      ),
      // ignore: avoid_unnecessary_containers
      body: Container(
          color: const Color.fromRGBO(189, 195, 199, 100),
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: _isLoading && _isUserDataLoading ?
           Align(alignment: Alignment.center,child: LoaderWidget(true),)
              : DetailsText(data)),
    );
  }
}
