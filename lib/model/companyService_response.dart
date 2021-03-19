
import 'companyService.dart';

class CompanyServiceResponse {
  final List<CompanyServices> companyServices;
  final String error;

  CompanyServiceResponse(this.companyServices, this.error);


  CompanyServiceResponse.fromJson(Map<String, dynamic> json)
      : companyServices = (json["data"]["services"] as List)
      .map((i) => new CompanyServices.fromJson(i))
      .toList(),
        error = "";

  CompanyServiceResponse.withError(String errorValue)
      : companyServices = List(),
        error = errorValue;
}
