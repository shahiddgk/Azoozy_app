import 'package:azoozyapp/constants/app_colors.dart';
import 'package:azoozyapp/constants/app_styles.dart';
import 'package:azoozyapp/network/http_manager.dart';
import 'package:azoozyapp/services/user_provider.dart';
import 'package:azoozyapp/widgets/details_text.dart';
import 'package:azoozyapp/widgets/loader_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:provider/provider.dart';
class TermsAndConditions extends StatefulWidget {
  const TermsAndConditions({super.key});

  @override
  State<TermsAndConditions> createState() => _TermsAndConditionsState();
}

class _TermsAndConditionsState extends State<TermsAndConditions> {

  bool _isLoading = false;
  String data = '';


  @override
  void initState() {
    super.initState();
    getTermsData();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<UserProvider>(context);
    final lang = provider.language;
    return Scaffold(
      appBar: AppBar(
        title:  Text(lang == "eng" ? "Terms & Conditions" :"الأحكام والشروط"),
      ),
      // ignore: avoid_unnecessary_containers
      body: Container(
          // color: AppColors.primarySwatch,
          color: const Color.fromRGBO(189, 195, 199, 100),
          padding: const EdgeInsets.symmetric(horizontal: 10),
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          // child: SingleChildScrollView(
          //   child: Column(
          //     children: [
          //       Container(
          //           width: MediaQuery.of(context).size.width/2,
          //           alignment: Alignment.center,
          //           child: Text('Azoozy.com', style: TextStyle(fontSize: 30, color: AppColors.whiteColor, fontWeight: FontWeight.bold))),
          //       const SizedBox(height: 10),
          //       Text('WELCOME TO AZOOZY PLEASE READ THIS IMPORTANT LEGAL INFORMATION THAT GOVERNS YOUR USE OF THE AZOOZY.COM WEBSITE AND THE SERVICES.', textAlign: TextAlign.center,style: TextStyle(fontSize: 20, color: Colors.white),),
          //       const SizedBox(height: 10),
          //       Text('May 20, 2022', style: TextStyle(fontSize: 16, color: Colors.white)),
          //       const SizedBox(height: 10),
          //       Text('By using a http://www.azoozy.com or the online platform (collectively, the “Website”), you confirm that you have read, understood, and accept these terms of use (“Terms”) as the terms which govern your access to and use of the Website and the Service and you agree to comply with them. If you do not accept or agree to comply with these Terms, you must not use this Website. Additionally, when using a portion of the Service, you agree to conform to any applicable posted guidelines for such Service, which may change or be updated from time to time at our sole discretion.', textAlign: TextAlign.center,style: TextStyle(fontSize: 16, color: Colors.white)),
          //       const SizedBox(height: 10),
          //       Text('These Terms are made between Harvest Season LLC the owner of www.azoozy.com (“we” “us” “our”, the “Company”, as applicable) and you (“you” or the “User”).', textAlign: TextAlign.center,style: TextStyle(fontSize: 16, color: Colors.white)),
          //       const SizedBox(height: 10),
          //       Text('1. Definitions',style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold)),
          //       const SizedBox(height: 10),
          //       Text('The following capitalised terms shall have the following meaning, except where the context otherwise requires:', textAlign: TextAlign.center,style: TextStyle(fontSize: 16, color: Colors.white)),
          //       const SizedBox(height: 10),
          //       Text('1.1    “AZOOZY” – Harvest Season LLC which is the owner of www.AZOOZY.com.', textAlign: TextAlign.center,style: TextStyle(fontSize: 16, color: Colors.white)),
          //       Text('1.2    “Applicable Law” means any law, proclamation, decree, ministerial decision, statute, statutory instrument, order, regulation, resolution, notice, legal precedent, by-law, directive, treaty or other instrument or requirement having the force of law within the KSA and issued, declared, passed or given effect in any manner by any government authority;', textAlign: TextAlign.center,style: TextStyle(fontSize: 16, color: Colors.white)),
          //     ],
          //   ),
          // ),
          child: _isLoading
              ? LoaderWidget(false)
              : DetailsText(data)
        ),
    );
  }

  void getTermsData() {
    setState(() {
      _isLoading = true;
    });

    final lang = Provider.of<UserProvider>(context,listen: false).language;

    HTTPManager().getTerms(lang == 'eng' ? 'English' : 'Arabic' ).then((value) {

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
