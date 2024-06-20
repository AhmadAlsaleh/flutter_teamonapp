import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_teamonapp/core/constants/app_colors.dart';
import 'package:flutter_teamonapp/core/constants/app_dimens.dart';
import 'package:flutter_teamonapp/core/extensions/date_time_ext.dart';
import 'package:flutter_teamonapp/models/list_work_session.dart';
import 'package:flutter_teamonapp/viewmodels/admin/filter_work_sessions_viewmodel.dart';
import 'package:flutter_teamonapp/viewmodels/main_provider.dart';
import 'package:flutter_teamonapp/views/admin/work_chart.dart';
import 'package:flutter_teamonapp/views/admin/work_table.dart';
import 'package:flutter_teamonapp/widgets/loading.dart';
import 'package:flutter_teamonapp/widgets/message.dart';

class AdminDashboard extends ConsumerWidget {
  const AdminDashboard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var workSessions = ref.watch(adminWorkSessionProvider);
    var selectedDateRange = ref.watch(selectedMainDateRangeProvider);

    return Scaffold(
      backgroundColor: AppColors.WHITE,
      appBar: AppBar(
        title: const Text("Admin Dashboard", style: TextStyle(fontSize: 22)),
        actions: [
          IconButton(
            onPressed: () =>
                ref.read(adminWorkSessionProvider.notifier).fetchData(),
            icon: const Icon(CupertinoIcons.refresh),
          ),
        ],
      ),
      body: Container(
        padding: const EdgeInsets.all(AppDimens.MAIN_SPACE),
        child: Column(
          children: [
            Card(
              child: InkWell(
                onTap: () async {
                  var selectedRange = await showDateRangePicker(
                    context: context,
                    initialDateRange: selectedDateRange,
                    firstDate: DateTime(2000),
                    lastDate: DateTime.now(),
                  );

                  if (selectedRange != null) {
                    ref.read(selectedMainDateRangeProvider.notifier).state =
                        selectedRange;
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.all(AppDimens.MAIN_SPACE),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("From ${selectedDateRange.start.getDate()}",
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(color: AppColors.PRIMARY_DARK)),
                            Text("To ${selectedDateRange.end.getDate()}",
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(color: AppColors.SECONDARY)),
                          ],
                        ),
                      ),
                      const Icon(CupertinoIcons.forward)
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: AppDimens.MAIN_SPACE),
            Expanded(
              child: workSessions.when(
                  data: (data) => data.isEmpty
                      ? const MessageWidget(message: 'No Data!')
                      : SingleChildScrollView(
                          child: Column(
                            children: [
                              WorkChartWidget(
                                  listWorkSession:
                                      ListWorkSession(workSessions: data)),
                              const SizedBox(height: AppDimens.MAIN_SPACE),
                              WorkTable(
                                  listWorkSession:
                                      ListWorkSession(workSessions: data)),
                            ],
                          ),
                        ),
                  error: (e, s) => const MessageWidget(),
                  loading: () => const LoadingWidget()),
            ),
          ],
        ),
      ),
    );
  }
}
