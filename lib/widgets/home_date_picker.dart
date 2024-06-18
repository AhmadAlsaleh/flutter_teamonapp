import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_teamonapp/core/extensions/date_time_ext.dart';
import 'package:flutter_teamonapp/viewmodels/main_provider.dart';

class HomeDatePicker extends ConsumerWidget {
  const HomeDatePicker({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedDate = ref.watch(selectedMainDateProvider);

    return InkWell(
      onTap: () async {
        var pickedDate = await showDatePicker(
          context: context,
          initialDate: selectedDate,
          firstDate: DateTime(2000),
          lastDate: DateTime.now(),
        );

        if (pickedDate != null) {
          ref.read(selectedMainDateProvider.notifier).state = pickedDate;
        }
      },
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(selectedDate.getDate(),
                    style: Theme.of(context).textTheme.titleLarge),
                Text(selectedDate.getDay(),
                    style: Theme.of(context).textTheme.displayLarge),
              ],
            ),
          ),
          const Icon(CupertinoIcons.forward)
        ],
      ),
    );
  }
}
