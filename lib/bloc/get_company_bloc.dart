import 'package:flutter_app/model/company_response.dart';
import 'package:flutter_app/network/repository.dart';
import 'package:rxdart/rxdart.dart';

class CompanyListBloc {
  final Repository _repository = Repository();
  final BehaviorSubject<CompanyResponse> _subject =
  BehaviorSubject<CompanyResponse>();

  getCompany(String lng, String apiCall, String categoryId) async {
    CompanyResponse response = await _repository.getCompany(lng, apiCall, categoryId);
    _subject.sink.add(response);
  }

  dispose() {
    _subject.close();
  }

  BehaviorSubject<CompanyResponse> get subject => _subject;
}

final companyListBloc = CompanyListBloc();