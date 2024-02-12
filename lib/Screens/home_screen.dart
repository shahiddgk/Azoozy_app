import 'package:azoozyapp/services/database_helper.dart';
import 'package:azoozyapp/widgets/home_drawer.dart';
import 'package:azoozyapp/widgets/loader_widget.dart';
import 'package:flutter/material.dart';
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  DatabaseHelper databaseHelper = DatabaseHelper();
  bool isLoading = false;
  String language = '';
  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() async{
    if(mounted){
      setState(() {
        isLoading = true;
      });
    }


    await databaseHelper.refreshUser(context);
    await databaseHelper.refreshLanguage(context);
    language = await databaseHelper.getLanguage();


    if(mounted){
      setState(() {
        isLoading = false;
      });
    }






  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("AZOOZY.COM",style: TextStyle(fontWeight: FontWeight.bold))),
      drawer: const HomeDrawer(),
      body: isLoading
          ? LoaderWidget(false)
          : Container(),
    );
  }
}
