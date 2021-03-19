import 'package:flutter/cupertino.dart';
import 'package:flutter_app/model/companyDetails.dart';
import 'package:flutter_app/network/repository.dart';

class CompanyDetailsDataProvider with ChangeNotifier {
  CompanyDetails companyDetails = CompanyDetails();
  final Repository _repository = Repository();
  bool loading = false;


  getCompanyDetails(String lng, String companyId) async {
    loading = true;
    companyDetails = await _repository.getCompanyDetails(lng,companyId);
    loading = false;

    notifyListeners();
  }


}

