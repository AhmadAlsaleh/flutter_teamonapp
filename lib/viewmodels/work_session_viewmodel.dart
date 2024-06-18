import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_teamonapp/models/auth_model.dart';
import 'package:flutter_teamonapp/models/work_session_model.dart';
import 'package:flutter_teamonapp/models/work_step_model.dart';
import 'package:flutter_teamonapp/services/api_service.dart';
import 'package:flutter_teamonapp/viewmodels/auth_viewmodel.dart';
import 'package:flutter_teamonapp/viewmodels/main_provider.dart';
import 'package:flutter_teamonapp/widgets/work_session_step.dart';

final workSessionViewModelProvider = StateNotifierProvider<WorkSessionNotifier,
    AsyncValue<List<WorkSessionModel>>>(
  (ref) => WorkSessionNotifier(
    ref.read(apiServiceProvider),
    ref.watch(authViewModelProvider),
    ref.watch(selectedMainDateProvider),
  ),
);

class WorkSessionNotifier
    extends StateNotifier<AsyncValue<List<WorkSessionModel>>> {
  final ApiService _apiService;
  final DateTime selectedDate;
  final AsyncValue<AuthModel?> authModelAsync;

  WorkSessionNotifier(
    this._apiService,
    this.authModelAsync,
    this.selectedDate,
  ) : super(const AsyncData([])) {
    fetchData();
  }

  void fetchData() async {
    var authModel = authModelAsync.value;

    state = const AsyncValue.loading();
    try {
      var sessions = await _apiService.getWorkSessions(
        token: authModel?.token,
        userId: authModel?.userId,
        dateTime: selectedDate,
      );
      state = AsyncValue.data(sessions);
    } catch (e, s) {
      state = AsyncValue.error(e, s);
    }
  }

  void startSession() async {
    try {
      state = const AsyncValue.loading();

      var token = authModelAsync.value?.token;
      var userId = authModelAsync.value?.userId;

      var session =
          await _apiService.startWorkSession(token, userId, selectedDate);
      DateTime time = DateTime.now().copyWith(
        year: selectedDate.year,
        month: selectedDate.month,
        day: selectedDate.day,
      );

      addStep(
        WorkStepModel(
          id: 0,
          workSessionId: session.id,
          dateTime: time,
          type: WorkSessionStep.START_WORK,
        ),
      );
    } catch (e, s) {
      state = AsyncValue.error(e, s);
    }
  }

  void addStep(WorkStepModel stepModel) async {
    try {
      state = const AsyncValue.loading();

      var token = authModelAsync.value?.token;
      await _apiService.addWorkStep(stepModel, token);
      fetchData();
    } catch (e, s) {
      state = AsyncValue.error(e, s);
    }
  }
}
