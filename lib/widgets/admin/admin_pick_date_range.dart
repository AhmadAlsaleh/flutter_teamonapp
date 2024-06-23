import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_teamonapp/core/constants/app_colors.dart';
import 'package:flutter_teamonapp/core/constants/app_dimens.dart';
import 'package:flutter_teamonapp/core/extensions/date_time_ext.dart';
import 'package:flutter_teamonapp/viewmodels/main_provider.dart';

class AdminPickDateRange extends ConsumerWidget {
  const AdminPickDateRange({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var selectedDateRange = ref.watch(selectedMainDateRangeProvider);

    return InkWell(
      onTap: () async {
        var selectedRange = await showDateRangePicker(
          context: context,
          initialDateRange: selectedDateRange,
          firstDate: DateTime(2020),
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
    );
  }
}
