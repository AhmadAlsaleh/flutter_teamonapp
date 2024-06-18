import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_teamonapp/core/constants/app_colors.dart';
import 'package:flutter_teamonapp/core/constants/app_dimens.dart';
import 'package:flutter_teamonapp/models/work_session_model.dart';
import 'package:flutter_teamonapp/viewmodels/work_session_viewmodel.dart';
import 'package:flutter_teamonapp/widgets/loading.dart';
import 'package:flutter_teamonapp/widgets/message.dart';

class HomeSummary extends ConsumerWidget {
  const HomeSummary({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var sessionsAsync = ref.watch(workSessionViewModelProvider);

    return sessionsAsync.when(
        data: (data) {
          var session = data.firstOrNull;
          if (session == null) return Container();

          Duration workDuration = getWorkDuration(session);
          Duration breakDuration = getBreakDuration(session);

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
                      workDuration.toString().split(".")[0],
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
                      breakDuration.toString().split(".")[0],
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

  Duration getWorkDuration(WorkSessionModel data) {
    int iStart = data.workSteps.indexWhere((step) => step.type == "start_work");
    DateTime start =
        (iStart < 0) ? DateTime.now() : data.workSteps[iStart].dateTime;

    int i = data.workSteps.indexWhere((step) => step.type == "end_work");
    DateTime end = (i < 0) ? DateTime.now() : data.workSteps[i].dateTime;

    return end.difference(start) - getBreakDuration(data);
  }

  Duration getBreakDuration(WorkSessionModel data) {
    int iStart =
        data.workSteps.indexWhere((step) => step.type == "start_break");
    DateTime start =
        (iStart < 0) ? DateTime.now() : data.workSteps[iStart].dateTime;

    int i = data.workSteps.indexWhere((step) => step.type == "end_break");
    DateTime end = (i < 0) ? DateTime.now() : data.workSteps[i].dateTime;

    return end.difference(start);
  }
}
