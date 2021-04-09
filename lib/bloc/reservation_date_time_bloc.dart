// import 'package:flutter/cupertino.dart';
// import 'package:rxdart/rxdart.dart';
// import 'package:violet_app/model/ReservationTimeDate.dart';
// import 'package:violet_app/model/reservationDateTime_response.dart';
// import 'package:violet_app/network/repository.dart';
//
// class ReservationDateTimeBloc {
//   final Repository _repository = Repository();
//   final BehaviorSubject<ReservationDateTimeResponse> _subject =
//   BehaviorSubject<ReservationDateTimeResponse>();
//
//   getCompanyService(String lng, String companyId) async {
//     ReservationDateTimeResponse response = await _repository.postReservationDateTime(lng, companyId);
//     _subject.sink.add(response);
//   }
//
//   dispose() {
//     _subject.close();
//   }
//
//   BehaviorSubject<ReservationDateTimeResponse> get subject => _subject;
// }
//
// final reservationDateTimeBloc = ReservationDateTimeBloc();