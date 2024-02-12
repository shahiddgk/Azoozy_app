
import 'dart:convert';

import 'package:azoozyapp/models/login_response_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Database{

  Future<void> setLanguage(String lang) async{
    print('Changing Language in Database $lang');
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString('language', lang);
  }


  Future<String> getLanguage()async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? language = preferences.getString('language');
    print('Getting Language ====> $language');
    return language ?? 'arb';
  }


  Future<void> setUser(UserSession user) async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.setString('user', jsonEncode(user.toJson()));
  }


  Future<void> logoutUser()async{
    print('Logging Out User');
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.setString('user', '');
  }





  Future<UserSession?> getUser()async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final userData = preferences.getString('user');
    if (userData != null && userData.isNotEmpty) {
      Map<String, dynamic> map = jsonDecode(userData);
      return UserSession.fromJson(map);
    }
    return null;
  }
}


