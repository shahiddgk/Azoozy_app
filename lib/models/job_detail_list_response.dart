// ignore: camel_case_types
class jobDetails {
  List<JobDetail>? jobDetail;

  jobDetails({this.jobDetail});

  jobDetails.fromJson(Map<String, dynamic> json) {
    if (json['job_details'] != null) {
      jobDetail = <JobDetail>[];
      json['job_details'].forEach((v) { jobDetail!.add(new JobDetail.fromJson(v)); });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.jobDetail != null) {
      data['job_details'] = this.jobDetail!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class JobDetail {
  String? id;
  String? jobId;
  String? name;
  String? details;
  String? jobLocation;
  String? companyName;
  String? websiteUrl;

  JobDetail({this.id, this.jobId, this.name, this.details, this.jobLocation, this.companyName, this.websiteUrl});

  JobDetail.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    jobId = json['job_id'];
    name = json['name'];
    details = json['details'];
    jobLocation = json['job_location'];
    companyName = json['company_name'];
    websiteUrl = json['website_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['job_id'] = this.jobId;
    data['name'] = this.name;
    data['details'] = this.details;
    data['job_location'] = this.jobLocation;
    data['company_name'] = this.companyName;
    data['website_url'] = this.websiteUrl;
    return data;
  }
}