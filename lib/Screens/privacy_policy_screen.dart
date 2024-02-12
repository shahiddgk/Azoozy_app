import 'package:azoozyapp/constants/app_colors.dart';
import 'package:azoozyapp/network/http_manager.dart';
import 'package:azoozyapp/services/user_provider.dart';
import 'package:azoozyapp/widgets/details_text.dart';
import 'package:azoozyapp/widgets/loader_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:provider/provider.dart';

class PrivacyPolicyScreen extends StatefulWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  State<PrivacyPolicyScreen> createState() => _PrivacyPolicyScreenState();
}

class _PrivacyPolicyScreenState extends State<PrivacyPolicyScreen> {

  bool _isLoading = false;

  String data = '';

  @override
  void initState() {
    super.initState();
    getPrivacyData();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<UserProvider>(context);
    final lang = provider.language;
    return Scaffold(
      appBar: AppBar(
        title: Text(lang == "eng" ? "Privacy & Policy" : "سياسة الخصوصية"),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: AppColors.primaryBackgroundColor,
        child: _isLoading ? LoaderWidget(false) :  DetailsText(data),
      ),
    );
  }

  void getPrivacyData() {

    setState(() {
      _isLoading = true;
    });

    final lang = Provider.of<UserProvider>(context,listen: false).language;

    HTTPManager().getPrivacyPolicy(lang == 'eng' ? 'English' : 'Arabic' ).then((value) {

      print(value);
      setState(() {
        _isLoading = false;
        data = value;
      });

    }).catchError((e) {
      print(e);
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
    });

  }

}
