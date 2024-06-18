import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_teamonapp/core/constants/app_colors.dart';
import 'package:flutter_teamonapp/core/constants/app_dimens.dart';
import 'package:flutter_teamonapp/models/work_session_model.dart';
import 'package:flutter_teamonapp/viewmodels/work_session_viewmodel.dart';
import 'package:flutter_teamonapp/widgets/loading.dart';
import 'package:flutter_teamonapp/widgets/message.dart';
import 'package:flutter_teamonapp/widgets/work_session_step.dart';
import 'package:tuple/tuple.dart';

class HomeSummary extends ConsumerStatefulWidget {
  const HomeSummary({super.key});

  @override
  ConsumerState<HomeSummary> createState() => _HomeSummaryState();
}

class _HomeSummaryState extends ConsumerState<HomeSummary> {
  Timer? workTimer;
  String workText = " ";
  String breakText = " ";

  @override
  void dispose() {
    workTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var sessionsAsync = ref.watch(workSessionViewModelProvider);

    return sessionsAsync.when(
        data: (data) {
          var session = data.firstOrNull;
          if (session == null) return Container();

          workTimer?.cancel();
          workTimer = Timer.periodic(const Duration(seconds: 1), (Timer t) {
            Duration? workDuration = getWorkDuration(session);
            Duration? breakDuration = getBreakDuration(session);

            setState(() {
              workText = workDuration == null
                  ? "--"
                  : (workDuration - (breakDuration ?? Duration.zero))
                      .toString()
                      .split(".")[0];

              breakText = breakDuration == null
                  ? '--'
                  : breakDuration.toString().split(".")[0];
            });
          });

          return Row(
            children: [
              Expanded(
                child: Card(
                  color: AppColors.SECONDARY_LIGHT,
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(AppDimens.MAIN_SPACE),
                    title: const Text(
                      "Work",
                      style: TextStyle(fontSize: 28),
                    ),
                    subtitle: Text(
                      workText,
                      style: const TextStyle(fontSize: 24),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: AppDimens.MAIN_SPACE),
              Expanded(
                child: Card(
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(AppDimens.MAIN_SPACE),
                    title: const Text(
                      "Break",
                      style: TextStyle(fontSize: 28),
                    ),
                    subtitle: Text(
                      breakText,
                      style: const TextStyle(fontSize: 24),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
        error: (e, s) => const MessageWidget(),
        loading: () => const LoadingWidget());
  }

  Duration? getWorkDuration(WorkSessionModel data) {
    Duration? duration;
    int i = 0;
    while (i < data.workSteps.length) {
      var next = getNextWork(data, i);

      if (next.item1 == null) break;
      duration ??= Duration.zero;
      duration += next.item1 ?? Duration.zero;

      if (next.item2 == null) break;
      i = next.item2!;
    }

    return duration;
  }

  Duration? getBreakDuration(WorkSessionModel data) {
    Duration? duration;
    int i = 0;
    while (i < data.workSteps.length) {
      var next = getNextBreak(data, i);

      if (next.item1 == null) break;
      duration ??= Duration.zero;
      duration += next.item1 ?? Duration.zero;

      if (next.item2 == null) break;
      i = next.item2!;
    }

    return duration;
  }

  Tuple2<Duration?, int?> getNextWork(WorkSessionModel data, int index) {
    int? start = getNextStep(data, index, WorkSessionStep.START_WORK);
    if (start == null) {
      return const Tuple2(null, null);
    }

    int? end = getNextStep(data, start, WorkSessionStep.END_WORK);
    if (end == null) {
      return Tuple2(
          DateTime.now().difference(data.workSteps[start].dateTime), null);
    }

    var diff =
        data.workSteps[end].dateTime.difference(data.workSteps[start].dateTime);
    return Tuple2(diff, end);
  }

  Tuple2<Duration?, int?> getNextBreak(WorkSessionModel data, int index) {
    int? start = getNextStep(data, index, WorkSessionStep.START_BREAK);
    if (start == null) {
      return const Tuple2(null, null);
    }

    int? end = getNextStep(data, start, WorkSessionStep.END_BREAK);
    if (end == null) {
      return Tuple2(
          DateTime.now().difference(data.workSteps[start].dateTime), null);
    }

    var diff =
        data.workSteps[end].dateTime.difference(data.workSteps[start].dateTime);
    return Tuple2(diff, end);
  }

  int? getNextStep(WorkSessionModel data, int index, String type) {
    for (var i = index; i < data.workSteps.length; i++) {
      if (data.workSteps[i].type == type) {
        return i;
      }
    }
    return null;
  }
}
