class LoginResponseModel {
  String? message;
  UserSession? userSession;
 // UserCookie? userCookie;

  LoginResponseModel({this.message, this.userSession});

  LoginResponseModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    userSession = json['user_session'] != null
        ? UserSession.fromJson(json['user_session'])
        : null;

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    if (userSession != null) {
      data['user_session'] = userSession!.toJson();
    }

    return data;
  }
}

class UserSession {
  int? iCiLastRegenerate;
  bool? userLoggedIn;
  String? usertype;
  String? username;
  String? useremail;
  String? userid;
  String? subscription;
  String? paymentstatus;

  UserSession(
      {this.iCiLastRegenerate,
        this.userLoggedIn,
        this.usertype,
        this.username,
        this.useremail,
        this.userid,
        this.subscription,
        this.paymentstatus});

  UserSession.fromJson(Map<String, dynamic> json) {
    iCiLastRegenerate = json['__ci_last_regenerate'];
    userLoggedIn = json['user_logged_in'];
    usertype = json['usertype'];
    username = json['username'];
    useremail = json['useremail'];
    userid = json['userid'];
    subscription = json['subscription'];
    paymentstatus = json['paymentstatus'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['__ci_last_regenerate'] = this.iCiLastRegenerate;
    data['user_logged_in'] = this.userLoggedIn;
    data['usertype'] = this.usertype;
    data['username'] = this.username;
    data['useremail'] = this.useremail;
    data['userid'] = this.userid;
    data['subscription'] = this.subscription;
    data['paymentstatus'] = this.paymentstatus;
    return data;
  }
}

class UserCookie {
  String? frontpass;
  String? frontuser;
  String? userRememeber;

  UserCookie({this.frontpass, this.frontuser, this.userRememeber});

  UserCookie.fromJson(Map<String, dynamic> json) {
    frontpass = json['frontpass'];
    frontuser = json['frontuser'];
    userRememeber = json['user_rememeber'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['frontpass'] = this.frontpass;
    data['frontuser'] = this.frontuser;
    data['user_rememeber'] = this.userRememeber;
    return data;
  }
}