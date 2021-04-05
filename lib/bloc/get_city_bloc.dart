import 'package:violet_app/model/city_response.dart';
import 'package:violet_app/model/company_response.dart';
import 'package:violet_app/network/repository.dart';
import 'package:rxdart/rxdart.dart';

class CityListBloc {
  final Repository _repository = Repository();
  final BehaviorSubject<CityResponse> _subject =
  BehaviorSubject<CityResponse>();

  getCity(String lng) async {
    CityResponse response = await _repository.getCity(
        lng);
    _subject.sink.add(response);
  }

  dispose() {
    _subject.close();
  }

  BehaviorSubject<CityResponse> get subject => _subject;
}

final cityListBloc = CityListBloc();