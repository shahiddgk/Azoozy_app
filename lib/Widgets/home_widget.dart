import 'dart:math';

import 'package:azoozyapp/constants/utils.dart';
import 'package:azoozyapp/models/categories_response_model.dart';
import 'package:azoozyapp/models/job_detail_list_response.dart';
import 'package:azoozyapp/models/sub_categories_response_model.dart';
import 'package:azoozyapp/network/http_manager.dart';
import 'package:azoozyapp/screens/account_screen.dart';
import 'package:azoozyapp/services/database_helper.dart';
import 'package:azoozyapp/services/user_provider.dart';
import 'package:azoozyapp/widgets/home_screen_text.dart';
import 'package:azoozyapp/widgets/loader_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:provider/provider.dart';
import 'package:flutter_amazonpaymentservices/environment_type.dart';
import 'package:flutter_amazonpaymentservices/flutter_amazonpaymentservices.dart';




class HomeWidget extends StatefulWidget {
  const HomeWidget({super.key});

  @override
  State<HomeWidget> createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeWidget> {
  late CategoriesResponseModel categoriesResponseModel;
  late SubCategoryResponseModel subCategoryResponseModel;
  late JobDetails job_details;

  bool _isLoading = true;
  bool _isUserDataLoading = true;
  bool _isSubLoading = true;
  bool _isJobDetailLoading = true;
  bool _isSubCategoryVisible = false;
  bool _isDataTableVisible = false;
  bool isCategoryVisible = true;
  bool processingPayment = false;
  String categoryName = "";
  String subCategoryName = "";


  @override
  void initState() {
      _getCategoryList();
    super.initState();
  }




  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<UserProvider>(context);
    final user = provider.user;
    final lang = provider.language;
    return  Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      color: const Color(0xFF000028),
      child:processingPayment
          ? LoaderWidget(true)
          :  SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
                padding:const EdgeInsets.only(left: 10,right: 10,top: 30),
                child:  Text(lang == "eng" ? "Hello What kind of job are you looking for?" : "أهلا كيف يمكنني مساعدك؟",style: TextStyle(fontSize: 24,color: Colors.white),)),
            Padding(
                padding:const EdgeInsets.symmetric(horizontal: 10,vertical: 20),
                child:  Text( lang == "eng" ? "Hello I am interested in" : "مرحبًا ، أنا مهتم",style: TextStyle(fontSize: 18,color: Colors.white),)),
            Visibility(
                visible: isCategoryVisible,
                child:_isLoading ? Align(alignment: Alignment.center,child: LoaderWidget(true),) : ListView.builder(
                    itemCount: categoriesResponseModel.categories!.length,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      return HomeScreenText(categoriesResponseModel.categories![index].name,(){
                        setState(() {
                          _isSubCategoryVisible = true;
                          isCategoryVisible = false;
                          categoryName = categoriesResponseModel.categories![index].name!;
                        });
                        categoriesResponseModel.categories![index].name;
                        _getSubCategoryListing(categoriesResponseModel.categories![index].tableId.toString());

                      },false,(){},lang);
                    })),

            Visibility(
                visible:  _isSubCategoryVisible,
                child: HomeScreenText(categoryName,(){
                  setState(() {
                    _isSubCategoryVisible = false;
                    isCategoryVisible = true;
                    _isDataTableVisible = false;
                  });
                },true,(){},lang)),

            Visibility(
                visible:  _isDataTableVisible,
                child: HomeScreenText(subCategoryName,(){
                  setState(() {
                    _isSubCategoryVisible = true;
                    isCategoryVisible = false;
                    _isDataTableVisible = false;
                  });
                },true,(){},lang)),

            _isSubCategoryVisible ?  const SizedBox(height: 10,) : const SizedBox(height: 5,),

            Visibility(
              visible: _isSubCategoryVisible,
              child: _isSubLoading ?  Align(alignment: Alignment.center,child: LoaderWidget(true),): ListView.builder(
                  itemCount: subCategoryResponseModel.jobSubCategory!.length,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    return HomeScreenText(subCategoryResponseModel.jobSubCategory![index].name,(){
                      // Navigator.of(context).push(MaterialPageRoute(builder: (context)=>CheckoutView()));
                      print("On Tap =======================> ${user.paymentstatus}");
                      if(user.userid == null){
                        Navigator.of(context).push(MaterialPageRoute(builder: (context) => AccountScreen(),));
                      }else if(user.subscription == 'unsub' || user.paymentstatus == 'unpaid'){

                        print('Sending Request');

                        startPaymentProcess();






                        // Navigator.of(context).push(MaterialPageRoute(builder: (context) => PaymentScreen(),));


                      }else if(user.subscription == 'sub' || user.paymentstatus == 'paid') {
                          setState(() {
                            subCategoryName = subCategoryResponseModel.jobSubCategory![index].name!;
                            _isSubCategoryVisible = false;
                            isCategoryVisible = false;
                            _isDataTableVisible = true;
                            _getJobDetailsListing(subCategoryResponseModel.jobSubCategory![index].tableId.toString());
                          });
                      }
                      // if(useremail.isEmpty || useremail=="useremail" || userid.isEmpty || userid == "userid") {
                      //   print("IF =======================>");
                      //   Navigator.of(context).push(MaterialPageRoute(builder: (context)=>const AccountScreen()));
                      // } else if(subscribeStatus == "sub") {
                      //   print("Else IF =======================>");
                      //   setState(() {
                      //     subCategoryName = subCategoryResponseModel.jobSubCategory![index].name!;
                      //     _isSubCategoryVisible = false;
                      //     isCategoryVisible = false;
                      //     _isDataTableVisible = true;
                      //     _getJobDetailsListing(subCategoryResponseModel.jobSubCategory![index].tableId.toString());
                      //   });
                      // } else {
                      //   print("Else =======================>");
                      //   // _launchUrlForPay(language, userid, useremail);
                      // }
                    },false,(){},lang);
                  }),),

            Visibility(
              visible: _isDataTableVisible,
              child: _isJobDetailLoading ?  Align(alignment: Alignment.center,child: LoaderWidget(true),):  SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Theme(
                  data: Theme.of(context).copyWith(
                      dividerColor: Colors.white
                  ),
                  child: DataTable(
                    columnSpacing: MediaQuery.of(context).size.width/15,
                    showCheckboxColumn: false,
                    columns:  [
                      DataColumn(label: Text(lang == "eng" ?'Job Title' : "عنوان وظيفي" ,style: const TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 20),),),
                      DataColumn(label: Text(lang == "eng" ?'Your Location' : "موقعك" ,style:const TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 20)),),
                      DataColumn(label: Text(lang == "eng" ?'A Company' : "شركة" ,style:const TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 20)),),
                    ],
                    rows: job_details.jobDetail!.isEmpty? [
                      DataRow(cells: <DataCell>[
                        DataCell(Text(lang == "eng" ? "There is no data available" : "لاتوجد بيانات",style: TextStyle(color: Colors.white))),
                        const DataCell(Text("")),
                        const  DataCell(Text("")),
                      ])
                    ] : List.generate(
                        job_details.jobDetail!.length,
                            (index) => DataRow(
                            onSelectChanged: (selected) {
                              // showDataAlert(job_details.jobDetail![index]);
                            },
                            cells: <DataCell>[
                              DataCell(Text(job_details.jobDetail![index].name!,style: TextStyle(color: Colors.white))),
                              DataCell(Text(job_details.jobDetail![index].jobLocation!,style: TextStyle(color: Colors.white))),
                              DataCell(Text(job_details.jobDetail![index].companyName!,style: TextStyle(color: Colors.white))),
                            ])),
                  ),
                ),
              ),
            ),

            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5,vertical: 30),
                child: Image.network("https://azoozy.com/assets/images/other.png",fit: BoxFit.cover,)),

            Divider(color: Colors.white,thickness: 2,),
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5,vertical: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        SizedBox(width: 5,),
                        Expanded(child: Image.network("https://azoozy.com/images/apple-pay(1).png",fit: BoxFit.cover,)),
                        SizedBox(width: 5,),
                        Expanded(child: Image.network("https://azoozy.com/images/maestro.png",fit: BoxFit.cover,)),
                        SizedBox(width: 5,),
                        Expanded(child: Image.network("https://azoozy.com/images/paypal.png",fit: BoxFit.cover,)),
                        SizedBox(width: 5,),
                        Expanded(child: Image.network("https://azoozy.com/images/visa.png",fit: BoxFit.cover,)),
                        SizedBox(width: 5,),
                        Expanded(child: Image.network("https://azoozy.com/images/master-card(1).png",fit: BoxFit.cover,)),
                        SizedBox(width: 5,),
                        Expanded(child: Image.network("https://azoozy.com/images/mada.png",fit: BoxFit.cover,)),
                        SizedBox(width: 5,),
                      ],
                    ),
                    const Text("All Rights Reserved © 2022 Azoozy.com ",style: TextStyle(color: Colors.white),)

                  ],
                )),

          ],
        ),
      ),
    );
  }

  void _getCategoryList() {
    setState(() {
      _isLoading = true;
    });
    print('Home Screen Getting Category List');
    final lang = Provider.of<UserProvider>(context, listen: false).language;
    HTTPManager().getCategoryListing(lang == 'eng' ? 'English' : 'Arabic').then((value) {
      setState(() {
        categoriesResponseModel = value;
        _isLoading = false;
      });
      print(categoriesResponseModel.categories![0].name);
    }).catchError((e) {
      print(e);
      _isLoading = false;
      setState(() {
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

  _getSubCategoryListing(String categoryId) {
    setState(() {
      _isSubLoading = true;
    });
    final lang = Provider.of<UserProvider>(context, listen: false).language;

    HTTPManager().getSubCategoryListing(categoryId,lang == 'eng' ? 'English' : 'Arabic').then((value) {
      setState(() {
        subCategoryResponseModel = value;
        _isSubLoading = false;
      });
      print("SubCategories");
      print(subCategoryResponseModel.jobSubCategory![0].name);

    }).catchError((e) {
      print(e);
      setState(() {
        _isSubLoading = false;
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

  _getJobDetailsListing(String subCategoryId) {
    setState(() {
      _isJobDetailLoading = true;
    });
    final lang = Provider.of<UserProvider>(context, listen: false).language;
    HTTPManager().getJobDetailsListing(subCategoryId,lang == 'eng' ? 'English' : 'Arabic').then((value) {
      setState(() {
        job_details = value;
        _isJobDetailLoading = false;
      });
      // print("jobDetails");
      // print(job_details.jobDetail![0].name);

    }).catchError((e) {
      print(e);
      setState(() {
        _isJobDetailLoading = false;
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





  startPaymentProcess()async {
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
        setState(() {
          processingPayment = false;
        });

        print('Error :: $error');
      });
    }
  }
}
