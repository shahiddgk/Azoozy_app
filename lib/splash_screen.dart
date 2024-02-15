import 'dart:async';
import 'package:azoozyapp/network/http_manager.dart';
import 'package:azoozyapp/screens/drawer_screen.dart';
import 'package:azoozyapp/screens/home_screen.dart';
import 'package:azoozyapp/services/database_helper.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  String language = "English";
  DatabaseHelper databaseHelper = DatabaseHelper();

  @override
  void initState() {
    getSharedPreference();
    Timer(const Duration(seconds: 5), ()=>Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const HomeScreen())));

    super.initState();
  }

  Future<void> getSharedPreference() async {

    final user = await databaseHelper.getUser();

    if(user?.userid != null){
      HTTPManager().getUserDetails(user!.userid!).then((value) async {

        if(value.userSession != null) {
          await databaseHelper.setUser(context, value.userSession!);
        }
      }).onError((error, stackTrace) {

      });
    }

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