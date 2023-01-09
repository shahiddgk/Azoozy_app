import 'package:azoozy_app/Screens/payment_screen.dart';
import 'package:azoozy_app/Widgets/home_screenn_text.dart';
import 'package:azoozy_app/Widgets/loader_widget.dart';
import 'package:azoozy_app/Widgets/small_button.dart';
import 'package:azoozy_app/models/categories_response_model.dart';
import 'package:azoozy_app/models/sub_categories_response_model.dart';
import 'package:azoozy_app/network/http_manager.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:translator/translator.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/job_detail_list_response.dart';
import '../network/api_urls.dart';
import 'AccountScreen.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  late CategoriesResponseModel categoriesResponseModel;
  late SubCategoryResponseModel subCategoryResponseModel;
  late jobDetails job_details;
  GoogleTranslator translator = GoogleTranslator();

  bool _isLoading = true;
  bool _isUserDataLoading = true;
  bool _isSubLoading = true;
  bool _isJobDetailLoading = true;
  bool _isSubCategoryVisible = false;
  bool _isDataTableVisible = false;
  bool isCategoryVisible = true;
  String categoryName = "";
  String subCategoryName = "";
  String language = "English";
  String output1 = '';
  String output2 = '';

  String useremail = "";
  String userid = "";
  String subscribeStatus = "";

  @override
  void initState() {
    // TODO: implement initState

     Future.delayed(const Duration(seconds: 3),() {
       _getCategoryList();
     });


    getSharedPrefence();

    getUserData();

    super.initState();
  }

  String trans1(String text) {
    translator
        .translate(text, to: "ar")
        .then((value) {
      setState(() {
        output1 = value.text;
      });
    });
    return output1;
  }

  String trans2(String text) {
    translator
        .translate(text, to: "ar")
        .then((value) {
      setState(() {
        output2 = value.text;
      });
    });
    return output2;
  }

  void _getCategoryList() {
    setState(() {
      _isLoading = true;
    });
    HTTPManager().getCategoryListing(language).then((value) {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // ignore: avoid_unnecessary_containers
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: const Color(0xFF000028),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                  padding:const EdgeInsets.only(left: 10,right: 10,top: 30),
                  child:  Text(language == "English" ? "Hello What kind of job are you looking for?" : "أهلا كيف يمكنني مساعدك؟",style: TextStyle(fontSize: 24,color: Colors.white),)),
              Padding(
                  padding:const EdgeInsets.symmetric(horizontal: 10,vertical: 20),
                  child:  Text( language == "English" ? "Hello I am interested in" : "مرحبًا ، أنا مهتم",style: TextStyle(fontSize: 18,color: Colors.white),)),
             Visibility(
                 visible: isCategoryVisible,
                 child:_isLoading ? Align(alignment: Alignment.center,child: LoaderWidget(false),) : ListView.builder(
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

                    },false,(){},language);
                  })),

              Visibility(
                  visible:  _isSubCategoryVisible,
                  child: HomeScreenText(categoryName,(){
                    setState(() {
                      _isSubCategoryVisible = false;
                      isCategoryVisible = true;
                      _isDataTableVisible = false;
                    });
                  },true,(){},language)),

              Visibility(
                  visible:  _isDataTableVisible,
                  child: HomeScreenText(subCategoryName,(){
                    setState(() {
                      _isSubCategoryVisible = true;
                      isCategoryVisible = false;
                      _isDataTableVisible = false;
                    });
                  },true,(){},language)),

              _isSubCategoryVisible ?  const SizedBox(height: 10,) : const SizedBox(height: 5,),

              Visibility(
                visible: _isSubCategoryVisible,
                child: _isSubLoading ?  Align(alignment: Alignment.center,child: LoaderWidget(false),): ListView.builder(
                  itemCount: subCategoryResponseModel.jobSubCategory!.length,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    return HomeScreenText(subCategoryResponseModel.jobSubCategory![index].name,(){
                   // Navigator.of(context).push(MaterialPageRoute(builder: (context)=>CheckoutView()));
                      if(useremail.isEmpty || useremail=="useremail" || userid.isEmpty || userid == "userid") {
                        Navigator.of(context).push(MaterialPageRoute(builder: (context)=>const AccountScreen()));
                      } else if(subscribeStatus == "sub") {
                        setState(() {

                          subCategoryName = subCategoryResponseModel.jobSubCategory![index].name!;
                          _isSubCategoryVisible = false;
                          isCategoryVisible = false;
                          _isDataTableVisible = true;
                          _getJobDetailsListing(subCategoryResponseModel.jobSubCategory![index].tableId.toString());
                        });
                      } else {
                        _launchUrlForPay(language, userid, useremail);
                      }
                    },false,(){},language);
                  }),),

              Visibility(
                  visible: _isDataTableVisible,
                  child: _isJobDetailLoading ?  Align(alignment: Alignment.center,child: LoaderWidget(false),):  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Theme(
                      data: Theme.of(context).copyWith(
                          dividerColor: Colors.white
                      ),
                      child: DataTable(
                        columnSpacing: MediaQuery.of(context).size.width/15,
                          showCheckboxColumn: false,
                          columns:  [
                            DataColumn(label: Text(language == "English" ?'Job Title' : "عنوان وظيفي" ,style: const TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 20),),),
                            DataColumn(label: Text(language == "English" ?'Your Location' : "موقعك" ,style:const TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 20)),),
                            DataColumn(label: Text(language == "English" ?'A Company' : "شركة" ,style:const TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 20)),),
                          ],
                          rows: job_details.jobDetail!.isEmpty? [
                           DataRow(cells: <DataCell>[
                            DataCell(Text(language == "English" ? "There is no data available" : "لاتوجد بيانات",style: TextStyle(color: Colors.white))),
                            const DataCell(Text("")),
                           const  DataCell(Text("")),
                          ])
                          ] : List.generate(
                              job_details.jobDetail!.length,
                                  (index) => DataRow(
                                      onSelectChanged: (selected) {
                                        showDataAlert(job_details.jobDetail![index]);
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
                          Expanded(child: Image.network("https://azoozy.com/dev/images/apple-pay(1).png",fit: BoxFit.cover,)),
                          SizedBox(width: 5,),
                          Expanded(child: Image.network("https://azoozy.com/dev/images/maestro.png",fit: BoxFit.cover,)),
                          SizedBox(width: 5,),
                          Expanded(child: Image.network("https://azoozy.com/dev/images/paypal.png",fit: BoxFit.cover,)),
                          SizedBox(width: 5,),
                          Expanded(child: Image.network("https://azoozy.com/dev/images/visa.png",fit: BoxFit.cover,)),
                          SizedBox(width: 5,),
                          Expanded(child: Image.network("https://azoozy.com/dev/images/master-card(1).png",fit: BoxFit.cover,)),
                          SizedBox(width: 5,),
                          Expanded(child: Image.network("https://azoozy.com/dev/images/mada.png",fit: BoxFit.cover,)),
                          SizedBox(width: 5,),
                        ],
                      ),
                     const Text("All Rights Reserved © 2022 Azoozy.com ",style: TextStyle(color: Colors.white),)

                    ],
                  )),

            ],
          ),
        ),
      ),
    );
  }

  showDataAlert(JobDetail jobDetail) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(
                  20.0,
                ),
              ),
            ),
            contentPadding:const EdgeInsets.only(
              top: 10.0,
            ),
            content: Container(
              height: MediaQuery.of(context).size.height/0.5,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Padding(
                      padding:  EdgeInsets.only(top: 3.0,bottom: 3.0),
                      child: Text(
                       language == "English" ? "Job Title" : "عنوان وظيفي",
                      ),
                    ),
                    Html(
                        data: jobDetail.name,
                      ),
                     Padding(
                      padding: EdgeInsets.only(top: 3.0,bottom: 3.0),
                      child: Text(
                        language == "English" ?  "Your Location" : "موقعك",
                      ),
                    ),
                    Html(
                        data: jobDetail.jobLocation,
                      ),
                     Padding(
                      padding: EdgeInsets.only(top: 3.0,bottom: 3.0),
                      child: Text(
                       language == "English" ? "Details" : "التفاصيل",
                      ),
                    ),
                    Html(
                        data: jobDetail.details,
                      ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        SmallButton(language == "English" ? "Cancel" : "إلغاء" , (){
                          Navigator.of(context).pop();
                        }),
                        SmallButton(language == "English" ? "Next One": "التالي", (){
                          _launchUrlForJob(jobDetail.websiteUrl.toString());
                        })
                      ],
                    )
                  ],
                ),
              ),
            ),
          );
        });
  }

  _getSubCategoryListing(String categoryId) {
    setState(() {
      _isSubLoading = true;
    });
    HTTPManager().getSubCategoryListing(categoryId,language).then((value) {
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
    HTTPManager().getJobDetailsListing(subCategoryId,language).then((value) {
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

  Future<Translation> getTranslation(String? name) async {
    var translation = await translator.translate(name!, from: 'en', to: 'ar');
    print("translationtranslation");
    print(translation);
    return translation;
  }

  Future<void> getSharedPrefence() async {
    setState(() {
      _isUserDataLoading = true;
    });
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    setState(() {

      language = sharedPreferences.getString("Language")!;

      _isUserDataLoading = false;
    });

  }

  Future<void> getUserData() async {
    setState(() {
      _isUserDataLoading = true;
    });
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    setState(() {

      useremail = sharedPreferences.getString("useremail")!;
      userid = sharedPreferences.getString("userid")!;
      subscribeStatus = sharedPreferences.getString("subscription")!;

      _isUserDataLoading = false;
    });

  }

  void _launchUrlForPay(String language,String userId,String email) async {
    String? lang ;
    if(language == "English") {
      setState(() {
        lang = "eng";
      });
    } else {
      setState(() {
        lang = "arb";
      });
    }
    Navigator.of(context).push(MaterialPageRoute(builder: (context)=>HyperPayPayment(userId,email,lang!)));
  }

  void _launchUrlForJob(String url) async {

    Uri uri = Uri.parse(url);
    if (!await launchUrl(uri)) {
    throw 'Could not launch $uri';
    }

  }

}
