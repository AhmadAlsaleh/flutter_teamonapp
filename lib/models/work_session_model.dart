import 'dart:convert';

import 'package:flutter_teamonapp/models/user_model.dart';
import 'package:flutter_teamonapp/models/work_step_model.dart';
import 'package:flutter_teamonapp/widgets/work_session_step.dart';
import 'package:tuple/tuple.dart';

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

  Duration? getWorkDuration() {
    Duration? duration;
    int i = 0;
    while (i < workSteps.length) {
      var next = getNextWork(i);

      if (next.item1 == null) break;
      duration ??= Duration.zero;
      duration += next.item1 ?? Duration.zero;

      if (next.item2 == null) break;
      i = next.item2!;
    }

    if (duration == null) return null;

    Duration breaks = getBreakDuration() ?? Duration.zero;
    return duration - breaks;
  }

  Duration? getBreakDuration() {
    Duration? duration;
    int i = 0;
    while (i < workSteps.length) {
      var next = getNextBreak(i);

      if (next.item1 == null) break;
      duration ??= Duration.zero;
      duration += next.item1 ?? Duration.zero;

      if (next.item2 == null) break;
      i = next.item2!;
    }

    return duration;
  }

  Tuple2<Duration?, int?> getNextWork(int index) {
    int? start = getNextStep(index, WorkSessionStep.START_WORK);
    if (start == null) {
      return const Tuple2(null, null);
    }

    int? end = getNextStep(start, WorkSessionStep.END_WORK);
    if (end == null) {
      return Tuple2(DateTime.now().difference(workSteps[start].dateTime), null);
    }

    var diff = workSteps[end].dateTime.difference(workSteps[start].dateTime);
    return Tuple2(diff, end);
  }

  Tuple2<Duration?, int?> getNextBreak(int index) {
    int? start = getNextStep(index, WorkSessionStep.START_BREAK);
    if (start == null) {
      return const Tuple2(null, null);
    }

    int? end = getNextStep(start, WorkSessionStep.END_BREAK);
    if (end == null) {
      return Tuple2(DateTime.now().difference(workSteps[start].dateTime), null);
    }

    var diff = workSteps[end].dateTime.difference(workSteps[start].dateTime);
    return Tuple2(diff, end);
  }

  int? getNextStep(int index, String type) {
    for (var i = index; i < workSteps.length; i++) {
      if (workSteps[i].type == type) {
        return i;
      }
    }
    return null;
  }

  factory WorkSessionModel.fromJson(Map<String, dynamic> json) =>
      WorkSessionModel(
        id: json["id"],
        userId: json["userId"],
        date: DateTime.parse(json["date"]).toLocal(),
        user: UserModel.fromJson(json["user"]),
        workSteps: List<WorkStepModel>.from(
            json["workSteps"].map((x) => WorkStepModel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "userId": userId,
        "date": date.toUtc().toIso8601String(),
        "user": user.toJson(),
        "workSteps": List<dynamic>.from(workSteps.map((x) => x.toJson())),
      };
}
