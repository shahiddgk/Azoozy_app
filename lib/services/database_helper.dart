import 'package:azoozyapp/models/login_response_model.dart';
import 'package:azoozyapp/services/database.dart';
import 'package:azoozyapp/services/user_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

class DatabaseHelper{

  Database database = Database();



  Future<void> refreshUser(BuildContext context) async{
    final user = await database.getUser();
    if(user != null){
      UserProvider userProvider = Provider.of(context, listen: false);
      await userProvider.setUser(user);
    }
  }

  Future<void> setUser(BuildContext context, UserSession user)async{

    UserProvider userProvider = Provider.of(context, listen: false);
    await userProvider.setUser(user);
    await database.setUser(user);
  }



  Future<void> logoutUser(BuildContext context) async{
    await database.logoutUser();
    UserProvider userProvider = Provider.of(context, listen: false);
    await userProvider.removeUser();

  }


  Future<void> refreshLanguage(BuildContext context) async{
    final language = await database.getLanguage();
    UserProvider userProvider = Provider.of(context, listen: false);
    await userProvider.setLanguage(language);
  }

  Future<String> getLanguage() async => await database.getLanguage();

  Future<void> changeLanguage(String lang) async => await database.setLanguage(lang);
}