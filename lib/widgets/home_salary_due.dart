import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_teamonapp/core/constants/app_colors.dart';
import 'package:flutter_teamonapp/core/constants/app_dimens.dart';
import 'package:flutter_teamonapp/core/extensions/double_ext.dart';
import 'package:flutter_teamonapp/models/user_model.dart';
import 'package:flutter_teamonapp/utils/date_helper.dart';
import 'package:flutter_teamonapp/viewmodels/admin/filter_work_sessions_viewmodel.dart';
import 'package:flutter_teamonapp/viewmodels/user_viewmodel.dart';
import 'package:flutter_teamonapp/viewmodels/work_session_viewmodel.dart';

class HomeSalaryDue extends ConsumerStatefulWidget {
  const HomeSalaryDue({super.key});

  @override
  ConsumerState<HomeSalaryDue> createState() => _HomeSalaryDueState();
}

class _HomeSalaryDueState extends ConsumerState<HomeSalaryDue> {
  Timer? salaryTimer;
  String salaryText = "";

  @override
  void dispose() {
    salaryTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    UserModel? userModel = ref.watch(userViewModelProvider).value;
    var monthSessions = ref
        .read(adminWorkSessionProvider.notifier)
        .getUserWorkSessions(
            userModel!.id, DateHelper.getMonthDateRange(DateTime.now().month));

    var sessionsAsync = ref.watch(workSessionViewModelProvider);
    return sessionsAsync.when(
        data: (data) {
          var session = data.firstOrNull;
          if (session == null) return Container();

          salaryTimer?.cancel();
          salaryTimer = Timer.periodic(const Duration(seconds: 1), (Timer t) {
            Duration? workDuration = session.getWorkDuration();

            int minutes = (workDuration ?? Duration.zero).inMinutes;
            double? salaryPerMinutes =
                userModel?.salaryPerMinute(DateTime.now().month, minutes);

            setState(() {
              salaryText =
                  salaryPerMinutes == null ? "--" : salaryPerMinutes.toEuro();
            });
          });

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
