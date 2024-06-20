import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_teamonapp/core/constants/app_constants.dart';
import 'package:flutter_teamonapp/core/extensions/date_time_ext.dart';
import 'package:flutter_teamonapp/models/add_user_model.dart';
import 'package:flutter_teamonapp/models/auth_model.dart';
import 'package:flutter_teamonapp/models/notification_model.dart';
import 'package:flutter_teamonapp/models/push_notification_model.dart';
import 'package:flutter_teamonapp/models/user_model.dart';
import 'package:flutter_teamonapp/models/work_session_model.dart';
import 'package:flutter_teamonapp/models/work_step_model.dart';
import 'package:flutter_teamonapp/services/network_service.dart';

class ApiService {
  final NetworkService _networkService;

  ApiService(this._networkService);

  Future<bool> checkToken(String token) async {
    final response =
        await _networkService.get(AppConstants.checkAuthEndpoint, token: token);
    return response['code'] == 200;
  }

  Future<AuthModel> login(String email, String password) async {
    final response = await _networkService.post(AppConstants.loginEndpoint, {
      'email': email,
      'password': password,
    });
    return AuthModel.fromJson(response);
  }

  Future<bool> addFCMToken(int? userId, String? fcmToken,
      {String? token}) async {
    final response = await _networkService.post(
      AppConstants.addFCMTokenEndpoint,
      {
        'userId': userId,
        'token': fcmToken,
      },
      token: token,
    );
    return response["code"] == 200;
  }

  Future<bool> logout({int? id, String? token}) async {
    try {
      var response = await _networkService
          .get("${AppConstants.logoutEndpoint}/$id", token: token);
      return response['code'] == 200;
    } catch (e) {
      return false;
    }
  }

  Future<List<UserModel>> getUsers({String? token}) async {
    final response = await _networkService.get(
      AppConstants.usersEndpoint,
      token: token,
    );
    return usersFromJson(jsonEncode(response["users"]));
  }

  Future<bool> deleteUser(int id, {String? token}) async {
    final response = await _networkService.delete(
      "${AppConstants.usersEndpoint}/$id",
      token: token,
    );

    return response["code"] == 200;
  }

  Future<UserModel?> addUser(AddUserModel model, {String? token}) async {
    try {
      final response = await _networkService.post(
        AppConstants.usersEndpoint,
        model.toJson(),
        token: token,
      );

      return UserModel.fromJson(response);
    } catch (e) {
      return null;
    }
  }

  Future<UserModel?> updateUser(UserModel model, {String? token}) async {
    try {
      final response = await _networkService.put(
        "${AppConstants.usersEndpoint}/${model.id}",
        {
          "fullName": model.fullName,
          "role": model.role,
          "profession": model.profession,
          "isActive": model.isActive,
        },
        token: token,
      );

      return UserModel.fromJson(response);
    } catch (e) {
      return null;
    }
  }

  Future<UserModel?> getUser(int id, {String? token}) async {
    final response = await _networkService.get(
      '${AppConstants.usersEndpoint}/$id',
      token: token,
    );
    return UserModel.fromJson(response);
  }

  Future<bool> pushNotifications(PushNotificationModel model,
      {String? token}) async {
    final response = await _networkService.post(
        AppConstants.sendNotificationsEndpoint, model.toJson(),
        token: token);

    return response["code"] == 200;
  }

  Future<List<NotificationModel>> getSentNotifications(
      {String? token, int? userId}) async {
    final response = await _networkService
        .get("${AppConstants.sentNotificationsEndpoint}/$userId", token: token);

    return notificationModelFromJson(jsonEncode(response["notifications"]));
  }

  Future<List<NotificationModel>> getNotifications(
      {String? token, int? userId}) async {
    final response = await _networkService.get(
        "${AppConstants.receivedNotificationsEndpoint}/$userId",
        token: token);

    return notificationModelFromJson(jsonEncode(response["notifications"]));
  }

  Future<bool> readNotification(String? token, int? userId, int? id) async {
    final response = await _networkService.post(
      AppConstants.readNotificationEndpoint,
      {
        "userId": userId,
        "id": id,
      },
      token: token,
    );

    return response["code"] == 200;
  }

  Future<List<WorkSessionModel>> getAdminWorkSessions(
      {String? token, required DateTimeRange dateRange}) async {
    final response = await _networkService.post(
        AppConstants.filterWorkSessionsEndpoint,
        {
          "start_date": dateRange.start.toUtc().getDate(),
          "end_date": dateRange.end.toUtc().getDate(),
        },
        token: token);
    return workSessionFromJson(jsonEncode(response["workSessions"]));
  }

  Future<List<WorkSessionModel>> getWorkSessions(
      {String? token, int? userId, DateTime? dateTime}) async {
    final response = await _networkService
        .get(AppConstants.workSessionsEndpoint, token: token, queryParameters: {
      "userId": userId,
      "date": dateTime?.getYYYYMMDD(),
    });
    return workSessionFromJson(jsonEncode(response["workSessions"]));
  }

  Future<WorkSessionModel> startWorkSession(
      String? token, int? userId, DateTime? dateTime) async {
    final response = await _networkService.post(
      AppConstants.workSessionsEndpoint,
      {
        "userId": userId,
        "date": dateTime?.getYYYYMMDD(),
      },
      token: token,
    );

    return WorkSessionModel.fromJson(response);
  }

  Future<WorkStepModel> addWorkStep(
      WorkStepModel stepModel, String? token) async {
    final response = await _networkService.post(
      AppConstants.workStepsEndpoint,
      {
        "workSessionId": stepModel.workSessionId,
        "dateTime": stepModel.dateTime.toUtc().toIso8601String(),
        "type": stepModel.type,
        "latitude": 0.0,
        "longitude": 0.0,
      },
      token: token,
    );
    return WorkStepModel.fromJson(response);
  }
}

final apiServiceProvider = Provider<ApiService>((ref) {
  return ApiService(ref.read(networkServiceProvider));
});
