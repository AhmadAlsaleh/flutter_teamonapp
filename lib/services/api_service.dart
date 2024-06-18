import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_teamonapp/core/constants/app_constants.dart';
import 'package:flutter_teamonapp/core/extensions/date_time_ext.dart';
import 'package:flutter_teamonapp/models/auth_model.dart';
import 'package:flutter_teamonapp/models/notification_model.dart';
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

  Future<AuthModel> login(String username, String password) async {
    final response = await _networkService.post(AppConstants.loginEndpoint, {
      'username': username,
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

  Future<UserModel?> getUser(int id, {String? token}) async {
    final response = await _networkService.get(
      '${AppConstants.usersEndpoint}/$id',
      token: token,
    );
    return UserModel.fromJson(response);
  }

  Future<List<NotificationModel>> getNotifications(
      {String? token, int? userId}) async {
    final response = await _networkService
        .get("${AppConstants.notificationsEndpoint}/$userId", token: token);

    return notificationFromJson(jsonEncode(response["notifications"]));
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
        "dateTime": stepModel.dateTime.toIso8601String(),
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
