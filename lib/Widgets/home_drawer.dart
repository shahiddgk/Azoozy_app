import 'package:azoozyapp/constants/app_colors.dart';
import 'package:azoozyapp/constants/app_styles.dart';
import 'package:azoozyapp/constants/utils.dart';
import 'package:azoozyapp/network/http_manager.dart';
import 'package:azoozyapp/screens/about_us_screen.dart';
import 'package:azoozyapp/screens/account_screen.dart';
import 'package:azoozyapp/screens/call_us_screen.dart';
import 'package:azoozyapp/screens/home_screen.dart';
import 'package:azoozyapp/screens/privacy_policy_screen.dart';
import 'package:azoozyapp/screens/terms_and_conditions.dart';
import 'package:azoozyapp/services/database_helper.dart';
import 'package:azoozyapp/services/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_amazonpaymentservices/environment_type.dart';
import 'package:flutter_amazonpaymentservices/flutter_amazonpaymentservices.dart';
import 'package:multilevel_drawer/multilevel_drawer.dart';
import 'package:provider/provider.dart';
class HomeDrawer extends StatefulWidget {
  HomeDrawer({super.key, required this.isLoading});
  bool isLoading;


  @override
  State<HomeDrawer> createState() => _HomeDrawerState();
}

class _HomeDrawerState extends State<HomeDrawer> {

  DatabaseHelper databaseHelper = DatabaseHelper();

  bool processingPayment = false;

  @override
  void initState() {

    super.initState();
  }



  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final provider = Provider.of<UserProvider>(context);
    final lang = provider.language;
    final user = provider.user;
    print('User Payment Status :: ${user.paymentstatus} :: Subscription  :: ${user.subscription}');
    return MultiLevelDrawer(
        backgroundColor: AppColors.primarySwatch,
        subMenuBackgroundColor: AppColors.primarySwatch,
        itemHeight: 80,
        divisionColor: AppColors.whiteColor,
        header: Container(
          alignment: Alignment.bottomCenter,
          height: size.height / 6,
          color: AppColors.primarySwatch,
          child: Text('Azoozy.com', style: TextStyle(fontSize: 24, color: Colors.white, fontWeight: FontWeight.bold)),
        ),
        children: [
          MLMenuItem(
              content: Align(
                alignment: Alignment.center,
                child: Text(lang == 'eng' ?  'Home Page' : 'الصفحة الرئيسية', style: AppStyle.whiteTextStyle),
              ),
              onClick: (){
                Navigator.of(context).pop();
                Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=> const HomeScreen()));
              },
          ),
          MLMenuItem(
              content: Align(
                alignment: Alignment.center,
                child: Text(lang == 'eng' ? 'About Us' : 'معلومات عنا', style: AppStyle.whiteTextStyle,),
              ),
              onClick: (){
                Navigator.of(context).pop();
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => const AboutUsScreen()));
              }
          ),
          MLMenuItem(
              content: Align(
                alignment: Alignment.center,
                child: Text(lang == 'eng' ? 'Terms & Condistions' : 'الأحكام والشروط', style: AppStyle.whiteTextStyle,),
              ),
              onClick: (){
                Navigator.of(context).pop();
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => const TermsAndConditions()));
              }
          ),
          MLMenuItem(
              content: Align(
                alignment: Alignment.center,
                child: Text(lang == 'eng' ? 'Privacy Policy' : 'سياسة الخصوصية', style: AppStyle.whiteTextStyle,),
              ),
              onClick: (){
                Navigator.of(context).pop();
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => const PrivacyPolicyScreen()));
              }
          ),

          MLMenuItem(
              content: Align(
                alignment: Alignment.center,
                child: Text(lang == 'eng' ? 'Call Us' : 'اتصل بنا', style: AppStyle.whiteTextStyle,),
              ),
              onClick: (){
                Navigator.of(context).pop();

                Navigator.of(context).push(MaterialPageRoute(builder: (context) => const CallUsScreen()));

              }
          ),

          MLMenuItem(
              content: Align(
                alignment: Alignment.center,
                child: Text(lang == 'eng' ? 'اللغة العربية' : 'English', style: AppStyle.whiteTextStyle,),
              ),
              onClick: () async{
                await databaseHelper.changeLanguage(lang == 'eng' ? 'arb' : 'eng');
                await databaseHelper.refreshLanguage(context);
                Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>const HomeScreen()));
              }
          ),

          user.userLoggedIn ?? false
              ? MLMenuItem(
            trailing:const Icon(Icons.arrow_right, color: AppColors.whiteColor) ,
            content:Align(
              alignment: Alignment.center,
              child: Text(lang == 'eng' ? 'Logout' : 'تسجيل خروج', style: AppStyle.whiteTextStyle),
            ),
            subMenuItems: [
              user.paymentstatus == 'unpaid'
                  ? MLSubmenu(
                submenuContent: Text(lang == 'eng' ? 'Subscribe' : 'يشترك', style: AppStyle.whiteTextStyle,),
                onClick: (){
                  startPaymentProcess();

                },
              )
                  :MLSubmenu(
                submenuContent: Text(lang == 'eng' ? 'Unsubscribe' : 'إلغاء اشتراكي', style: AppStyle.whiteTextStyle,),
                onClick: (){
                  DatabaseHelper().changeStatusToSubscribe(context, 'unpaid');
                  Navigator.of(context).pop();
                },
              )  ,
              MLSubmenu(
                submenuContent: Text(lang == 'eng' ? 'Change Password' : 'غير كلمة السر', style: AppStyle.whiteTextStyle,),
                onClick: (){},
              ),
              MLSubmenu(
                submenuContent: Text(lang == 'eng' ? 'Logout' : 'تسجيل خروج', style: AppStyle.whiteTextStyle,),
                onClick: _logout,
              ),
            ],
            onClick: (){
            }
          ) : MLMenuItem(
              content: Align(
                alignment: Alignment.center,
                child: Text(lang == 'eng' ? 'Login' : 'تسجيل الدخول', style: AppStyle.whiteTextStyle),
              ),
              onClick: (){
                Navigator.of(context).pop();
                Navigator.of(context).push(MaterialPageRoute(builder: (context)=>const AccountScreen()));
              },
          ) ,




        ],
    );
  }

  startPaymentProcess()async {

    Navigator.of(context).pop();

    final user = Provider.of<UserProvider>(context, listen: false).user;

    final deviceId = await FlutterAmazonpaymentservices.getUDID;
    print(' ========>> Device Id <<=============');
    print(deviceId);

    if (deviceId != null) {
      HTTPManager().getSdkToken(deviceId).then((value) {

        print('============>> SDK Token in Home Widget << =============');
        print(value);

        String merchantReference = randomString(16);

        print(' ============>> Flutter Amazon Payment <<================');
        Map<String, dynamic> requestParams = {
          "amount": 100,
          "command": "AUTHORIZATION",
          "currency": "SAR",
          "customer_email": user.useremail,
          "language": "en",
          "merchant_reference": merchantReference,
          "sdk_token": value,
        };

        FlutterAmazonpaymentservices.normalPay(requestParams, EnvironmentType.sandbox).then((value){
          print(' ============>> Flutter Amazon Payment Successful <<================');
          print(value);
          DatabaseHelper().changeStatusToSubscribe(context, 'paid');
        }).onError((error, stackTrace) {
          print(' ============>> Flutter Amazon Payment Error <<================');
          print(error);
        });

      }).onError((error, stackTrace) {

        print('Error :: $error');
      });
    }
  }

  void _logout() async{

    await databaseHelper.logoutUser(context);

    Navigator.of(context).push(MaterialPageRoute(builder: (context) => HomeScreen()));


  }
}
