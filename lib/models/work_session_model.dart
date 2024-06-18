import 'dart:convert';

import 'package:flutter_teamonapp/models/user_model.dart';
import 'package:flutter_teamonapp/models/work_step_model.dart';

List<WorkSessionModel> workSessionFromJson(String str) =>
    List<WorkSessionModel>.from(
        json.decode(str).map((x) => WorkSessionModel.fromJson(x)));

class WorkSessionModel {
  int id;
  int userId;
  DateTime date;
  UserModel user;
  List<WorkStepModel> workSteps;

  WorkSessionModel({
    required this.id,
    required this.userId,
    required this.user,
    required this.date,
    required this.workSteps,
  });

  factory WorkSessionModel.fromJson(Map<String, dynamic> json) =>
      WorkSessionModel(
        id: json["id"],
        userId: json["userId"],
        date: DateTime.parse(json["date"]),
        user: UserModel.fromJson(json["user"]),
        workSteps: List<WorkStepModel>.from(
            json["workSteps"].map((x) => WorkStepModel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "userId": userId,
        "date": date.toIso8601String(),
        "user": user.toJson(),
        "workSteps": List<dynamic>.from(workSteps.map((x) => x.toJson())),
      };
}
