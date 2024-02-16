import 'dart:io';

import 'package:azoozyapp/constants/Assets.dart';
import 'package:azoozyapp/constants/app_colors.dart';
import 'package:azoozyapp/constants/payment_config.dart';
import 'package:azoozyapp/constants/utils.dart';
import 'package:azoozyapp/network/http_manager.dart';
import 'package:azoozyapp/requests/subscribe_request_model.dart';
import 'package:azoozyapp/services/database_helper.dart';
import 'package:azoozyapp/services/user_provider.dart';
import 'package:azoozyapp/widgets/home_drawer.dart';
import 'package:azoozyapp/widgets/home_widget.dart';
import 'package:azoozyapp/widgets/loader_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_amazonpaymentservices/environment_type.dart';
import 'package:flutter_amazonpaymentservices/flutter_amazonpaymentservices.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pay/pay.dart';
import 'package:provider/provider.dart';
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  DatabaseHelper databaseHelper = DatabaseHelper();
  bool processingPayment = false;
  bool isLoading = false;
  String language = '';

  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() async{
    if(mounted){
      setState(() {
        isLoading = true;
      });
    }


    await databaseHelper.refreshUser(context);
    await databaseHelper.refreshLanguage(context);
    language = await databaseHelper.getLanguage();


    if(mounted){
      setState(() {
        isLoading = false;
      });
    }





  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primarySwatch,
      appBar: AppBar(title: const Text("AZOOZY.COM",style: TextStyle(fontWeight: FontWeight.bold))),
      drawer: HomeDrawer(startPaymentProcessing: startPaymentProcess),
      body: isLoading
          ? LoaderWidget(true)
          : Stack(
        alignment: Alignment.center,
        children: [
          HomeWidget(startPaymentProcessing: startPaymentProcess),
          if(processingPayment)
          LoaderWidget(true),
        ],
      ),
    );
  }


  testSubscribeReq(){
    HTTPManager().updatePaymentStatus(SubscribeRequestModel(userId: '105')).then((value) {
      print(' ============>> Subscription Status is Updated <<================');
    }).onError((error, stackTrace){
      print(' ============>> Subscription Status has Error <<================');
      print(error);
    });
  }




  startPaymentProcess()async{
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.primarySwatch,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
      ),
      builder:(context) {
        final paymentItem = [PaymentItem(amount: '1',label: 'Total', status: PaymentItemStatus.final_price)];
        return Container(
          padding: const EdgeInsets.all(10),
          height: MediaQuery.of(context).size.height / (Platform.isIOS ?  7.5 : 5),
          // height: MediaQuery.of(context).size.height / 5,
          child: Column(
            children: [
              Container(
                height: 5,
                width: 40,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10)
                ),
              ),
              const SizedBox(height: 12),
              ApplePayButton(
                height: 45,
                paymentConfiguration: PaymentConfiguration.fromJsonString(defaultApplePay),
                style: ApplePayButtonStyle.black,
                width: double.infinity,
                type: ApplePayButtonType.buy,
                loadingIndicator: LoaderWidget(true),
                onPressed: (){
                  Navigator.of(context).pop();
                },
                onPaymentResult: (result) {
                  print('=========>> ON Payment Result <<========');
                  print(result);
                  updateSubscriptionStatus();

                },
                paymentItems: paymentItem,
              ),

              GooglePayButton(
                width: double.infinity,
                onPressed: () {
                  Navigator.of(context).pop();
                },
                paymentConfiguration: PaymentConfiguration.fromJsonString(defaultGooglePay),
                type: GooglePayButtonType.pay,
                loadingIndicator: LoaderWidget(true),
                onPaymentResult: (result) {
                  print('=========>> ON Payment Result <<========');
                  print(result);
                  updateSubscriptionStatus();
                },
                paymentItems: paymentItem,
              ),
              const SizedBox(height: 10),
              Visibility(
                visible: Platform.isAndroid,
                child:InkWell(
                  onTap: () {
                    Navigator.of(context).pop();
                    startPaymentProcessWithCard();
                  },
                  child: Container(
                    height: 45,
                    decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: Platform.isIOS ? BorderRadius.circular(5) :  BorderRadius.circular(24),
                        border: Platform.isIOS ? Border.all()  : Border.all(
                          color: Color(0xFF747775),
                          width: 1,
                        )
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Pay with', style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.w600)),
                        const SizedBox(width: 5),
                        SvgPicture.asset(Assets.cardImagePath, height: 25,width: 25),
                        const SizedBox(width: 5),
                        Text('Card', style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.w600)),


                      ],
                    ),
                  ),
                ),
              )



            ],
          ),
        );
      },);
  }







  startPaymentProcessWithCard()async {
    setState(() {
      processingPayment = true;
    });
    final user = Provider.of<UserProvider>(context, listen: false).user;

    final deviceId = await FlutterAmazonpaymentservices.getUDID;
    print(' ========>> Device Id <<=============');
    print(deviceId);

    if (deviceId != null) {
      HTTPManager().getSdkToken(deviceId).then((value) {
        setState(() {
          processingPayment = false;
        });

        print('============>> SDK Token in Home Widget << =============');
        print(value);

        String merchantReference = randomString(16);

        Map<String, dynamic> requestParams = {};
        print(' ============>> Flutter Amazon Payment <<================');
         requestParams = {
          "amount": 100,
          "command": "AUTHORIZATION",
          "currency": "SAR",
          "customer_email": user.useremail,
          "language": "en",
          "merchant_reference": merchantReference,
          "sdk_token": value,
        };




        FlutterAmazonpaymentservices.normalPay(requestParams, EnvironmentType.sandbox, isShowResponsePage: false).then((value){
          print(' ============>> Flutter Amazon Payment Successful <<================');
          print(value);

          updateSubscriptionStatus();




        }).onError((error, stackTrace) {
          print(' ============>> Flutter Amazon Payment Error <<================');
          print(error);
        });

      }).onError((error, stackTrace) {
        setState(() {
          processingPayment = false;
        });
        print('Error :: $error');
      });
    }
  }

  updateSubscriptionStatus(){


    setState(() {
      processingPayment = true;
    });

    final user = Provider.of<UserProvider>(context, listen: false).user;
    HTTPManager().updateSubscribeStatus(SubscribeRequestModel(userId: user.userid)).then((value) {
      print(' ============>> Subscription Status is Updated <<================');
      DatabaseHelper().changeStatusToSubscribe(context, 'paid');
      setState(() {
        processingPayment = false;
      });
    }).onError((error, stackTrace){
      setState(() {
        processingPayment = false;
      });
      print('Error :: $error');
    });
  }
}
