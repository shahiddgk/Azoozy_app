class unsubscribeResponseModel {
  String? message;
  UserSession? userSession;

  unsubscribeResponseModel({this.message, this.userSession});

  unsubscribeResponseModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    userSession = json['user_session'] != null
        ? new UserSession.fromJson(json['user_session'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    if (this.userSession != null) {
      data['user_session'] = this.userSession!.toJson();
    }
    return data;
  }
}

class UserSession {
  int? iCiLastRegenerate;
  String? paymentstatus;

  UserSession({this.iCiLastRegenerate, this.paymentstatus});

  UserSession.fromJson(Map<String, dynamic> json) {
    iCiLastRegenerate = json['__ci_last_regenerate'];
    paymentstatus = json['paymentstatus'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['__ci_last_regenerate'] = this.iCiLastRegenerate;
    data['paymentstatus'] = this.paymentstatus;
    return data;
  }
}