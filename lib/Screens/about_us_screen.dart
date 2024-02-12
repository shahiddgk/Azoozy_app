import 'package:azoozyapp/network/http_manager.dart';
import 'package:azoozyapp/services/user_provider.dart';
import 'package:azoozyapp/widgets/details_text.dart';
import 'package:azoozyapp/widgets/loader_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:provider/provider.dart';


class AboutUsScreen extends StatefulWidget {
  const AboutUsScreen({super.key});

  @override
  State<AboutUsScreen> createState() => _AboutUsScreenState();
}

class _AboutUsScreenState extends State<AboutUsScreen> {
  bool _isLoading = false;
  String data = '';

  @override
  void initState() {
    super.initState();
    getAboutData();
  }



  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<UserProvider>(context);
    final lang = provider.language;
    return Scaffold(
      appBar: AppBar(
        title:  Text( lang == "eng" ? "About Us" : "معلومات عنا"),
      ),
      body: Container(
          color: const Color.fromRGBO(189, 195, 199, 100),
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: _isLoading
              ? LoaderWidget(false)
              : DetailsText(data)
        ),
    );
  }

  void getAboutData() {

    setState(() {
      _isLoading = true;
    });

    final lang = Provider.of<UserProvider>(context,listen: false).language;

    HTTPManager().getAboutUs(lang == 'eng' ? 'English' : 'Arabic' ).then((value) {

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
}
