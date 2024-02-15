import 'package:azoozyapp/constants/Assets.dart';
import 'package:azoozyapp/network/http_manager.dart';
import 'package:azoozyapp/requests/change_password_reuest.dart';
import 'package:azoozyapp/screens/home_screen.dart';
import 'package:azoozyapp/services/user_provider.dart';
import 'package:azoozyapp/widgets/loader_widget.dart';
import 'package:azoozyapp/widgets/name_field.dart';
import 'package:azoozyapp/widgets/small_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:provider/provider.dart';
class ChangePassword extends StatefulWidget {
  const ChangePassword({super.key});

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  final TextEditingController _oldPasswordController = TextEditingController();
  final TextEditingController _newPasswordCntroller = TextEditingController();

  final _formKey = GlobalKey<FormState>();


  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<UserProvider>(context);
    final user = provider.user;
    final lang = provider.language;
    return Scaffold(
      appBar: AppBar(title:  Text(lang == 'eng' ? 'Change Password' : 'غير كلمة السر')),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: const Color.fromRGBO(189, 195, 199, 100),
        child: SingleChildScrollView(
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
                          child: Image.network(Assets.azoozyBlackImagePath))),
                ),
                const SizedBox(height: 20),
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
                                        child:  Text(lang == "eng" ? "Change your password by entering old password" : "قم بتغيير كلمة المرور الخاصة بك عن طريق إدخال كلمة المرور القديمة",style: TextStyle(fontSize: 18))),
                                    NameField(lang == "eng" ? "Old Password" : "كلمه السر",_oldPasswordController,lang == "eng" ? "Enter old Password" : "كلمه السر",true),
                                    NameField(lang == "eng" ? "New Password" : "كلمه السر",_newPasswordCntroller,lang == "eng" ? "Enter new Password" : "كلمه السر",true),
                                    SmallButton(lang == "eng" ? "Send" : "إرسال",(){
                                      _changePassword();
                                    }),
                                  ],
                                ),
                              ],
                            ),
                            _isLoading ?  Align(alignment: Alignment.center,child: LoaderWidget(false),) : Container(),
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
      final user = Provider.of<UserProvider>(context,listen: false).user;
      HTTPManager().changePassword(ChangePasswordRequestModel(userId: user.userid,oldPassword: _oldPasswordController.text,newPassword: _newPasswordCntroller.text)).then((value) {
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
          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=> HomeScreen()));
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
