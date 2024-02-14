import 'package:azoozyapp/constants/Assets.dart';
import 'package:azoozyapp/constants/app_colors.dart';
import 'package:azoozyapp/network/http_manager.dart';
import 'package:azoozyapp/requests/forgot_password_request_model.dart';
import 'package:azoozyapp/requests/log_in_request_Model.dart';
import 'package:azoozyapp/requests/sign_up_request_model.dart';
import 'package:azoozyapp/screens/home_screen.dart';
import 'package:azoozyapp/services/database_helper.dart';
import 'package:azoozyapp/services/user_provider.dart';
import 'package:azoozyapp/widgets/loader_widget.dart';
import 'package:azoozyapp/widgets/name_field.dart';
import 'package:azoozyapp/widgets/small_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:provider/provider.dart';

import '../widgets/email_field.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _cityNameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  DatabaseHelper databaseHelper =  DatabaseHelper();

  final _formKey = GlobalKey<FormState>();



  bool _registerVisibility = true;
  bool _loginVisibility = false;
  bool _forgotPasswordVisibility = false;

  String appBarTitle = "Register";
  bool _isLoading = false;


  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final provider = Provider.of<UserProvider>(context);
    final lang = provider.language;
    return Scaffold(
      appBar: AppBar(title:  Text(lang == 'eng' ? appBarTitle : 'تسجيل حساب')),
      body: Container(
        height: size.height,
        width: size.width,
        color: AppColors.primaryBackgroundColor,
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Container(
            margin: EdgeInsets.only(top: MediaQuery.of(context).size.height/14),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.only(top: 20,left: 10),
                  child: Align(
                      alignment: Alignment.topLeft,
                      child: SizedBox(
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
                                Visibility(
                                    visible: _registerVisibility,
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                            padding: EdgeInsets.symmetric(horizontal: 5,vertical: 5),
                                            child:  Text(lang == "eng" ? "Register an account" : "تسجيل حساب",style: const TextStyle(fontSize: 18))),
                                        NameField(lang == "eng" ? "Name" : "اسم",_nameController,lang == "eng" ? "Enter Name" : "أدخل اسمك باللغة الإنجليزية",false),
                                        EmailField(lang == "eng" ? "Email" : "أدخل بريدك الإلكتروني باللغة الإنجليزية",_emailController,lang == "eng" ? "Enter email" : "أدخل اسمك باللغة الإنجليزية"),
                                        NameField(lang == "eng" ? " Password" : "كلمه السر",_passwordController,lang == "eng" ? "Enter Password" : "كلمه السر",true),
                                        NameField(lang == "eng" ? "City Name" : "اكتب اسم المدينة باللغة الإنجليزية" ,_cityNameController,lang == "eng" ? "Enter City Name" : "اكتب اسم المدينة باللغة الإنجليزية",false),
                                        SmallButton(lang == "eng" ? "Register" : "تسجيل جديد",(){
                                          _registerUser();
                                        }),
                                      ],
                                    )),
                                Visibility(
                                    visible: _loginVisibility,
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                            padding: EdgeInsets.symmetric(horizontal: 5,vertical: 5),
                                            child: Text(lang == "eng" ? "Type your username and password" : "البريد الإلكتروني",style: TextStyle(fontSize: 18))),
                                        EmailField(lang == "eng" ? "Email" : "البريد الإلكتروني",_emailController,lang == "eng" ? "Enter email" : "أدخل اسمك باللغة الإنجليزية"),
                                        NameField(lang == "eng" ? " Password" : "كلمه السر",_passwordController,lang == "eng" ? "Enter Password" : "كلمه السر",true),
                                        SmallButton(lang == "eng" ? "Login" : "تسجيل الدخول",(){
                                          _loginUser();
                                        }),
                                      ],
                                    )),
                                Visibility(
                                    visible: _forgotPasswordVisibility,
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                            padding: EdgeInsets.symmetric(horizontal: 5,vertical:5),
                                            child: Text(lang == "eng" ? "Type your email" : "أدخل بريدك الإلكتروني باللغة الإنجليزية",style: TextStyle(fontSize: 18))),
                                        EmailField(lang == "eng" ? "Email" : "أدخل بريدك الإلكتروني باللغة الإنجليزية",_emailController,lang == "eng" ? "Enter email" : "أدخل اسمك باللغة الإنجليزية"),
                                        SmallButton(lang == "eng" ? "Forgot Password" : " هل نسيت كلمة السر؟",(){
                                          _forgetPassword();
                                        }),
                                      ],
                                    )),

                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: [
                                    TextButton(onPressed: (){
                                      setState(() {
                                        appBarTitle = lang == "eng" ?"Register" : "تسجيل حساب";
                                        _registerVisibility = true;
                                        _loginVisibility = false;
                                        _forgotPasswordVisibility = false;
                                      });
                                    }, child:  Text(lang == "eng" ? "Register" : "تسجيل جديد",style: TextStyle(color: Colors.grey),)),
                                    TextButton(onPressed: (){
                                      setState(() {
                                        appBarTitle = lang == "eng" ? "Login" : "تسجيل الدخول";
                                        _registerVisibility = false;
                                        _loginVisibility = true;
                                        _forgotPasswordVisibility = false;
                                      });
                                    }, child:  Text(lang == "eng" ? "Login" : "تسجيل الدخول",style: TextStyle(color: Colors.grey))),
                                    TextButton(onPressed: (){
                                      setState(() {
                                        appBarTitle = lang == "eng" ? "Forgot Password" : " هل نسيت كلمة السر؟";
                                        _registerVisibility = false;
                                        _loginVisibility = false;
                                        _forgotPasswordVisibility = true;
                                      });
                                    }, child:  Text(lang == "eng" ? "Forgot Password?" : " هل نسيت كلمة السر؟",style: TextStyle(color: Colors.grey))),
                                  ],
                                ),

                              ],
                            ),
                            _isLoading ?  Align(alignment: Alignment.center,child: LoaderWidget(false)) : Container(),
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


  void _registerUser(){
    if(_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      HTTPManager().registerUser(RegisterRequestModel(userName: _nameController.text,email: _emailController.text,password: _passwordController.text,city: _cityNameController.text)).then((value) {
        print("REGISTER USER");
        print(value);


        setState(() {
          _isLoading = false;
          _cityNameController.text = "";
          _nameController.text = "";
          _emailController.text = "";
          _passwordController.text = "";
        });

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
        // Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=> const HomeScreen()));
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


  void _loginUser() {
    if(_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      HTTPManager().loginUser(LoginRequestModel(email: _emailController.text,password: _passwordController.text,rememberMe: "on")).then((value) async {

        print("LOGIN USER");
        print(value.userSession!.username.toString());
        if(value.userSession != null){
          await databaseHelper.setUser(context, value.userSession!);
          showToast(
            "Logged in successfully",
            context: context,
            isHideKeyboard: true,
            toastHorizontalMargin: 10,
            backgroundColor: Colors.green,
            reverseAnimation: StyledToastAnimation.fade,
            position: StyledToastPosition.top,
            duration: const Duration(seconds: 3),
          );
        }


        setState(() {
          _isLoading = false;
            _cityNameController.text = "";
            _nameController.text = "";
            _emailController.text = "";
            _passwordController.text = "";
        });
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=> const HomeScreen()));
        // setState(()  {
        //   _isLoading = false;
        //   _cityNameController.text = "";
        //   _nameController.text = "";
        //   _emailController.text = "";
        //   _passwordController.text = "";
        //   sharedPreferences.setBool("user_logged_in", value.userSession!.userLoggedIn!);
        //   sharedPreferences.setString("__ci_last_regenerate", value.userSession!.iCiLastRegenerate.toString());
        //   sharedPreferences.setString("subscription", value.userSession!.subscription.toString());
        //   sharedPreferences.setString("usertype", value.userSession!.usertype.toString());
        //   sharedPreferences.setString("username", value.userSession!.username.toString());
        //   sharedPreferences.setString("useremail", value.userSession!.useremail.toString());
        //   sharedPreferences.setString("userid", value.userSession!.userid.toString());
        //   sharedPreferences.setString("paymentstatus", value.userSession!.paymentstatus.toString());
        //   print(value.message);

        //
        // });
      }).catchError((e) {
        String? error;
        setState(() {
          print("Compiler here");
          print(e);
          _isLoading = false;
        });
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
    }
  }

  void _forgetPassword(){
    if(_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      HTTPManager().forgotPassword(ForgotPasswordRequestModel(email: _emailController.text)).then((value) {
        print("FORGOT PASSWORD");
        print(value);
        setState(() {
          _isLoading = false;
          _cityNameController.text = "";
          _nameController.text = "";
          _emailController.text = "";
          _passwordController.text = "";
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
          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=> const HomeScreen()));
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
