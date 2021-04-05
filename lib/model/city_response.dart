import 'package:violet_app/model/company.dart';

class CityResponse {
  final List<City> city;
  final String error;

  CityResponse(this.city, this.error);

  CityResponse.fromJson(Map<String, dynamic> json)
      : city = (json["data"] as List)
      .map((i) => new City.fromJson(i))
      .toList(),
        error = "";

  CityResponse.withError(String errorValue)
      : city = List(),
        error = errorValue;
}
