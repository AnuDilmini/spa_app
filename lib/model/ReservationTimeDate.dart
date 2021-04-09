import 'dart:convert';

class ReservationDateTime {
  final String id;
  final String start_time;
  final String type_reservation;
  final String employee_id;
  final String service_id;
  final String total_min;
  final String end_time;


  ReservationDateTime({this.id, this.start_time, this.type_reservation, this.employee_id, this.service_id, this.total_min, this.end_time});

  ReservationDateTime.fromJson(Map<String, dynamic> json)
      : id =  json["id"],
        start_time = json["start_time"],
        type_reservation = json["type_reservation"],
        employee_id = json["employee_id"],
        service_id = json["service_id"],
        total_min = json["total_min"],
        end_time = json["end_time"];

  static Map<String, dynamic> toMap(ReservationDateTime reservationDateTime) => {
    'id': reservationDateTime.id,
    'start_time': reservationDateTime.start_time,
    'type_reservation': reservationDateTime.type_reservation,
    'employee_id': reservationDateTime.employee_id,
    'service_id': reservationDateTime.service_id,
    'total_min': reservationDateTime.total_min,
    'end_time': reservationDateTime.end_time,
  };

  static String encode(List<ReservationDateTime> reservationDateTime) => json.encode(
    reservationDateTime
        .map<Map<String, dynamic>>((reservationDateTime) => ReservationDateTime.toMap(reservationDateTime))
        .toList(),
  );

  static List<ReservationDateTime> decode(String musics) =>
      (json.decode(musics) as List<dynamic>)
          .map<ReservationDateTime>((item) => ReservationDateTime.fromJson(item))
          .toList();

}
