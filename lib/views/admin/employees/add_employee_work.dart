import 'package:currency_textfield/currency_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_teamonapp/core/constants/app_colors.dart';
import 'package:flutter_teamonapp/core/constants/app_dimens.dart';
import 'package:flutter_teamonapp/core/extensions/date_time_ext.dart';
import 'package:flutter_teamonapp/models/add_user_model.dart';
import 'package:flutter_teamonapp/viewmodels/admin/add_employee_viewmodel.dart';

class AddEmployeeWork extends ConsumerStatefulWidget {
  const AddEmployeeWork({super.key});

  @override
  ConsumerState<AddEmployeeWork> createState() => _AddEmployeeWorkState();
}

class _AddEmployeeWorkState extends ConsumerState<AddEmployeeWork> {
  late final CurrencyTextFieldController salaryController;
  late final TextEditingController workHoursController;
  late final TextEditingController breakHoursController;
  List<String> selectedWorkDays = [];

  @override
  void initState() {
    super.initState();

    final userData = ref.read(addEmployeeProvider);
    workHoursController =
        TextEditingController(text: (userData?.workHours ?? 0.0).toString());
    breakHoursController =
        TextEditingController(text: (userData?.breakHours ?? 0.0).toString());

    salaryController = CurrencyTextFieldController(
      initDoubleValue: userData?.salary ?? 0.0,
      currencyOnLeft: true,
      currencySymbol: "€",
      thousandSymbol: ",",
      decimalSymbol: ".",
    );

    selectedWorkDays = (userData?.workdays ?? '').split(",");
  }

  void saveData() {
    final userData = ref.read(addEmployeeProvider) ?? AddUserModel();
    final salary = salaryController.doubleTextWithoutCurrencySymbol.trim();
    final workHours = workHoursController.text.trim();
    final breakHours = breakHoursController.text.trim();

    ref.read(addEmployeeProvider.notifier).state = userData.copyWith(
      salary: double.parse(salary.isEmpty ? "0.0" : salary),
      workHours: double.tryParse(workHours.isEmpty ? "0.0" : workHours),
      breakHours: double.tryParse(breakHours.isEmpty ? "0.0" : breakHours),
      workdays: selectedWorkDays.join(","),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppDimens.MAIN_SPACE),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Work Information",
            style: Theme.of(context)
                .textTheme
                .titleMedium
                ?.copyWith(color: AppColors.PRIMARY),
          ),
          const SizedBox(height: AppDimens.MAIN_SPACE * 2),
          TextFormField(
            controller: salaryController,
            keyboardType: TextInputType.number,
            textInputAction: TextInputAction.next,
            decoration: const InputDecoration(
              labelText: 'Salary',
              fillColor: AppColors.WHITE,
              filled: true,
            ),
            onChanged: (value) => saveData(),
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: (value) => value == null || value.isEmpty
                ? 'Please enter a valid salary'
                : null,
          ),
          const SizedBox(height: AppDimens.MAIN_SPACE * 2),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: workHoursController,
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(
                    labelText: 'Daily Work Hours',
                    fillColor: AppColors.WHITE,
                    filled: true,
                  ),
                  onChanged: (value) => saveData(),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) => value == null || value.isEmpty
                      ? 'Please enter a valid number'
                      : null,
                ),
              ),
              const SizedBox(width: AppDimens.MAIN_SPACE),
              Expanded(
                child: TextFormField(
                  controller: breakHoursController,
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.done,
                  decoration: const InputDecoration(
                    labelText: 'Daily Break Hours',
                    fillColor: AppColors.WHITE,
                    filled: true,
                  ),
                  onChanged: (value) => saveData(),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) => value == null || value.isEmpty
                      ? 'Please enter a valid number'
                      : null,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppDimens.MAIN_SPACE * 2),
          Text(
            "Working Days",
            style: Theme.of(context)
                .textTheme
                .titleMedium
                ?.copyWith(color: AppColors.PRIMARY),
          ),
          Column(
            children: ListTile.divideTiles(
              context: context,
              tiles: weekDays.map(
                (day) => CheckboxListTile(
                    title: Text(day,
                        style: Theme.of(context).textTheme.bodyMedium),
                    value: selectedWorkDays.contains(day),
                    onChanged: (value) {
                      if (selectedWorkDays.contains(day)) {
                        setState(() =>
                            selectedWorkDays = selectedWorkDays..remove(day));
                      } else {
                        setState(() =>
                            selectedWorkDays = selectedWorkDays..add(day));
                      }
                      saveData();
                    }),
              ),
            ).toList(),
          ),
        ],
      ),
    );
  }
}
