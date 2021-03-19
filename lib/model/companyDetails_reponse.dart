import 'companyDetails.dart';


class CompanyDetailsResponse {
  final CompanyDetails companyDetails;
  final String error;

  CompanyDetailsResponse(this.companyDetails, this.error);

  CompanyDetailsResponse.fromJson(Map<String, dynamic> json)
      : companyDetails = (json["data"]),
        error = "";

  // CompanyDetailsResponse.withError(String errorValue)
  //     : companyDetails = null,
  //       error = errorValue;
}
