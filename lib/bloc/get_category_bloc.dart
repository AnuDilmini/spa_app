import 'package:flutter_app/model/category_response.dart';
import 'package:flutter_app/model/company_response.dart';
import 'package:flutter_app/network/repository.dart';
import 'package:rxdart/rxdart.dart';

class CategoryListBloc {
  final Repository _repository = Repository();
  final BehaviorSubject<CategoryResponse> _subject =
  BehaviorSubject<CategoryResponse>();

  getCategory(String lng) async {
    CategoryResponse response = await _repository.getCategory(lng);
    _subject.sink.add(response);
  }

  dispose() {
    _subject.close();
  }

  BehaviorSubject<CategoryResponse> get subject => _subject;
}

final categoryListBloc = CategoryListBloc();