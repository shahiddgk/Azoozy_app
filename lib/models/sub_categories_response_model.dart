class SubCategoryResponseModel {
  List<JobSubCategory>? jobSubCategory;

  SubCategoryResponseModel({this.jobSubCategory});

  SubCategoryResponseModel.fromJson(Map<String, dynamic> json) {
    if (json['job_sub_category'] != null) {
      jobSubCategory = <JobSubCategory>[];
      json['job_sub_category'].forEach((v) {
        jobSubCategory!.add(new JobSubCategory.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.jobSubCategory != null) {
      data['job_sub_category'] =
          this.jobSubCategory!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class JobSubCategory {
  String? name;
  String? tableId;

  JobSubCategory({this.name,this.tableId});

  JobSubCategory.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    tableId = json['table_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['table_id'] = this.tableId;
    return data;
  }
}