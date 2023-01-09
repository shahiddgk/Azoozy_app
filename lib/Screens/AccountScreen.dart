
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

import '../requests/forgot_password_request_model.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({Key? key}) : super(key: key);

  @override
  _AccountScreenState createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _cityNameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

   bool _registerVisibility = true;
  bool _loginVisibility = false;
  bool _forgotPasswordVisibility = false;

  String appBarTitle = "Register";

  late LoginResponseModel loginResponseModel;

  GoogleTranslator translator = GoogleTranslator();
  String language1 = "English";
  bool _isUserDataLoading = false;
  bool _isLoading = false;

  String output2 = "";

  String trans(String text) {
    translator
        .translate(text, to: "ar")
        .then((value) {
      setState(() {
        output2 = value.text;
      });
    });
    return output2;
  }

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
      _isUserDataLoading = false;
      appBarTitle = language1 == "English" ?"Register" : "تسجيل حساب";
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
                                Visibility(
                                    visible: _registerVisibility,
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                            padding: EdgeInsets.symmetric(horizontal: 5,vertical: 5),
                                            child:  Text(language1 == "English" ? "Register an account" : "تسجيل حساب",style: TextStyle(fontSize: 18))),
                                        NameField(language1 == "English" ? "Name" : "اسم",_nameController,language1 == "English" ? "Enter Name" : "أدخل اسمك باللغة الإنجليزية",false),
                                        EmailField(language1 == "English" ? "Email" : "أدخل بريدك الإلكتروني باللغة الإنجليزية",_emailController,language1 == "English" ? "Enter email" : "أدخل اسمك باللغة الإنجليزية"),
                                        NameField(language1 == "English" ? " Password" : "كلمه السر",_passwordController,language1 == "English" ? "Enter Password" : "كلمه السر",true),
                                        NameField(language1 == "English" ? "City Name" : "اكتب اسم المدينة باللغة الإنجليزية" ,_cityNameController,language1 == "English" ? "Enter City Name" : "اكتب اسم المدينة باللغة الإنجليزية",false),
                                        SmallButton(language1 == "English" ? "Register" : "تسجيل جديد",(){
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
                                            child: Text(language1 == "English" ? "Type your username and password" : "البريد الإلكتروني",style: TextStyle(fontSize: 18))),
                                        EmailField(language1 == "English" ? "Email" : "البريد الإلكتروني",_emailController,language1 == "English" ? "Enter email" : "أدخل اسمك باللغة الإنجليزية"),
                                        NameField(language1 == "English" ? " Password" : "كلمه السر",_passwordController,language1 == "English" ? "Enter Password" : "كلمه السر",true),
                                        SmallButton(language1 == "English" ? "Login" : "تسجيل الدخول",(){
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
                                            child: Text(language1 == "English" ? "Type your email" : "أدخل بريدك الإلكتروني باللغة الإنجليزية",style: TextStyle(fontSize: 18))),
                                        EmailField(language1 == "English" ? "Email" : "أدخل بريدك الإلكتروني باللغة الإنجليزية",_emailController,language1 == "English" ? "Enter email" : "أدخل اسمك باللغة الإنجليزية"),
                                        SmallButton(language1 == "English" ? "Forgot Password" : " هل نسيت كلمة السر؟",(){
                                          _ForgotPasswordUser();

                                        }),
                                      ],
                                    )),

                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: [
                                    TextButton(onPressed: (){
                                      setState(() {
                                        appBarTitle = language1 == "English" ?"Register" : "تسجيل حساب";
                                        _registerVisibility = true;
                                        _loginVisibility = false;
                                        _forgotPasswordVisibility = false;
                                      });
                                    }, child:  Text(language1 == "English" ? "Register" : "تسجيل جديد",style: TextStyle(color: Colors.grey),)),
                                    TextButton(onPressed: (){
                                      setState(() {
                                        appBarTitle = language1 == "English" ? "Login" : "تسجيل الدخول";
                                        _registerVisibility = false;
                                        _loginVisibility = true;
                                        _forgotPasswordVisibility = false;
                                      });
                                    }, child:  Text(language1 == "English" ? "Login" : "تسجيل الدخول",style: TextStyle(color: Colors.grey))),
                                    TextButton(onPressed: (){
                                      setState(() {

                                        appBarTitle = language1 == "English" ? "Forgot Password" : " هل نسيت كلمة السر؟";
                                        _registerVisibility = false;
                                        _loginVisibility = false;
                                        _forgotPasswordVisibility = true;
                                      });
                                    }, child:  Text(language1 == "English" ? "Forgot Password?" : " هل نسيت كلمة السر؟",style: TextStyle(color: Colors.grey))),
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

  void _registerUser() {
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

  void _loginUser() {
    if(_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      HTTPManager().loginUser(LoginRequestModel(email: _emailController.text,password: _passwordController.text,rememberMe: "on")).then((value) async {
        SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

        print("LOGIN USER");
        print(value.userSession!.username.toString());
        setState(()  {
          _isLoading = false;
          _cityNameController.text = "";
          _nameController.text = "";
          _emailController.text = "";
          _passwordController.text = "";
          sharedPreferences.setBool("user_logged_in", value.userSession!.userLoggedIn!);
          sharedPreferences.setString("__ci_last_regenerate", value.userSession!.iCiLastRegenerate.toString());
          sharedPreferences.setString("subscription", value.userSession!.subscription.toString());
          sharedPreferences.setString("usertype", value.userSession!.usertype.toString());
          sharedPreferences.setString("username", value.userSession!.username.toString());
          sharedPreferences.setString("useremail", value.userSession!.useremail.toString());
          sharedPreferences.setString("userid", value.userSession!.userid.toString());
          sharedPreferences.setString("paymentstatus", value.userSession!.paymentstatus.toString());
          print(value.message);
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
          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>DrawerScreen()));
        });
      }).catchError((e) {
        String? error;
        setState(() {
          print("Compiler here");
          print(e);
         // error = e['message'].toString();
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

  void _ForgotPasswordUser() {
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
          showToast(
            value.toString(),
            context: context,
            isHideKeyboard: true,
            toastHorizontalMargin: 10,
            backgroundColor: Colors.green,
            reverseAnimation: StyledToastAnimation.fade,
            position: StyledToastPosition.top,
            duration: const Duration(seconds: 3),

          );
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
