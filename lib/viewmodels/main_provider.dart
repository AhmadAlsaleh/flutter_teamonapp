import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final selectedMainDateRangeProvider = StateProvider<DateTimeRange>(
    (ref) => DateTimeRange(start: DateTime.now(), end: DateTime.now()));

final selectedMainDateProvider =
    StateProvider<DateTime>((ref) => DateTime.now());

final selectedMainPageIndexProvider = StateProvider<int>((ref) => 0);

final currentWorkDuration = StateProvider<Duration>((ref) => const Duration());

final currentBreakDuration = StateProvider<Duration>((ref) => const Duration());
