import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_teamonapp/core/constants/app_colors.dart';
import 'package:flutter_teamonapp/core/constants/app_dimens.dart';
import 'package:flutter_teamonapp/core/extensions/date_time_ext.dart';
import 'package:flutter_teamonapp/models/work_step_model.dart';
import 'package:flutter_teamonapp/viewmodels/main_provider.dart';
import 'package:flutter_teamonapp/viewmodels/work_session_viewmodel.dart';
import 'package:flutter_teamonapp/widgets/work_session_step.dart';

class HomeButtons extends ConsumerWidget {
  const HomeButtons({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedDate = ref.watch(selectedMainDateProvider);
    final sessionsAsync = ref.watch(workSessionViewModelProvider);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppDimens.MAIN_SPACE),
      child: sessionsAsync.when(
        data: (data) {
          var session = data.firstOrNull;

          int workStarts = session?.workSteps
                  .where((step) => step.type == "start_work")
                  .length ??
              0;
          int workEnds = session?.workSteps
                  .where((step) => step.type == "end_work")
                  .length ??
              0;
          int breakStarts = session?.workSteps
                  .where((step) => step.type == "start_break")
                  .length ??
              0;
          int breakEnds = session?.workSteps
                  .where((step) => step.type == "end_break")
                  .length ??
              0;

          var rowChildren = [
            if (workStarts == workEnds &&
                selectedDate.getDate() == DateTime.now().getDate())
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    if (session == null) {
                      ref
                          .read(workSessionViewModelProvider.notifier)
                          .startSession();
                    } else {
                      ref.read(workSessionViewModelProvider.notifier).addStep(
                            WorkStepModel(
                              id: 0,
                              workSessionId: session.id,
                              dateTime: DateTime.now(),
                              type: WorkSessionStep.START_WORK,
                            ),
                          );
                    }
                  },
                  child: const Text("Start Work"),
                ),
              ),
            if ((workStarts > workEnds) && (breakStarts == breakEnds))
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    ref.read(workSessionViewModelProvider.notifier).addStep(
                          WorkStepModel(
                            id: 0,
                            workSessionId: session!.id,
                            dateTime: DateTime.now(),
                            type: WorkSessionStep.END_WORK,
                          ),
                        );
                  },
                  child: const Text("End Work"),
                ),
              ),
            if ((workStarts > workEnds) && (breakStarts == breakEnds))
              Expanded(
                child: ElevatedButton(
                  style: Theme.of(context).elevatedButtonTheme.style?.copyWith(
                        backgroundColor:
                            const WidgetStatePropertyAll(AppColors.SECONDARY),
                      ),
                  onPressed: () {
                    ref.read(workSessionViewModelProvider.notifier).addStep(
                          WorkStepModel(
                            id: 0,
                            workSessionId: session!.id,
                            dateTime: DateTime.now(),
                            type: WorkSessionStep.START_BREAK,
                          ),
                        );
                  },
                  child: const Text("Start Break"),
                ),
              ),
            if ((workStarts > workEnds) && (breakStarts > breakEnds))
              Expanded(
                child: ElevatedButton(
                  style: Theme.of(context).elevatedButtonTheme.style?.copyWith(
                      backgroundColor:
                          const WidgetStatePropertyAll(AppColors.SECONDARY)),
                  onPressed: () {
                    ref.read(workSessionViewModelProvider.notifier).addStep(
                          WorkStepModel(
                            id: 0,
                            workSessionId: session!.id,
                            dateTime: DateTime.now(),
                            type: WorkSessionStep.END_BREAK,
                          ),
                        );
                  },
                  child: const Text("End Break"),
                ),
              ),
          ];

          List<Widget> children = [];
          for (var i = 0; i < rowChildren.length; i++) {
            children.add(rowChildren[i]);
            if (i < rowChildren.length - 1) {
              children.add(const SizedBox(width: AppDimens.MAIN_SPACE / 2));
            }
          }

          return Row(children: children);
        },
        error: (e, s) => Container(),
        loading: () => Container(),
      ),
    );
  }
}
