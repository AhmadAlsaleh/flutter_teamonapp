import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_teamonapp/models/add_user_model.dart';

final addEmployeeProvider = StateProvider<AddUserModel?>((ref) => null);

final currentPageProvider = StateProvider<int>((ref) => 0);
