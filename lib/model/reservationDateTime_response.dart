import 'ReservationTimeDate.dart';

class ReservationDateTimeResponse {
  final ReservationDateTime reservationDateTime;
  final String error;

  ReservationDateTimeResponse(this.reservationDateTime, this.error);

  ReservationDateTimeResponse.fromJson(Map<String, dynamic> json)
      : reservationDateTime = (json["data"]),
        error = "";

}
