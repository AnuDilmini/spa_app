import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_app/model/category.dart';
import 'package:flutter_app/model/category_response.dart';
import 'package:flutter_app/model/companyDetails.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_app/model/companyService_response.dart';
import 'package:flutter_app/model/company_response.dart';
import 'package:flutter_app/model/login.dart';
import 'package:flutter_app/network/api_base_helper.dart';
import 'package:dio/dio.dart';
import 'api_exceptions.dart';

class Repository {

  final Dio _dio = Dio();
  ApiBaseHelper helper = ApiBaseHelper();
  static String  baseUrl = "https://spa.ammarahmad.net/api/v1";

  //POST
  static String login = baseUrl+"/login";
  static String registerNewCustomer = baseUrl+"/register_new_customer";
  static String verifyOtpGetToken = baseUrl+"/verify_otp_get_token";
  static String serviceCategoryAdd = baseUrl+"/service_category";

  //GET
  static String serviceCategory = baseUrl+"/service_category";
  static String serviceCategoryNo = baseUrl+"/service_category";
  static String company = baseUrl+"/company";
  static String companyDetails = baseUrl+"/company/";
  static String category = baseUrl+"/category";
  static String companiesByCategory = baseUrl+"/companies_by_category/";

  Future<User> fetchLogin() async {
    final response = await helper.get(
        baseUrl + "/login",
        params: {
          'mobile': '+94765956264',
        });
    return User.fromJson(response);
  }

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

  Future<CompanyResponse> getCompany(String language, String apiCall, String categoryId) async {
    Options options = Options(headers: {"Accept-Language": language});
    var params = {'lang': language,};
    String url = company;

    if(apiCall == "company"){

      url = company;
    }else if(apiCall == "companies_by_category"){
      url = companiesByCategory+categoryId;
    } else{
      url = company;
    }

    try {
      Response response = await _dio.get(url, queryParameters: params,
          options: options);

      var responseOriginal = _returnResponse(response);
      return CompanyResponse.fromJson(responseOriginal.data);
    }  on SocketException {
      throw CompanyResponse.withError('No Internet connection');
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

