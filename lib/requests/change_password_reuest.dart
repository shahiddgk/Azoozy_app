
class ChangePasswordRequestModel {
  String? oldPassword;
  String? newPassword;
  String? userId;

  ChangePasswordRequestModel({this.oldPassword,this.newPassword,this.userId,});

  ChangePasswordRequestModel.fromJson(Map<String, dynamic>json) {
    userId = json['user_id'];
    oldPassword = json['old_password'];
    newPassword = json['new_password'];

  }

  Map<String, dynamic> toJson() {

    final Map<String, dynamic> data = new Map<String, dynamic>();

    data['user_id'] = userId;
    data['old_password'] = oldPassword;
    data['new_password'] = newPassword;

    return data;
  }

}