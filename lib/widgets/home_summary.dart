import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_teamonapp/core/constants/app_colors.dart';
import 'package:flutter_teamonapp/core/constants/app_dimens.dart';
import 'package:flutter_teamonapp/viewmodels/work_session_viewmodel.dart';
import 'package:flutter_teamonapp/widgets/loading.dart';
import 'package:flutter_teamonapp/widgets/message.dart';

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
            Duration? workDuration = session.getWorkDuration();
            Duration? breakDuration = session.getBreakDuration();

            setState(() {
              workText = workDuration == null
                  ? "--"
                  : workDuration.toString().split(".")[0];

              breakText = breakDuration == null
                  ? '--'
                  : breakDuration.toString().split(".")[0];
            });
          });

          return Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: AppDimens.MAIN_SPACE),
            child: Row(
              children: [
                Expanded(
                  child: Card(
                    child: ListTile(
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
                const SizedBox(width: AppDimens.MAIN_SPACE / 2),
                Expanded(
                  child: Card(
                    color: AppColors.SECONDARY_LIGHT,
                    child: ListTile(
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
            ),
          );
        },
        error: (e, s) => const MessageWidget(),
        loading: () => const LoadingWidget());
  }
}
