import 'package:azoozy_app/Screens/AccountScreen.dart';
import 'package:azoozy_app/Screens/about_us.dart';
import 'package:azoozy_app/Screens/call_us_screen.dart';
import 'package:azoozy_app/Screens/home_screen.dart';
import 'package:azoozy_app/Screens/privacy_policy.dart';
import 'package:azoozy_app/Screens/terms_and_conditions.dart';
import 'package:azoozy_app/Widgets/loader_widget.dart';
import 'package:azoozy_app/models/unsubscribe_model_response.dart';
import 'package:azoozy_app/network/http_manager.dart';
import 'package:azoozy_app/requests/change_password_reuest.dart';
import 'package:azoozy_app/requests/unsubscribe_request_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:multilevel_drawer/multilevel_drawer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:translator/translator.dart';

import 'changes_password.dart';

class DrawerScreen extends StatefulWidget {
  const DrawerScreen({Key? key}) : super(key: key);

  @override
  _DrawerScreenState createState() => _DrawerScreenState();
}

class _DrawerScreenState extends State<DrawerScreen> {

  GoogleTranslator translator = GoogleTranslator();
  String language1 = "English";
  bool userLoggedIn = false;
  bool  _isLoading = false;
  bool _isUserDataLoading = false;
  String language = "";
  String usertype = "";
  String username = "";
  String useremail = "";
  String userid = "";
  String subscription = "";
  String paymentstatus = "";
  late unsubscribeResponseModel unsubscribeResponseModel1;

  void setSharedPrefrence(String language) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    print("SharedPreference");
    print(language);
    sharedPreferences.setString("Language", language);

    setState(() {
      language1 = language;
    });

    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>const DrawerScreen()));

  }

  Future<void> clearSharedPreference() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    sharedPreferences.setBool("user_logged_in", false);
    sharedPreferences.setString("__ci_last_regenerate", "");
    sharedPreferences.setString("subscription", "subscription");
    sharedPreferences.setString("usertype", "usertype");
    sharedPreferences.setString("username", "username");
    sharedPreferences.setString("useremail", "useremail");
    sharedPreferences.setString("userid", "userid");
    sharedPreferences.setString("paymentstatus", "paymentstatus");
  }

  String outputN = "";
  String outputHP = "";
  String outputAU = "";
  String outputPP = "";
  String outputTC = "";
  String outputCU = "";
  String outputL = "";
  String outputLA = "";
  String outputLI = "";
  String outputUS = "";
  String outputCP = "";
  String outputLO = "";

  @override
  void initState() {
    // TODO: implement initState
    getSharedPrefence();
    getLanuageSharedPrefence();
    super.initState();
  }

  void getLanuageSharedPrefence() async {

    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      _isUserDataLoading = false;
      language1 = sharedPreferences.getString("Language")!;
    });

  }

  void getSharedPrefence() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    setState(() {


     userLoggedIn = sharedPreferences.getBool("user_logged_in")!;
     usertype = sharedPreferences.getString("usertype")!;
     username = sharedPreferences.getString("username")!;
     useremail = sharedPreferences.getString("useremail")!;
     userid = sharedPreferences.getString("userid")!;
     subscription = sharedPreferences.getString("subscription")!;
      paymentstatus = sharedPreferences.getString("paymentstatus")!;
    });
    if(userLoggedIn) {
      _getSubscritionStatus(userid);
    }

  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: Text("AZOOZY.COM",style: TextStyle(fontWeight: FontWeight.bold),),),
        drawer: _isUserDataLoading ? CircularProgressIndicator() : MultiLevelDrawer(
          backgroundColor: Color(0xFF000028),
            subMenuBackgroundColor: const Color(0xFF000028),
            divisionColor: Colors.white,
            header: Container(
              color: const Color(0xFF000028),
          height: MediaQuery.of(context).size.height/5,
          child: Center(child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              // Image.asset("assets/dp_default.png",width: 100,height: 100,),
             userLoggedIn ? Text(username,style: const TextStyle(color: Colors.white),) : const Text("",style: TextStyle(color: Colors.white),)
            ],
          )),
        ),
            children: [
              MLMenuItem(
                  // leading: Icon(Icons.person),
                  // trailing: Icon(Icons.arrow_right),
                  content:  Align(
                    alignment: Alignment.center,
                    child: Text(
                        language1 == "English" ? "Home Page" : "الصفحة الرئيسية",style: TextStyle(color: Colors.white)
                    ),
                  ),
                  onClick: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>const DrawerScreen()));
                  }),
              MLMenuItem(
                  // leading: Icon(Icons.person),
                  // trailing: Icon(Icons.arrow_right),
                  content: Align(
                    alignment: Alignment.center,
                    child: Text(
                        language1 == "English" ? "About Us" : "معلومات عنا",style: TextStyle(color: Colors.white)
                    ),
                  ),
                  onClick: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).push(MaterialPageRoute(builder: (context)=>const AboutUs()));
                  }),
              MLMenuItem(
                  // leading: Icon(Icons.person),
                  // trailing: Icon(Icons.arrow_right),
                  content:   Align(
                    alignment: Alignment.center,
                    child: Text(
                        language1 == "English" ? "Term & condition" :"الأحكام والشروط",style: TextStyle(color: Colors.white)
                    ),
                  ),
                  onClick: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).push(MaterialPageRoute(builder: (context)=>const TermsAndCondition()));
                  }),
              MLMenuItem(
                  // leading: Icon(Icons.person),
                  // trailing: Icon(Icons.arrow_right),
                  content:  Align(
                    alignment: Alignment.center,
                    child: Text(
                        language1 == "English" ? "Privacy & Policy" : "سياسة الخصوصية",style: TextStyle(color: Colors.white)
                    ),
                  ),
                  onClick: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).push(MaterialPageRoute(builder: (context)=>const PrivacyAndPolicy()));
                  }),
              MLMenuItem(
                  // leading: Icon(Icons.person),
                  // trailing: Icon(Icons.arrow_right),
                  content: Align(
                    alignment: Alignment.center,
                    child: Text(
                        language1 == "English" ? "Call Us" : "اتصل بنا",style: TextStyle(color: Colors.white)
                    ),
                  ),
                  onClick: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).push(MaterialPageRoute(builder: (context)=>const CallUs()));
                  }),
              MLMenuItem(
                  //leading: Icon(Icons.person),
                //  trailing: Icon(Icons.arrow_right,color: Colors.white,),
                  content:  Align(
                    alignment: Alignment.center,
                    child: Text(
                        language1 == "English" ? "اللغة العربية" : "English",style: TextStyle(color: Colors.white)
                    ),
                  ),
                  // subMenuItems: [
                  //   MLSubmenu(onClick: () {
                  //
                  //   }, submenuContent:  const Text("English",style: TextStyle(color: Colors.white))),
                  //   MLSubmenu(onClick: () {
                  //     setSharedPrefrence("Arabic");
                  //     Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>const DrawerScreen()));
                  //   }, submenuContent:  const Text("اللغة العربية",style: TextStyle(color: Colors.white))),
                  // ],
                  onClick: () {
                    setSharedPrefrence(language1 == "English" ? "اللغة العربية" : "English");
                    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>const DrawerScreen()));
                  }),
              userLoggedIn ? MLMenuItem(
                  // leading: Icon(Icons.person),
                   trailing: Icon(Icons.arrow_right,color: Colors.white,),
                  content:  Align(
                    alignment: Alignment.center,
                    child: Text(
                        language1 == "English" ? "Logout" : "تسجيل خروج",style: TextStyle(color: Colors.white)
                    ),
                  ),
                  subMenuItems: [
                 subscription != "unsub" ?  MLSubmenu(onClick: () {
                    _unsubscribe();
                  }, submenuContent:  Text( language1 == "English" ? "Unsubscribe" : "إلغاء اشتراكي",style: TextStyle(color: Colors.white))) :
                 MLSubmenu(onClick: () {
                 //  _unsubscribe();
                 }, submenuContent:  Text( language1 == "English" ? "Unsubscribe" : "إلغاء اشتراكي",style: TextStyle(color: Colors.white38))),
                    MLSubmenu(onClick: () {
                      Navigator.of(context).push(MaterialPageRoute(builder: (context)=>ChangePassword()));
                    }, submenuContent:  Text( language1 == "English" ? "Change Password" : "غير كلمة السر",style: TextStyle(color: Colors.white))),
                    MLSubmenu(onClick: () {
                      setState(() {
                        userLoggedIn = false;
                      });
                      clearSharedPreference();
                      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>DrawerScreen()));
                    }, submenuContent:  Text( language1 == "English" ? "Logout" : "تسجيل خروج",style: TextStyle(color: Colors.white))),
                  ],
                  onClick: () {
                     Navigator.of(context).pop();
                     Navigator.of(context).push(MaterialPageRoute(builder: (context)=>const AccountScreen()));
                  }) : MLMenuItem(
                // leading: Icon(Icons.person),
                //  trailing: Icon(Icons.arrow_right,color: Colors.white,),
                  content:  Align(
                    alignment: Alignment.center,
                    child: Text(
                        language1 == "English" ? "LogIn" : "تسجيل الدخول",style: TextStyle(color: Colors.white)
                    ),
                  ),
                  // subMenuItems: [
                  //   MLSubmenu(onClick: () {}, submenuContent:  Text( language1 == "English" ? "Unsubscribe" : transUS("Unsubscribe"),style: TextStyle(color: Colors.white))),
                  //   MLSubmenu(onClick: () {}, submenuContent:  Text( language1 == "English" ? "Change Password" : transCP("Change Password"),style: TextStyle(color: Colors.white))),
                  //   MLSubmenu(onClick: () {}, submenuContent:  Text( language1 == "English" ? "Logout" : transLO("Logout"),style: TextStyle(color: Colors.white))),
                  // ],
                  onClick: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).push(MaterialPageRoute(builder: (context)=>const AccountScreen()));
                  }),
            ]),
        body: !_isLoading ? const HomePage() : Align(alignment: Alignment.center,
        child: LoaderWidget(false),)
      ),
    );
  }

  void _unsubscribe() {
      HTTPManager().unsubscribe(userid).then((value) async {
        print("UNSUBSCRIBE USER");
        SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
        print(value);
        setState(() {
          sharedPreferences.setString("subscription", "unsub");
        });
        setState(() {
          _isLoading = false;
          if(value['message']!= null ) {
            showToast(
              value["message"].toString(),
              textStyle: TextStyle(color: Colors.black),
              context: context,
              isHideKeyboard: true,
              toastHorizontalMargin: 10,
              backgroundColor: Colors.green,
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

  void _getSubscritionStatus(String userID) {
    HTTPManager().subScriptionStatus(userID).then((value) async {
      SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

      sharedPreferences.setString("subscription", value.subscriptionStatus!.pkgStatus.toString());
      print("Sub Status");
      print(value.subscriptionStatus!.pkgStatus);
    }).catchError((e){
      print(e.toString());
    });
  }

}
