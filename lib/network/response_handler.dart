import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import 'app_exceptions.dart';

String MESSAGE_KEY = 'message';

class ResponseHandler {
  Map<String, String> setTokenHeader() {
    return {
      '': ''
    }; //{'Authorization': 'Bearer ${Constants.authenticatedToken}'};
  }

  Future post(
      Uri url, Map<String, dynamic> params, bool isHeaderRequired) async {
    var head = Map<String, String>();
    head['content-type'] = 'application/x-www-form-urlencoded';
    var responseJson;
    try {
      final response = await http.post(url, body: params, headers: head).timeout(Duration(seconds: 45));
      print(response.body);
      responseJson = json.decode(response.body.toString());
      print(responseJson);
      //var res = json.decode(response.body.toString());
      if(responseJson['status']!= 200) throw FetchDataException(responseJson['message'].toString());
      return responseJson;
    } on TimeoutException {
      throw FetchDataException("Slow internet connection");
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
  }


  Future postAmazon(
      Uri url, Map<String, dynamic> params) async {
    var head = Map<String, String>();
    head['content-type'] = 'application/json';
    var responseJson;
    try {
      final response = await http.post(url, body: jsonEncode(params), headers: head).timeout(Duration(seconds: 45));
      responseJson = json.decode(response.body.toString());
      print(responseJson);
      return responseJson;
    } on TimeoutException {
      throw FetchDataException("Slow internet connection");
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
  }

  // Future postImage(String url, Map<String, String> params,
  //     File image, bool isHeaderRequired, String message) async {
  //   var head = Map<String, String>();
  //   head['content-type'] = 'application/x-www-form-urlencoded';
  //   var res;
  //   try {
  //     final request = http.MultipartRequest('POST', Uri.parse(url));
  //     if (image != null) {
  //       final file = await http.MultipartFile.fromPath(
  //           'image',
  //           image
  //               .path); //,contentType: MediaType(mimeTypeData[0], mimeTypeData[1])
  //       request.files.add(file);
  //     }
  //     request.fields.addAll(params);
  //     await request.send().then((response) {
  //       if (response.statusCode == 200) print("Uploaded!");
  //       res = GeneralResponseModel(
  //           status: response.statusCode == 200,
  //           message: response.statusCode == 200
  //               ? "User $message"
  //               : "User Not $message",
  //           data: null);
  //     });
  //     return res;
  //   } on SocketException {
  //     throw FetchDataException('No Internet connection');
  //   }
  // }

  Future get(Uri url, bool isHeaderRequired) async {
    var head = Map<String, String>();
    head['content-type'] = 'application/json; charset=utf-8';
    var responseJson;
    try {
      final response = await http.get(url, headers: head).timeout(Duration(seconds: 45));
      responseJson = json.decode(response.body.toString());
      print(responseJson);
      if(responseJson['status']!= 200) throw FetchDataException(responseJson['message'].toString());
      return responseJson;
    } on TimeoutException {
      throw FetchDataException("Slow internet connection");
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
  }

}
