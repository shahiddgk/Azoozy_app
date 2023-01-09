class CategoriesResponseModel {
  List<Categories>? categories;

  CategoriesResponseModel({this.categories});

  CategoriesResponseModel.fromJson(Map<String, dynamic> json) {
    if (json['job_categories'] != null) {
      categories = <Categories>[];
      json['job_categories'].forEach((v) {
        categories!.add(new Categories.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.categories != null) {
      data['categories'] = this.categories!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Categories {
  String? tableId;
  String? name;

  Categories({this.tableId, this.name});

  Categories.fromJson(Map<String, dynamic> json) {
    tableId = json['table_id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['table_id'] = this.tableId;
    data['name'] = this.name;
    return data;
  }
}