import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_teamonapp/core/constants/app_colors.dart';
import 'package:flutter_teamonapp/core/constants/app_dimens.dart';
import 'package:flutter_teamonapp/viewmodels/admin/add_employee_viewmodel.dart';
import 'package:intl/intl.dart';

class AddEmployeeSummary extends ConsumerWidget {
  const AddEmployeeSummary({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var userData = ref.watch(addEmployeeProvider);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppDimens.MAIN_SPACE),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Summary",
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(color: AppColors.PRIMARY),
              ),
              const SizedBox(height: AppDimens.MAIN_SPACE),
              Text("Email", style: Theme.of(context).textTheme.bodySmall),
              Text("${userData?.email}",
                  style: Theme.of(context).textTheme.bodyLarge),
              const SizedBox(height: AppDimens.MAIN_SPACE),
              Text("Password", style: Theme.of(context).textTheme.bodySmall),
              Text("${userData?.password}",
                  style: Theme.of(context).textTheme.bodyLarge),
              const SizedBox(height: AppDimens.MAIN_SPACE),
              Text("Role", style: Theme.of(context).textTheme.bodySmall),
              Text("${userData?.role}",
                  style: Theme.of(context).textTheme.bodyLarge),
              const SizedBox(height: AppDimens.MAIN_SPACE),
              const Divider(),
              const SizedBox(height: AppDimens.MAIN_SPACE),
              Text("Full Name", style: Theme.of(context).textTheme.bodySmall),
              Text("${userData?.fullName}",
                  style: Theme.of(context).textTheme.bodyLarge),
              const SizedBox(height: AppDimens.MAIN_SPACE),
              Text("Profession", style: Theme.of(context).textTheme.bodySmall),
              Text("${userData?.profession}",
                  style: Theme.of(context).textTheme.bodyLarge),
              const SizedBox(height: AppDimens.MAIN_SPACE),
              const Divider(),
              const SizedBox(height: AppDimens.MAIN_SPACE),
              Text("Salary", style: Theme.of(context).textTheme.bodySmall),
              Text(
                  NumberFormat.simpleCurrency(name: "€")
                      .format(userData?.salary),
                  style: Theme.of(context).textTheme.bodyLarge),
              const SizedBox(height: AppDimens.MAIN_SPACE),
              Text("Daily Work Hours",
                  style: Theme.of(context).textTheme.bodySmall),
              Text("${userData?.workHours}",
                  style: Theme.of(context).textTheme.bodyLarge),
              const SizedBox(height: AppDimens.MAIN_SPACE),
              Text("Daily Break Hours",
                  style: Theme.of(context).textTheme.bodySmall),
              Text("${userData?.breakHours}",
                  style: Theme.of(context).textTheme.bodyLarge),
              const SizedBox(height: AppDimens.MAIN_SPACE),
              const Divider(),
              const SizedBox(height: AppDimens.MAIN_SPACE),
              Text("Work Days", style: Theme.of(context).textTheme.bodySmall),
              Text((userData?.workdays ?? '').split(',').join(", "),
                  style: Theme.of(context).textTheme.bodyLarge),
            ],
          ),
        ],
      ),
    );
  }
}
