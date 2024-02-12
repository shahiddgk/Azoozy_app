import 'package:azoozyapp/constants/app_colors.dart';
import 'package:azoozyapp/constants/app_styles.dart';
import 'package:azoozyapp/screens/about_us_screen.dart';
import 'package:azoozyapp/screens/account_screen.dart';
import 'package:azoozyapp/screens/call_us_screen.dart';
import 'package:azoozyapp/screens/home_screen.dart';
import 'package:azoozyapp/screens/privacy_policy_screen.dart';
import 'package:azoozyapp/screens/terms_and_conditions.dart';
import 'package:azoozyapp/services/database_helper.dart';
import 'package:azoozyapp/services/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:multilevel_drawer/multilevel_drawer.dart';
import 'package:provider/provider.dart';
class HomeDrawer extends StatefulWidget {
  const HomeDrawer({super.key});

  @override
  State<HomeDrawer> createState() => _HomeDrawerState();
}

class _HomeDrawerState extends State<HomeDrawer> {

  DatabaseHelper databaseHelper = DatabaseHelper();

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
        divisionColor: AppColors.whiteColor,
        header: Container(
          alignment: Alignment.center,
          height: size.height / 5,
          color: AppColors.primarySwatch,
          child: Text(user.username ?? '', style: AppStyle.whiteTextStyle),
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
                onClick: (){},
              )
                  :MLSubmenu(
                submenuContent: Text(lang == 'eng' ? 'Unsubscribe' : 'إلغاء اشتراكي', style: AppStyle.whiteTextStyle,),
                onClick: (){},
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

  void _logout() async{

    await databaseHelper.logoutUser(context);

    Navigator.of(context).push(MaterialPageRoute(builder: (context) => HomeScreen()));


  }
}
