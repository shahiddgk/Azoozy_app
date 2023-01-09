class LoginRequestModel {
  String? email;
  String? password;
  String? rememberMe;

  LoginRequestModel({this.email,this.password,this.rememberMe});

  LoginRequestModel.fromJson(Map<String, dynamic>json) {
    email = json['email'];
    password = json['password'];
    //rememberMe = json['rememberme'];
  }

  Map<String, dynamic> toJson() {

    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['email'] = email;
    data['password'] = password;
    //data['rememberme'] = rememberMe;
    return data;
  }

}