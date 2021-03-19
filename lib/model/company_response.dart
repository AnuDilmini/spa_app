import 'package:flutter_app/model/company.dart';

class CompanyResponse {
  final List<Company> company;
  final String error;

  CompanyResponse(this.company, this.error);

  CompanyResponse.fromJson(Map<String, dynamic> json)
      : company = (json["data"] as List)
      .map((i) => new Company.fromJson(i))
      .toList(),
        error = "";

  CompanyResponse.withError(String errorValue)
      : company = List(),
        error = errorValue;
}
