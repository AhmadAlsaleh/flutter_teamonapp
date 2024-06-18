import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_teamonapp/models/auth_model.dart';
import 'package:flutter_teamonapp/services/api_service.dart';
import 'package:flutter_teamonapp/utils/storage_helper.dart';

final authViewModelProvider =
    StateNotifierProvider<AuthNotifier, AsyncValue<AuthModel?>>(
        (ref) => AuthNotifier(ref.read(apiServiceProvider)));

class AuthNotifier extends StateNotifier<AsyncValue<AuthModel?>> {
  final ApiService _apiService;

  AuthNotifier(this._apiService) : super(const AsyncData(null)) {
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

  void login(String username, String password) async {
    try {
      state = const AsyncValue.loading();
      var result = await _apiService.login(username, password);

      state = AsyncValue.data(result);
      await StorageHelper.saveAuthModel(result);
    } catch (e, s) {
      state = AsyncValue.error(e, s);
    }
  }

  void logout() async {
    state = const AsyncValue.loading();
    var isLoggedOut = await _apiService.logout(state.value?.token);
    if (isLoggedOut) {
      await StorageHelper.removeAuthModel();
      state = const AsyncValue.data(null);
    }
  }
}
