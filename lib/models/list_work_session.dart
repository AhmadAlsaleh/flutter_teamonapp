import 'package:flutter_teamonapp/models/user_model.dart';
import 'package:flutter_teamonapp/models/work_session_model.dart';

class ListWorkSession {
  final List<WorkSessionModel> workSessions;

  ListWorkSession({required this.workSessions});

  List<UserModel> getUsers() {
    var users = workSessions.map((session) => session.user).toList();
    return users.fold(
        [],
        (previous, current) =>
            previous.any((element) => element.id == current.id)
                ? previous
                : [...previous, current]);
  }

  List<WorkSessionModel> getUserSessions(UserModel user) =>
      workSessions.where((session) => session.userId == user.id).toList();

  Duration getUserWorkDuration(UserModel user) => getUserSessions(user)
      .map((session) => session.getWorkDuration() ?? Duration.zero)
      .reduce((a, b) => a + b);

  Duration getUserBreakDuration(UserModel user) => getUserSessions(user)
      .map((session) => session.getBreakDuration() ?? Duration.zero)
      .reduce((a, b) => a + b);
}
