import 'package:azoozy_app/Screens/drawer_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../network/api_urls.dart';

class HyperPayPayment extends StatefulWidget {
   HyperPayPayment(this.userId,this.email,this.language,{Key? key}) : super(key: key);

  String userId;
  String email;
  String language;


  @override
  _HyperPayPaymentState createState() => _HyperPayPaymentState();
}

class _HyperPayPaymentState extends State<HyperPayPayment> {

  @override
  initState(){
    super.initState();
    print('User ID :: ${widget.userId}');
    print('Email :: ${widget.email}');
    print('Language :: ${widget.language}');
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        child: WebView(
          initialUrl: "${ApplicationURLs.API_HYPER_PAY_PAYMENT}?user_id=${widget.userId}&email=${widget.email}&language=${widget.language}",
          javascriptMode: JavascriptMode.unrestricted,
          onPageStarted: (url) {
            print("Page Started Url");
            if(url.contains("load_models")) {
              _settingSubStatus();
            }
            print(url);
          },
          onPageFinished: (url) {
            print("Page Finished Url");
            print(url);
          },
          onProgress: (prog) {
            print("Progress of Url");
            print(prog);
          },
        ),
      ),
    );
  }

  void _settingSubStatus() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      sharedPreferences.setString("subscription", "sub");
    });
    Navigator.of(context).pop();
    // ignore: use_build_context_synchronously
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>const DrawerScreen()));
  }
}
