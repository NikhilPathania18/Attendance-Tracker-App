// To parse this JSON data, do
//
//     final subjectAttendance = subjectAttendanceFromJson(jsonString);

import 'dart:convert';

SubjectAttendance subjectAttendanceFromJson(String str) =>
    SubjectAttendance.fromJson(json.decode(str));

String subjectAttendanceToJson(SubjectAttendance data) =>
    json.encode(data.toJson());

class SubjectAttendance {
  SubjectAttendance({
    required this.body,
  });

  List<Body> body;

  factory SubjectAttendance.fromJson(Map<String, dynamic> json) =>
      SubjectAttendance(
        body: List<Body>.from(json["body"].map((x) => Body.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "body": List<dynamic>.from(body.map((x) => x.toJson())),
      };
}

class Body {
  Body({
    required this.name,
    required this.targetPercentage,
    required this.presentCount,
    required this.absentCount,
  });

  String name;
  int targetPercentage;
  int presentCount;
  int absentCount;

  factory Body.fromJson(Map<String, dynamic> json) => Body(
        name: json["name "],
        targetPercentage: json["targetPercentage"],
        presentCount: json["presentCount"],
        absentCount: json["absentCount"],
      );

  Map<String, dynamic> toJson() => {
        "name ": name,
        "targetPercentage": targetPercentage,
        "presentCount": presentCount,
        "absentCount": absentCount,
      };
}
