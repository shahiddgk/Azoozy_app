class RegisterRequestModel {
  String? userName;
  String? email;
  String? password;
  String? city;

  RegisterRequestModel({this.userName,this.email,this.password,this.city});

  RegisterRequestModel.fromJson(Map<String, dynamic>json) {
    userName = json['user_name'];
    email = json['email'];
    password = json['password'];
    city = json['city'];
  }

  Map<String, dynamic> toJson() {

    final Map<String, dynamic> data = new Map<String, dynamic>();

    data['user_name'] = userName;
    data['email'] = email;
    data['password'] = password;
    data['city'] = city;

    return data;
  }

}