import 'package:violet_app/model/companyService_response.dart';
import 'package:violet_app/network/repository.dart';
import 'package:rxdart/rxdart.dart';


class CompanyServiceBloc {
  final Repository _repository = Repository();
  final BehaviorSubject<CompanyServiceResponse> _subject =
  BehaviorSubject<CompanyServiceResponse>();

  getCompanyService(String lng, String companyId) async {
    CompanyServiceResponse response = await _repository.getCompanyServices(lng, companyId);
    _subject.sink.add(response);
  }

  dispose() {
    _subject.close();
  }

  BehaviorSubject<CompanyServiceResponse> get subject => _subject;
}

final companyServiceBloc = CompanyServiceBloc();