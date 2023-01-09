class SubscriptionStatusResponse {
  String? message;
  SubscriptionStatus? subscriptionStatus;

  SubscriptionStatusResponse({this.message, this.subscriptionStatus});

  SubscriptionStatusResponse.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    subscriptionStatus = json['subscription_status'] != null
        ? new SubscriptionStatus.fromJson(json['subscription_status'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    if (this.subscriptionStatus != null) {
      data['subscription_status'] = this.subscriptionStatus!.toJson();
    }
    return data;
  }
}

class SubscriptionStatus {
  String? pkgStatus;

  SubscriptionStatus({this.pkgStatus});

  SubscriptionStatus.fromJson(Map<String, dynamic> json) {
    pkgStatus = json['pkg_status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['pkg_status'] = this.pkgStatus;
    return data;
  }
}