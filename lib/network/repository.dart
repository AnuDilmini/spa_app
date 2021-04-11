import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:violet_app/bloc/reservation_date_time_bloc.dart';
import 'package:violet_app/model/ReservationTimeDate.dart';
import 'package:violet_app/model/category.dart';
import 'package:violet_app/model/category_response.dart';
import 'package:violet_app/model/city_response.dart';
import 'package:violet_app/model/companyDetails.dart';
import 'package:violet_app/model/companyService_response.dart';
import 'package:violet_app/model/company_response.dart';
import 'package:dio/dio.dart';
import 'package:violet_app/model/reservationDateTime_response.dart';
import 'api_exceptions.dart';

class Repository {

  final Dio _dio = Dio();

  String token;
  // static String  baseUrl = "https://spa.ammarahmad.net/api/v1/mobile";
  static String  baseUrl = "https://api.violetapp.net/api/v1/mobile";
  static String  iconUrl = "https://api.violetapp.net/storage/app/";

  //POST
  static String login = baseUrl+"/login";
  static String newReservation = baseUrl+"/new_reservation";
  static String registerNewCustomer = baseUrl+"/register_new_customer";
  static String verifyOtpGetToken = baseUrl+"/verify_otp_get_token";
  static String serviceCategoryAdd = baseUrl+"/service_category";
  static String companiesByCategory = baseUrl+"/companies-by-category";
  static String reservationsDateTime = baseUrl+"/reservations-date-time-by-company-employee-services";

  //GET
  static String serviceCategory = baseUrl+"/service_category";
  static String serviceCategoryNo = baseUrl+"/service_category";
  static String company = baseUrl+"/company";
  static String companyDetails = baseUrl+"/company/";
  static String category = baseUrl+"/category";
  static String city = baseUrl+"/city";
  static String reservationByCustomerId = baseUrl+"/reservation_by_customer_id/";


  dynamic _returnResponse(Response response) {
    switch (response.statusCode) {
      case 200:
        // var responseJson = json.decode(response.body.toString());
        // print(responseJson);
        return response;
      case 400:
        throw BadRequestException(response.data.toString());
      case 401:
      case 403:
        throw UnauthorisedException(response.data.toString());
      case 500:
      default:
        throw FetchDataException(
            'Error occured while Communication with Server with StatusCode : ${response.statusCode}');
    }
  }

  Future<CityResponse> getCity(String language) async {
    Options options = Options(headers: {"Accept-Language": language});

    String url = city;

      try {
        Response response = await _dio.get(url,
            options: options);
        if (response.statusCode == 200) {

          return CityResponse.fromJson(response.data);
        } else {
          throw  FetchDataException(response.data.toString());
        }

      }  on SocketException {
        throw CityResponse.withError('No Internet connection');
      }

    }

  Future<CompanyResponse> getCompany(String language, String apiCall, List<String> categoryId) async {
    Options options = Options(headers: {"Accept-Language": language});


    String url = company;

    if(apiCall == "company"){

      url = company;
      var params  = {'lang': language,};

      try {
        Response response = await _dio.get(url, queryParameters: params,
            options: options);

        var responseOriginal = _returnResponse(response);
        return CompanyResponse.fromJson(responseOriginal.data);
      }  on SocketException {
        throw CompanyResponse.withError('No Internet connection');
      }
    }else if(apiCall == "companies_by_category"){

      url = companiesByCategory;

      var params =  {'category_ids': categoryId};

      try {
        Response response = await _dio.post(url, data: params,
            options: options);
        if (response.statusCode == 200) {
          final item = response.data['data'];
          return CompanyResponse.fromJson(response.data);
        } else {
          throw  FetchDataException(response.data.toString());
        }

      }  on SocketException {
        throw CompanyResponse.withError('No Internet connection');
      }

    } else{
      url = company;
      var params  = {'lang': language};

      try {
        Response response = await _dio.get(url, queryParameters: params,
            options: options);

        var responseOriginal = _returnResponse(response);
        return CompanyResponse.fromJson(responseOriginal.data);
      }  on SocketException {
        throw CompanyResponse.withError('No Internet connection');
      }

    }


  }

  Future<CompanyDetails> getCompanyDetails(String language, String companyId) async {
    CompanyDetails result;

    var params = {'lang': language};
    try {
      Response response = await _dio.get(companyDetails + companyId, queryParameters: params,);

      if (response.statusCode == 200) {
        final item = response.data['data'];
        result = CompanyDetails.fromJson(item);
      } else {
        throw  FetchDataException(response.data.toString());
      }
    } on SocketException {
      FetchDataException('No Internet connection');
    }
    return result;
  }


  // Future<ReservationDateTimeResponse> postReservationDateTime(String language, String companyId) async {
  //   ReservationDateTimeResponse result;
  //
  //   var params = {'company_id': companyId};
  //   Options options = Options(headers: {"Accept-Language": language,
  //   'Authorization' : "Bearer "+token});
  //   try {
  //       Response response = await _dio.post(reservationsDateTime, data: params,
  //           options: options);
  //       if (response.statusCode == 200) {
  //         final item = response.data['data'];
  //         result =  ReservationDateTime.fromJson(item);
  //       } else {
  //         throw  FetchDataException(response.data.toString());
  //     }
  //   } on SocketException {
  //     FetchDataException('No Internet connection');
  //   }
  //   return result;
  // }

  Future<CompanyServiceResponse> getCompanyServices(String language, String companyId) async {

    // Options options = Options(headers: {"Accept-Language": language});
    var params = {'lang': language};

    try {
      Response response = await _dio.get(companyDetails + companyId, queryParameters: params,);
      if (response.statusCode == 200) {
        return CompanyServiceResponse.fromJson(response.data);
      } else {
        return CompanyServiceResponse.withError(response.data.toString());
      }
    }  on SocketException {
      return CompanyServiceResponse.withError("No Internet connection");
    }
  }

  Future<CategoryResponse> getCategory(String language) async {

    Options options = Options(headers: {"Accept-Language": language});
    var params = {'lang': language};
    try {
      Response response = await _dio.get(category, queryParameters: params, options: options);

      if (response.statusCode == 200) {
        return CategoryResponse.fromJson(response.data);
      } else {
        return CategoryResponse.fromJson(response.data);
      }
    } on SocketException {
      return CategoryResponse.withError("No Internet connection");
    }

  }

}

