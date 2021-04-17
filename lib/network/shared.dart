import 'package:violet_app/pages/setting.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesHelper {

  static setCompanyId(String companyId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('companyId', companyId);
  }

  static Future<String> getCompanyId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String companyId = prefs.getString('companyId');
    if (companyId != null) {
      return companyId;
    } else {
      return 'null';
    }
  }

  static setLanguage(String language) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('language', language);
  }

  static Future<String> getLanguage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String language = prefs.getString('language');
    if (language != null) {
      return language;
    } else {
      return "en";
    }
    return language;
  }

  static setTheme(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('theme', value);

  }

  static Future<bool> getTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool theme = prefs.getBool('theme');
    if (theme != null) {
      return theme;
    } else {
      return false;
    }
  }

  static setCustomerID(String customerId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('customerId', customerId);
  }

  static Future<String> getCustomerID() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String customerId = prefs.getString('customerId');
    return customerId;
  }

  static setToken(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
  }

  static Future<String> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token');
    return token;
  }

  static setSelectedCategory(List<String> selectedCategoryList) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('selectedCategoryList', selectedCategoryList);
  }

  static Future<List<String>> getSelectedCategory() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>  selectedCategoryList = prefs.getStringList('selectedCategoryList');
    return selectedCategoryList;
  }

  static setSelectedService(String selectedService) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('selectedService', selectedService);
  }

  static Future<String> getSelectedService() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String selectedCategoryList = prefs.getString('selectedService');
    return selectedCategoryList;
  }

  static setDateTime(String dateTime) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('dateTime', dateTime);
  }

  static Future<String> getDateTime() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String dateTime = prefs.getString('dateTime');
    return dateTime;
  }

  static setReservationID(String reservationID) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('reservationID', reservationID);
  }

  static Future<String> getReservationID() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String reservationID = prefs.getString('reservationID');
    return reservationID;
  }

  static setCompanyImage(String companyImage) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('companyImage', companyImage);
  }

  static Future<String> getCompanyImage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String companyImage = prefs.getString('companyImage');
    return companyImage;
  }

}