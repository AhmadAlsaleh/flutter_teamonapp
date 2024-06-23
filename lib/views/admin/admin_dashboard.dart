import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_teamonapp/core/constants/app_colors.dart';
import 'package:flutter_teamonapp/core/constants/app_dimens.dart';
import 'package:flutter_teamonapp/models/list_work_session.dart';
import 'package:flutter_teamonapp/viewmodels/admin/filter_work_sessions_viewmodel.dart';
import 'package:flutter_teamonapp/views/admin/work_chart.dart';
import 'package:flutter_teamonapp/views/admin/work_table.dart';
import 'package:flutter_teamonapp/widgets/admin/admin_pick_date_range.dart';
import 'package:flutter_teamonapp/widgets/message.dart';
import 'package:flutter_teamonapp/widgets/my_refresh_indicator.dart';

class AdminDashboard extends ConsumerWidget {
  const AdminDashboard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var workSessions = ref.watch(adminWorkSessionProvider);
    var data = workSessions.valueOrNull ?? [];
    var isError = workSessions.hasError;
    var isData = workSessions.hasValue;

    return Scaffold(
      backgroundColor: AppColors.WHITE,
      appBar: AppBar(
        title: const Text("Admin Dashboard", style: TextStyle(fontSize: 22)),
      ),
      body: Column(
        children: [
          const AdminPickDateRange(),
          const SizedBox(height: AppDimens.MAIN_SPACE),
          if (isError) const Expanded(child: MessageWidget()),
          Expanded(
            child: MyRefreshIndicator(
              action: () =>
                  ref.read(adminWorkSessionProvider.notifier).fetchData(),
              child: ListView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  children: [
                    if (isData && data.isEmpty)
                      MessageWidget(
                        message: "No Data!",
                        height: AppDimens.screenHeight(context) - 200,
                      ),
                    if (isData && data.isNotEmpty)
                      WorkChartWidget(
                          listWorkSession: ListWorkSession(workSessions: data)),
                    const SizedBox(height: AppDimens.MAIN_SPACE),
                    if (isData && data.isNotEmpty)
                      WorkTable(
                          listWorkSession: ListWorkSession(workSessions: data)),
                  ]),
            ),
          ),
        ],
      ),
    );
  }
}
