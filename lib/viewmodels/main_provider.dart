import 'package:flutter_riverpod/flutter_riverpod.dart';

final selectedMainDateProvider =
    StateProvider<DateTime>((ref) => DateTime.now());

final selectedMainPageIndexProvider = StateProvider<int>((ref) => 0);

final currentWorkDuration = StateProvider<Duration>((ref) => const Duration());

final currentBreakDuration = StateProvider<Duration>((ref) => const Duration());
