import 'dart:async';

import 'package:flutter_app/model/login.dart';
import 'package:flutter_app/network/api_response.dart';
import 'package:flutter_app/network/repository.dart';


class UserLoginBloc {
  bool connectionState = false;
  Repository _repository;

  StreamController _userController;

  StreamSink<ApiResponse<User>> get userSink =>
      _userController.sink;

  Stream<ApiResponse<User>> get userStream =>
      _userController.stream;

  userBloc() {
    _userController = StreamController<ApiResponse<User>>();
    _repository = Repository();
    fetchUser();
  }

  fetchUser() async {
    userSink.add(ApiResponse.loading('Fetching track list'));
    try {
      User userResponse =
      await _repository.fetchLogin();
      userSink.add(ApiResponse.completed(userResponse));
    } catch (e) {
      userSink.add(ApiResponse.error(e.toString()));
      print(e);
    }
  }

  dispose() {
    _userController?.close();
  }
}