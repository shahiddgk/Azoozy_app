

import 'package:azoozy_app/models/categories_response_model.dart';
import 'package:azoozy_app/models/job_detail_list_response.dart';
import 'package:azoozy_app/models/login_response_model.dart';
import 'package:azoozy_app/models/sub_categories_response_model.dart';
import 'package:azoozy_app/models/subscription_response_model.dart';
import 'package:azoozy_app/network/response_handler.dart';
import 'package:azoozy_app/requests/change_password_reuest.dart';
import 'package:azoozy_app/requests/contact_us_request_model.dart';
import 'package:azoozy_app/requests/forgot_password_request_model.dart';
import 'package:azoozy_app/requests/log_in_request_Model.dart';
import 'package:azoozy_app/requests/sign_up_request_model.dart';
import 'api_urls.dart';

class HTTPManager {
  final ResponseHandler _handler = ResponseHandler();

  Future<dynamic> registerUser(RegisterRequestModel registerRequestModel) async {

    const url = ApplicationURLs.API_SIGN_UP;
    // ignore: avoid_print
    print(url);

    final response =
        await _handler.post(Uri.parse(url),registerRequestModel.toJson(), false);
    // ignore: avoid_print
    print(response.toString());
    return response;
  }

  Future<dynamic> changePassword(ChangePasswordRequestModel changePasswordRequestModel) async {

    const url = ApplicationURLs.API_CHANGE_PASSWORD;
    // ignore: avoid_print
    print(url);

    final response =
    await _handler.post(Uri.parse(url),changePasswordRequestModel.toJson(), false);
    // ignore: avoid_print
    print(response.toString());
    return response;
  }

  Future<dynamic> unsubscribe(String userId) async {

    String url = "${ApplicationURLs.API_UNSUBSCRIBE}/?user_id=$userId";
    // ignore: avoid_print
    print(url);
    print(userId);

    final response = await _handler.get(Uri.parse(url),false);
    // ignore: avoid_print
    print("Response Unsub");
    print(response.toString());
    return response;
  }

  Future<SubscriptionStatusResponse> subScriptionStatus(String userId) async {

    String url = "${ApplicationURLs.API_SUBSCRIPTOIN_STATUS}?user_id=$userId";
    // ignore: avoid_print
    print(url);
    print(userId);

    final response = await _handler.get(Uri.parse(url),false);
    SubscriptionStatusResponse subscriptionStatusResponse = SubscriptionStatusResponse.fromJson(response);
    // ignore: avoid_print
    print("Response Sub Status");
     print(subscriptionStatusResponse.toString());
    return subscriptionStatusResponse;
  }

  Future<LoginResponseModel> loginUser(LoginRequestModel loginRequestModel) async {

    const url = ApplicationURLs.API_LOGIN ;
    // ignore: avoid_print
    print(url);

    final response =
    await _handler.post(Uri.parse(url),loginRequestModel.toJson() ,false);
    LoginResponseModel loginResponseModel = LoginResponseModel.fromJson(response);

    // ignore: avoid_print
    print(response.toString());
      return loginResponseModel;
  }

  Future<dynamic> contactUs(ContactUsRequestModel contactUsRequestModel) async {

    const url = ApplicationURLs.API_CONTACT_US ;
    // ignore: avoid_print
    print(url);

    final response =
    await _handler.post(Uri.parse(url),contactUsRequestModel.toJson() ,false);
// ignore: avoid_print
    print(response.toString());
    return response;
  }

  Future<dynamic> forgotPassword(ForgotPasswordRequestModel forgotPasswordRequestModel) async {

    const url = ApplicationURLs.API_FORGOT_PASSWORD ;
    // ignore: avoid_print
    print(url);

    final response =
    await _handler.post(Uri.parse(url),forgotPasswordRequestModel.toJson() ,false);
// ignore: avoid_print
    print(response.toString());
    return response;
  }

  Future<CategoriesResponseModel> getCategoryListing(String language) async {

    String lang;
    if(language == "English") {
      lang = "eng";
    } else {
      lang = "arb";
    }

    String url = "${ApplicationURLs.API_CATEGORIES}?language=$lang";
    // ignore: avoid_print
    print(url);

    final response =
    await _handler.get(Uri.parse(url), false);
    CategoriesResponseModel categoriesResponseModel =
    CategoriesResponseModel.fromJson(response);
    return categoriesResponseModel;
  }

  Future<SubCategoryResponseModel> getSubCategoryListing(String categoryId,String language) async {
    String lang;
    if(language == "English") {
      lang = "eng";
    } else {
      lang = "arb";
    }
    String url = "${ApplicationURLs.API_SUB_CATEGORIES}?category_id=$categoryId&language=$lang";
    print(url);

    final response =
    await _handler.get(Uri.parse(url), false);
    SubCategoryResponseModel subCategoryResponseModel =
    SubCategoryResponseModel.fromJson(response);
    return subCategoryResponseModel;
  }

  Future<jobDetails> getJobDetailsListing(String subCategoryId,String language) async {
    String lang;
    if(language == "English") {
      lang = "eng";
    } else {
      lang = "arb";
    }
    String url = "${ApplicationURLs.API_JOB_DETAIL}?sub_category=$subCategoryId&language=$lang";
    print(url);

    final response =
    await _handler.get(Uri.parse(url), false);
    jobDetails jobdetails =
        jobDetails.fromJson(response);
    return jobdetails;
  }

  Future<String> getTerms(String language) async {
    String lang;
    if(language == "English") {
      lang = "eng";
    } else {
      lang = "arb";
    }


    String url = "${ApplicationURLs.API_TERMS}?language=$lang";
    print('=========================');
    print(ApplicationURLs.API_TERMS);
    print(url);

    final response = await _handler.get(Uri.parse(url), false);
    if(language == "English") {
      String terms = response['terms'];
      return terms;
    } else {
      String terms = response['arabic_terms'];
      return terms;
    }
  }

  Future<String> getPrivacyPolicy(String language) async {
    String lang;
    if(language == "English") {
     lang = "eng";
    } else {
      lang = "arb";
    }

    String url = "${ApplicationURLs.API_PRIVACY_POLICY}?language=$lang";
    print(url);

    final response =
    await _handler.get(Uri.parse(url), false);
    if(language == "English") {
      String privacyPolicy = response['privacy_policy'];
      return privacyPolicy;
    } else {
      String privacyPolicy = response['arabic_privacy'];
      return privacyPolicy;
    }

  }

  Future<String> getAboutUs(String language) async {
    String lang;
    if(language == "English") {
      lang = "eng";
    } else {
      lang = "arb";
    }
    String url = "${ApplicationURLs.API_ABOUT_US}?language=$lang";
    print(url);

    final response =
    await _handler.get(Uri.parse(url), false);
    if(language == "English") {
      String aboutUs = response['aboutus'];
      return aboutUs;
    } else {
      String privacyPolicy = response['aboutus_arabic'];
      return privacyPolicy;
    }

  }

}
