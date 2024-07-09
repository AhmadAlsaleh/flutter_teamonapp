import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_teamonapp/core/constants/app_colors.dart';
import 'package:flutter_teamonapp/core/constants/app_dimens.dart';
import 'package:flutter_teamonapp/core/extensions/double_ext.dart';
import 'package:flutter_teamonapp/models/user_model.dart';
import 'package:flutter_teamonapp/models/work_session_model.dart';
import 'package:flutter_teamonapp/utils/date_helper.dart';
import 'package:flutter_teamonapp/viewmodels/admin/filter_work_sessions_viewmodel.dart';
import 'package:flutter_teamonapp/viewmodels/work_session_viewmodel.dart';

class HomeSalaryDue extends ConsumerStatefulWidget {
  const HomeSalaryDue({super.key, required this.userModel});

  final UserModel userModel;

  @override
  ConsumerState<HomeSalaryDue> createState() => _HomeSalaryDueState();
}

class _HomeSalaryDueState extends ConsumerState<HomeSalaryDue> {
  Timer? salaryTimer;
  String salaryText = "";
  int monthWorkMinutes = 0;

  @override
  void dispose() {
    salaryTimer?.cancel();
    super.dispose();
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      List<WorkSessionModel> sessions = await ref
              .read(adminWorkSessionProvider.notifier)
              .getUserWorkSessions(widget.userModel.id,
                  DateHelper.getMonthDateRange(DateTime.now().month)) ??
          [];

      var minutes = sessions
          .map((s) => s.getWorkDuration()?.inMinutes ?? 0)
          .fold(0, (acc, durationInMinutes) => acc + durationInMinutes);

      setState(() => monthWorkMinutes = minutes);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var sessionsAsync = ref.watch(workSessionViewModelProvider);
    return sessionsAsync.when(
        data: (data) {
          var session = data.firstOrNull;

          salaryTimer?.cancel();
          salaryTimer = Timer.periodic(const Duration(seconds: 1), (Timer t) {
            Duration? workDuration = session?.getWorkDuration();
            int todayWorkMinutes = (workDuration ?? Duration.zero).inMinutes;

            double? salaryPerMinutes = widget.userModel.salaryPerMinute(
                DateTime.now().month, todayWorkMinutes + monthWorkMinutes);

            setState(() => salaryText = salaryPerMinutes.toEuro());
          });

          // if (session == null) return Container();

          return Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: AppDimens.MAIN_SPACE),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Salary due for this month",
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                Text(
                  salaryText,
                  style: Theme.of(context)
                      .textTheme
                      .displayMedium
                      ?.copyWith(color: AppColors.PRIMARY),
                ),
              ],
            ),
          );
        },
        error: (e, s) => Container(),
        loading: () => Container());
  }
}
