import 'package:azoozyapp/constants/Assets.dart';
import 'package:azoozyapp/constants/app_colors.dart';
import 'package:azoozyapp/network/http_manager.dart';
import 'package:azoozyapp/requests/contact_us_request_model.dart';
import 'package:azoozyapp/services/user_provider.dart';
import 'package:azoozyapp/widgets/email_field.dart';
import 'package:azoozyapp/widgets/loader_widget.dart';
import 'package:azoozyapp/widgets/message_field.dart';
import 'package:azoozyapp/widgets/name_field.dart';
import 'package:azoozyapp/widgets/small_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:provider/provider.dart';


class CallUsScreen extends StatefulWidget {
  const CallUsScreen({super.key});

  @override
  State<CallUsScreen> createState() => _CallUsScreenState();
}

class _CallUsScreenState extends State<CallUsScreen> {

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();


  final _formKey = GlobalKey<FormState>();

  bool _isLoading = false;


  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<UserProvider>(context);
    final lang = provider.language;
    final user = provider.user;
    _nameController.text = user.username ?? '';
    _emailController.text = user.useremail ?? '';

    return Scaffold(
      appBar: AppBar(title:  Text(lang == 'eng' ? 'Call Us' : 'اتصل بنا' ),),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: AppColors.primaryBackgroundColor,
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
                                child: Image.network(Assets.azoozyBlackImagePath))),
                      ),
                      const SizedBox(height: 20,),
                      Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: Form(
                            key: _formKey,
                            child: Column(
                              children: [
                                NameField(lang == 'eng' ? "Name" : "أدخل اسمك باللغة الإنجليزية",_nameController,lang == 'eng' ? "Name" : "أدخل اسمك باللغة الإنجليزية",false),
                                EmailField(lang == 'eng' ? "Email" : "أدخل بريدك الإلكتروني باللغة الإنجليزية",_emailController,lang == 'eng' ? "Enter email" : "أدخل اسمك باللغة الإنجليزية"),
                                MessageField(_messageController),
                                SmallButton(lang == 'eng' ? "Send" : "إرسال",(){
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