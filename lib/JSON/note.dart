
import 'dart:convert';

Note usersFromMap(String str) => Note.fromMap(json.decode(str));

String usersToMap(Note data) => json.encode(data.toMap());

class Note {
  final int? notId;
  final int? userId;
  final String? title;
  final String? description;
  final String? image;


  Note({
    this.notId,
    this.userId,
    this.title,
    this.description,
    this.image,
 
  });

  //These json value must be same as your column name in database that we have already defined
  //one column didn't match
  factory Note.fromMap(Map<String, dynamic> json) => Note(
    notId: json["notId"],

    userId: json["userId"],
    title: json["title"],
    description: json["description"],
    image: json["image"],
  
  );

  Map<String, dynamic> toMap() => {
    "notId": notId,

    "userId": userId,
    "title": title,
    "description": description,
    "image": image,

  };
}