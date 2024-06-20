import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_teamonapp/models/auth_model.dart';
import 'package:flutter_teamonapp/services/api_service.dart';
import 'package:flutter_teamonapp/services/firebase/push_notifications.dart';
import 'package:flutter_teamonapp/utils/storage_helper.dart';

final authViewModelProvider =
    StateNotifierProvider<AuthNotifier, AsyncValue<AuthModel?>>((ref) {
  return AuthNotifier(
    ref.read(apiServiceProvider),
    ref.read(fcmProvider),
  );
});

class AuthNotifier extends StateNotifier<AsyncValue<AuthModel?>> {
  final ApiService _apiService;
  final PushNotificationService _pushNotificationService;

  AuthNotifier(this._apiService, this._pushNotificationService)
      : super(const AsyncData(null)) {
    loadAuthModel();
  }

  void loadAuthModel() async {
    state = const AsyncValue.loading();
    var savedAuthModel = await StorageHelper.loadAuthModel();

    if (savedAuthModel == null) {
      state = const AsyncValue.data(null);
      return;
    }

    try {
      var isValid = await _apiService.checkToken(savedAuthModel.token);
      state = isValid
          ? AsyncValue.data(savedAuthModel)
          : const AsyncValue.data(null);
    } catch (e, s) {
      state = AsyncValue.error(e, s);
    }
  }

  Future<bool> addFCMToken() async {
    try {
      var fcm = await _pushNotificationService.getFCMToken();
      var result = await _apiService.addFCMToken(
        state.value?.userId,
        fcm,
        token: state.value?.token,
      );
      return result;
    } catch (e) {
      return false;
    }
  }

  void login(String email, String password) async {
    try {
      state = const AsyncValue.loading();
      var result = await _apiService.login(email, password);

      state = AsyncValue.data(result);
      await StorageHelper.saveAuthModel(result);
      await addFCMToken();
    } catch (e, s) {
      state = AsyncValue.error(e, s);
    }
  }

  void logout() async {
    var userId = state.value?.userId;
    var token = state.value?.token;

    state = const AsyncValue.loading();
    await StorageHelper.removeAuthModel();
    await _apiService.logout(id: userId, token: token);
    state = const AsyncValue.data(null);
  }
}
