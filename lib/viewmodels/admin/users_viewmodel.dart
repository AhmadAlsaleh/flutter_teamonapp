import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_teamonapp/models/add_user_model.dart';
import 'package:flutter_teamonapp/models/auth_model.dart';
import 'package:flutter_teamonapp/models/user_model.dart';
import 'package:flutter_teamonapp/services/api_service.dart';
import 'package:flutter_teamonapp/viewmodels/auth_viewmodel.dart';

final usersProvider =
    StateNotifierProvider<UsersNotifier, AsyncValue<List<UserModel>>>(
  (ref) => UsersNotifier(
    ref.read(apiServiceProvider),
    ref.watch(authViewModelProvider),
  ),
);

class UsersNotifier extends StateNotifier<AsyncValue<List<UserModel>>> {
  final ApiService _apiService;
  final AsyncValue<AuthModel?> authModelAsync;

  List<UserModel> _allUsers = [];

  UsersNotifier(this._apiService, this.authModelAsync)
      : super(const AsyncData([])) {
    fetchData();
  }

  void fetchData() async {
    try {
      var authModel = authModelAsync.valueOrNull;
      if (authModel == null) return;
      state = const AsyncValue.loading();
      _allUsers = await _apiService.getUsers(token: authModel.token);
      state = AsyncValue.data(_allUsers);
    } catch (e, s) {
      state = AsyncValue.error(e, s);
    }
  }

  void search(String q) async {
    try {
      var filteredUsers = _allUsers
          .where((user) =>
              user.fullName.toLowerCase().contains(q.toLowerCase()) ||
              user.email.toLowerCase().contains(q.toLowerCase()) ||
              user.profession.toLowerCase().contains(q.toLowerCase()))
          .toList();

      state = AsyncValue.data(filteredUsers);
    } catch (e, s) {
      state = AsyncValue.error(e, s);
    }
  }

  Future<bool> deleteUser(int id) async {
    var authModel = authModelAsync.valueOrNull;
    if (authModel == null) return false;

    state = const AsyncValue.loading();
    var isDeleted = await _apiService.deleteUser(id, token: authModel.token);
    if (isDeleted) fetchData();

    state = AsyncValue.data(_allUsers);
    return isDeleted;
  }

  Future<bool> addUser(AddUserModel model) async {
    var authModel = authModelAsync.valueOrNull;
    if (authModel == null) return false;

    state = const AsyncValue.loading();
    var addedUser = await _apiService.addUser(model, token: authModel.token);
    if (addedUser != null) fetchData();

    state = AsyncValue.data(_allUsers);
    return addedUser != null;
  }

  Future<bool> updateUser(UserModel model) async {
    var authModel = authModelAsync.valueOrNull;
    if (authModel == null) return false;

    state = const AsyncValue.loading();
    var updated = await _apiService.updateUser(model, token: authModel.token);
    if (updated != null) fetchData();

    state = AsyncValue.data(_allUsers);
    return updated != null;
  }
}
