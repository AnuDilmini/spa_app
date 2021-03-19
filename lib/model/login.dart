// To parse this JSON data, do
//
//     final user = userFromJson(jsonString);

import 'dart:convert';

User userFromJson(String str) => User.fromJson(json.decode(str));

String userToJson(User data) => json.encode(data.toJson());

class User {
  User({
    this.user,
  });

  UserClass user;

  factory User.fromJson(Map<String, dynamic> json) => User(
    user: UserClass.fromJson(json["user"]),
  );

  Map<String, dynamic> toJson() => {
    "user": user.toJson(),
  };
}

class UserClass {
  UserClass({
    this.id,
    this.email,
    this.gender,
    this.mobile,
    this.personalImage,
    this.otpPassword,
    this.name,
    this.address,
  });

  String id;
  dynamic email;
  dynamic gender;
  String mobile;
  dynamic personalImage;
  int otpPassword;
  dynamic name;
  dynamic address;

  factory UserClass.fromJson(Map<String, dynamic> json) => UserClass(
    id: json["id"],
    email: json["email"],
    gender: json["gender"],
    mobile: json["mobile"],
    personalImage: json["personal_image"],
    otpPassword: json["otp_password"],
    name: json["name"],
    address: json["address"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "email": email,
    "gender": gender,
    "mobile": mobile,
    "personal_image": personalImage,
    "otp_password": otpPassword,
    "name": name,
    "address": address,
  };
}
