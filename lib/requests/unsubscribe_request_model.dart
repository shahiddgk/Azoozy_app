
class UnsubscribeRequestModel {
  String? userId;

  UnsubscribeRequestModel({this.userId,});

  UnsubscribeRequestModel.fromJson(Map<String, dynamic>json) {
    userId = json['user_id'];
  }

  Map<String, dynamic> toJson() {

    final Map<String, dynamic> data = new Map<String, dynamic>();

    data['user_id'] = userId;

    return data;
  }

}