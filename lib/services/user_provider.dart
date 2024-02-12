import 'package:azoozyapp/models/login_response_model.dart';
import 'package:flutter/cupertino.dart';

class UserProvider extends ChangeNotifier{
  UserSession _user = UserSession();
  String? _language;

  UserSession get user => _user;

  String get language => _language!;

  Future<void> setLanguage(String language) async{
    _language = language;
    notifyListeners();
  }

  Future<void> setUser(UserSession user) async{
    _user = user;
    notifyListeners();
  }

  Future<void> removeUser() async{
    _user = UserSession();
    notifyListeners();
  }
}


