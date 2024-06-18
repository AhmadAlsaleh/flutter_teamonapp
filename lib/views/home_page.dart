import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_teamonapp/core/constants/app_dimens.dart';
import 'package:flutter_teamonapp/viewmodels/work_session_viewmodel.dart';
import 'package:flutter_teamonapp/widgets/home_date_picker.dart';
import 'package:flutter_teamonapp/widgets/home_summary.dart';
import 'package:flutter_teamonapp/widgets/loading.dart';
import 'package:flutter_teamonapp/widgets/message.dart';
import 'package:flutter_teamonapp/widgets/work_session.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var sessionsAsync = ref.watch(workSessionViewModelProvider);

    return Padding(
      padding: const EdgeInsets.all(AppDimens.MAIN_SPACE),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const HomeDatePicker(),
            const SizedBox(height: AppDimens.MAIN_SPACE),
            const HomeSummary(),
            const SizedBox(height: AppDimens.MAIN_SPACE),
            Expanded(
              child: sessionsAsync.when(
                data: (data) {
                  return data.isEmpty
                      ? const MessageWidget(message: "No Wrok Session!")
                      : ListView(
                          children: data
                              .map((session) =>
                                  WorkSession(workSessionModel: session))
                              .toList(),
                        );
                },
                error: (e, s) => const MessageWidget(),
                loading: () => const LoadingWidget(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
