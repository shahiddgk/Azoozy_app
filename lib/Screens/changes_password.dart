
import 'package:azoozy_app/Screens/drawer_screen.dart';
import 'package:azoozy_app/Widgets/email_field.dart';
import 'package:azoozy_app/Widgets/loader_widget.dart';
import 'package:azoozy_app/Widgets/name_field.dart';
import 'package:azoozy_app/Widgets/small_button.dart';
import 'package:azoozy_app/models/login_response_model.dart';
import 'package:azoozy_app/network/http_manager.dart';
import 'package:azoozy_app/requests/log_in_request_Model.dart';
import 'package:azoozy_app/requests/sign_up_request_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:translator/translator.dart';

import '../requests/change_password_reuest.dart';
import '../requests/forgot_password_request_model.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({Key? key}) : super(key: key);

  @override
  _ChangePasswordState createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {

  final TextEditingController _oldPasswordController = TextEditingController();
  final TextEditingController _newPasswordCntroller = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  late String appBarTitle;

  String language1 = "English";
  bool _isUserDataLoading = false;
  bool _isLoading = false;

  String output2 = "";
  String userId = "";

  @override
  void initState() {
    // TODO: implement initState

    getSharedPrefence();
    super.initState();
  }

  Future<void> getSharedPrefence() async {
    setState(() {
      //_isUserDataLoading = true;
    });
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    setState(() {

      language1 = sharedPreferences.getString("Language")!;
      userId = sharedPreferences.getString("userid")!;
      _isUserDataLoading = false;
      appBarTitle = language1 == "English" ?"Change Password" : "غير كلمة السر";
    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title:  Text(appBarTitle),),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: const Color.fromRGBO(189, 195, 199, 100),
        child: _isUserDataLoading ? const CircularProgressIndicator() : SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Container(
            margin: EdgeInsets.only(top: MediaQuery.of(context).size.height/14),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 20,left: 10),
                  child: Align(
                      alignment: Alignment.topLeft,
                      child: Container(
                          width: MediaQuery.of(context).size.width/2,
                          child: Image.network("https://azoozy.com/assets/images/azoozyblack.png"))),
                ),
                const SizedBox(height: 20,),
                Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Form(
                        key: _formKey,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Column(
                              children: [
                                Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                            padding: EdgeInsets.symmetric(horizontal: 5,vertical: 5),
                                            child:  Text(language1 == "English" ? "Change your password by entering old password" : "قم بتغيير كلمة المرور الخاصة بك عن طريق إدخال كلمة المرور القديمة",style: TextStyle(fontSize: 18))),
                                        NameField(language1 == "English" ? "Old Password" : "كلمه السر",_oldPasswordController,language1 == "English" ? "Enter old Password" : "كلمه السر",true),
                                        NameField(language1 == "English" ? "New Password" : "كلمه السر",_newPasswordCntroller,language1 == "English" ? "Enter new Password" : "كلمه السر",true),
                                        SmallButton(language1 == "English" ? "Send" : "إرسال",(){
                                          _changePassword();
                                        }),
                                      ],
                                    ),
                              ],
                            ),
                            _isLoading ?  Align(alignment: Alignment.center,child: LoaderWidget(true),) : Container(),
                          ],
                        )
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _changePassword() {
    if(_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      HTTPManager().changePassword(ChangePasswordRequestModel(userId: userId,oldPassword: _oldPasswordController.text,newPassword: _newPasswordCntroller.text)).then((value) {
        print("REGISTER USER");
        print(value);
        setState(() {
          _isLoading = false;
          if(value['message']!= null ) {
            showToast(
              value['message'].toString(),
              textStyle: TextStyle(color: Colors.black),
              context: context,
              isHideKeyboard: true,
              toastHorizontalMargin: 10,
              backgroundColor: Colors.green,
              reverseAnimation: StyledToastAnimation.fade,
              position: StyledToastPosition.top,
              duration: const Duration(seconds: 3),

            );
          } else {
            showToast(
              value['error'].toString(),
              textStyle: TextStyle(color: Colors.black),
              context: context,
              isHideKeyboard: true,
              toastHorizontalMargin: 10,
              backgroundColor: Colors.red,
              reverseAnimation: StyledToastAnimation.fade,
              position: StyledToastPosition.top,
              duration: const Duration(seconds: 3),

            );
          }
          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>DrawerScreen()));
        });
      }).catchError((e) {
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
        print(e);
      });
    }
  }
}
