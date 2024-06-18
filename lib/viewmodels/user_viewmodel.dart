import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_teamonapp/models/auth_model.dart';
import 'package:flutter_teamonapp/models/user_model.dart';
import 'package:flutter_teamonapp/services/api_service.dart';
import 'package:flutter_teamonapp/viewmodels/auth_viewmodel.dart';

final userViewModelProvider =
    StateNotifierProvider<UserNotifier, AsyncValue<UserModel?>>(
  (ref) => UserNotifier(
    ref.read(apiServiceProvider),
    ref.watch(authViewModelProvider),
  ),
);

class UserNotifier extends StateNotifier<AsyncValue<UserModel?>> {
  final ApiService _apiService;
  final AsyncValue<AuthModel?> authModelAsync;

  UserNotifier(this._apiService, this.authModelAsync)
      : super(const AsyncData(null)) {
    var authModel = authModelAsync.value;
    if (authModel != null) getUser(authModel.userId, token: authModel.token);
  }

  void getUser(int id, {String? token}) async {
    state = const AsyncValue.loading();
    try {
      var userInfo = await _apiService.getUser(id, token: token);
      state = AsyncValue.data(userInfo);
    } catch (e, s) {
      state = AsyncValue.error(e, s);
    }
  }
}
