// To parse this JSON data, do
//
//     final subjectAttendance = subjectAttendanceFromJson(jsonString);

import 'dart:convert';

SubjectAcademic subjectAcademicFromJson(String str) =>
    SubjectAcademic.fromJson(json.decode(str));

String subjectAcademicToJson(SubjectAcademic data) =>
    json.encode(data.toJson());

class SubjectAcademic {
  SubjectAcademic({
    required this.body,
  });

  List<Body> body;

  factory SubjectAcademic.fromJson(Map<String, dynamic> json) =>
      SubjectAcademic(
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
    required this.obtainedMarks,
    required this.totalMarks,
  });

  final String name;
  final int targetPercentage;
  int obtainedMarks;
  int totalMarks;

  factory Body.fromJson(Map<String, dynamic> json) => Body(
        name: json["name "],
        targetPercentage: json["targetPercentage"],
        obtainedMarks: json["obtainedMarks"],
        totalMarks: json["totalMarks"],
      );

  Map<String, dynamic> toJson() => {
        "name ": name,
        "targetPercentage": targetPercentage,
        "obtainedMarks": obtainedMarks,
        "totalMarks": totalMarks,
      };
}
