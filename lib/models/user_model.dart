import 'dart:convert';

import 'package:flutter_teamonapp/utils/date_helper.dart';

List<UserModel> usersFromJson(String str) =>
    List<UserModel>.from(json.decode(str).map((x) => UserModel.fromJson(x)));

class UserModel {
  final int id;
  final String fullName;
  final String email;
  final String role;
  final String profession;
  final bool isActive;
  final double? salary;
  final double? workHours;
  final double? breakHours;
  final String? workdays;

  UserModel({
    required this.id,
    required this.fullName,
    required this.email,
    required this.role,
    required this.profession,
    required this.isActive,
    this.salary,
    this.workHours,
    this.breakHours,
    this.workdays,
  });

  double salaryPerMinute(int month, int minutes) {
    if (salary == null || workHours == null) return 0.0;

    int workingDayPerMonth = DateHelper.calculateWorkingDaysForMonth(month);
    double perMinutes = salary! / (workingDayPerMonth * workHours! * 60);
    return minutes * perMinutes;
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      fullName: json['fullName'],
      email: json['email'],
      role: json['role'],
      profession: json['profession'],
      isActive: json['isActive'],
      salary:
          json['salary'] == null ? 0.0 : double.tryParse("${json['salary']}"),
      workHours: json['workHours'] == null
          ? 0.0
          : double.tryParse("${json['workHours']}"),
      breakHours: json['breakHours'] == null
          ? 0.0
          : double.tryParse("${json['breakHours']}"),
      workdays: json['workdays'],
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "fullName": fullName,
        "email": email,
        "role": role,
        "profession": profession,
        "isActive": isActive,
        "salary": salary,
        "workHours": workHours,
        "breakHours": breakHours,
        "workdays": workdays,
      };

  UserModel copyWith({
    int? id,
    String? fullName,
    String? email,
    String? role,
    String? profession,
    bool? isActive,
    double? salary,
    double? workHours,
    double? breakHours,
    String? workdays,
  }) {
    return UserModel(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      role: role ?? this.role,
      profession: profession ?? this.profession,
      isActive: isActive ?? this.isActive,
      salary: salary ?? this.salary,
      workHours: workHours ?? this.workHours,
      breakHours: breakHours ?? this.breakHours,
      workdays: workdays ?? this.workdays,
    );
  }
}
