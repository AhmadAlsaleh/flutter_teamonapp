import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_teamonapp/models/auth_model.dart';
import 'package:flutter_teamonapp/models/work_session_model.dart';
import 'package:flutter_teamonapp/services/api_service.dart';
import 'package:flutter_teamonapp/viewmodels/auth_viewmodel.dart';
import 'package:flutter_teamonapp/viewmodels/main_provider.dart';

final adminWorkSessionProvider = StateNotifierProvider<AdminWorkSessionNotifier,
    AsyncValue<List<WorkSessionModel>>>(
  (ref) => AdminWorkSessionNotifier(
    ref.read(apiServiceProvider),
    ref.watch(authViewModelProvider),
    ref.watch(selectedMainDateRangeProvider),
  ),
);

class AdminWorkSessionNotifier
    extends StateNotifier<AsyncValue<List<WorkSessionModel>>> {
  final ApiService _apiService;
  final DateTimeRange selectedDateRange;
  final AsyncValue<AuthModel?> authModelAsync;

  AdminWorkSessionNotifier(
    this._apiService,
    this.authModelAsync,
    this.selectedDateRange,
  ) : super(const AsyncData([])) {
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      var authModel = authModelAsync.valueOrNull;

      state = const AsyncValue.loading();
      var sessions = await _apiService.getAdminWorkSessions(
        token: authModel?.token,
        dateRange: selectedDateRange,
      );
      state = AsyncValue.data(sessions);
    } catch (e, s) {
      state = AsyncValue.error(e, s);
    }
  }
}
