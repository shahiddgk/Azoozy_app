import 'dart:async';

import 'package:azoozy_app/Screens/drawer_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  String language = "Language";

  @override
  void initState() {

    getSharedPrefence();

    Timer(const Duration(seconds: 5),
            ()=>Navigator.pushReplacement(context,
            MaterialPageRoute(builder:
                (context) =>
            const DrawerScreen()
            )
        )
    );

    super.initState();
  }

  Future<void> getSharedPrefence() async {
    print("Splash Shared Preference");
    print(language);

    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    setState(() {
      language = sharedPreferences.getString("Language") ?? 'English';
      print("Splash Shared Preference");
      print(language);
    });

    // if(language != "English" || language != "Arabic") {
    //   print("Splash Shared Preference1");
    //   print(language);
    //   setState(() {
    //     sharedPreferences.setString("Language", "English");
    //   });
    //
    // }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: const Color(0xFF000028),
        child:  const Align(
          alignment: Alignment.center,
          child: Text("AZOOZY.COM",style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 40,
            color: Colors.white
          ),),
        ),
      ),
    );
  }

}