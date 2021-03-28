import 'package:violet_app/model/category.dart';
import 'package:violet_app/model/company.dart';

class CategoryResponse {
  final List<Category> category;
  final String error;

  CategoryResponse(this.category, this.error);

  CategoryResponse.fromJson(Map<String, dynamic> json)
      : category = (json["data"] as List)
      .map((i) => new Category.fromJson(i))
      .toList(),
        error = "";

  CategoryResponse.withError(String errorValue)
      : category = List(),
        error = errorValue;
}
