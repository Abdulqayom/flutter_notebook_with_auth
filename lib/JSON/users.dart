
import 'dart:convert';

Users usersFromMap(String str) => Users.fromMap(json.decode(str));

String usersToMap(Users data) => json.encode(data.toMap());

class Users {
  final int? usrId;
  final String? fullName;
  final String? email;
  final String? usrImage;
  final String usrName;
  final String password;

  Users({
    this.usrId,
    this.fullName,
    this.email,
    this.usrImage,
    required this.usrName,
    required this.password,
  });

  //These json value must be same as your column name in database that we have already defined
  //one column didn't match
  factory Users.fromMap(Map<String, dynamic> json) => Users(
    usrId: json["usrId"],
    fullName: json["fullName"],
    email: json["email"],
    usrImage: json["usrImage"],
    usrName: json["usrName"],
    password: json["usrPassword"],
  );

  Map<String, dynamic> toMap() => {
    "usrId": usrId,
    "fullName": fullName,
    "email": email,
    "usrImage": usrImage,
    "usrName": usrName,
    "usrPassword": password,
  };
}
