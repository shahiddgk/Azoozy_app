import 'package:azoozy_app/Widgets/email_field.dart';
import 'package:azoozy_app/Widgets/loader_widget.dart';
import 'package:azoozy_app/Widgets/message_field.dart';
import 'package:azoozy_app/Widgets/name_field.dart';
import 'package:azoozy_app/Widgets/small_button.dart';
import 'package:azoozy_app/network/http_manager.dart';
import 'package:azoozy_app/requests/contact_us_request_model.dart';
import 'package:azoozy_app/requests/sign_up_request_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CallUs extends StatefulWidget {
  const CallUs({Key? key}) : super(key: key);

  @override
  _CallUsState createState() => _CallUsState();
}

class _CallUsState extends State<CallUs> {

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String language = "English";
  bool _isUserDataLoading = false;

  bool _isLoading = false;

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

      language = sharedPreferences.getString("Language")!;
      _isUserDataLoading = false;
    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Call Us"),),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: const Color.fromRGBO(189, 195, 199, 100),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Container(
            margin: EdgeInsets.only(top: MediaQuery.of(context).size.height/14),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Column(
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
                          child: Column(
                            children: [
                              NameField(language == "English" ? "Name" : "أدخل اسمك باللغة الإنجليزية",_nameController,language == "English" ? "Name" : "أدخل اسمك باللغة الإنجليزية",false),
                              EmailField(language == "English" ? "Email" : "أدخل بريدك الإلكتروني باللغة الإنجليزية",_emailController,language == "English" ? "Enter email" : "أدخل اسمك باللغة الإنجليزية"),
                              MessageField(_messageController),
                              SmallButton(language == "English" ? "Send" : "إرسال",(){
                                _contactUs();
                              }),
                            ],
                          ),
                        )),
                  ],
                ),
                _isLoading ?   Align(alignment: Alignment.center,child: LoaderWidget(true),) : Container(),
              ],
            )
          ),
        ),
      ),
    );
  }

  void _contactUs() {
    if(_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      HTTPManager().contactUs(ContactUsRequestModel(name: _nameController.text,email: _emailController.text,message: _messageController.text)).then((value) {
        print("CONTACT USER");
        print(value);
        setState(() {
          _messageController.text = "";
          _emailController.text = "";
          _nameController.text = "";

          _isLoading = false;
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
