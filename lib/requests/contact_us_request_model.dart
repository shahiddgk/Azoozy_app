class ContactUsRequestModel {
  String? name;
  String? email;
  String? message;

  ContactUsRequestModel({this.name,this.email,this.message});

  ContactUsRequestModel.fromJson(Map<String, dynamic>json) {
    name = json['name'];
    email = json['email'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {

    final Map<String, dynamic> data = new Map<String, dynamic>();

    data['name'] = name;
    data['email'] = email;
    data['message'] = message;

    return data;
  }

}