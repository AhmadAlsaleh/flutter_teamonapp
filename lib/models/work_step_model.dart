class WorkStepModel {
  int id;
  int workSessionId;
  DateTime dateTime;
  String type;

  WorkStepModel({
    required this.id,
    required this.workSessionId,
    required this.dateTime,
    required this.type,
  });

  factory WorkStepModel.fromJson(Map<String, dynamic> json) => WorkStepModel(
        id: json["id"],
        workSessionId: json["workSessionId"],
        dateTime: DateTime.parse(json["dateTime"]).toLocal(),
        type: json["type"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "workSessionId": workSessionId,
        "dateTime": dateTime.toUtc().toIso8601String(),
        "type": type,
      };
}
