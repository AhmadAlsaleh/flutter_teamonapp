import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_teamonapp/core/constants/app_colors.dart';
import 'package:flutter_teamonapp/core/constants/app_dimens.dart';
import 'package:flutter_teamonapp/models/add_user_model.dart';
import 'package:flutter_teamonapp/viewmodels/admin/add_employee_viewmodel.dart';

class AddEmployeePersonal extends ConsumerStatefulWidget {
  const AddEmployeePersonal({super.key});

  @override
  ConsumerState<AddEmployeePersonal> createState() => _AddEmployeePageState();
}

class _AddEmployeePageState extends ConsumerState<AddEmployeePersonal> {
  late final TextEditingController nameController;
  late final TextEditingController professionController;

  @override
  void initState() {
    super.initState();

    final userData = ref.read(addEmployeeProvider);
    nameController = TextEditingController(text: userData?.fullName);
    professionController = TextEditingController(text: userData?.profession);
  }

  void saveData() {
    final userData = ref.read(addEmployeeProvider) ?? AddUserModel();
    final name = nameController.text.trim();
    final profession = professionController.text.trim();

    ref.read(addEmployeeProvider.notifier).state = userData.copyWith(
      fullName: name,
      profession: profession,
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
            "Personal Info",
            style: Theme.of(context)
                .textTheme
                .titleMedium
                ?.copyWith(color: AppColors.PRIMARY),
          ),
          const SizedBox(height: AppDimens.MAIN_SPACE * 2),
          TextFormField(
            controller: nameController,
            keyboardType: TextInputType.name,
            textInputAction: TextInputAction.next,
            decoration: const InputDecoration(
              labelText: 'Full Name',
              fillColor: AppColors.WHITE,
              filled: true,
            ),
            onChanged: (value) => saveData(),
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: (value) => value == null || value.isEmpty
                ? 'Please enter a valid name'
                : null,
          ),
          const SizedBox(height: AppDimens.MAIN_SPACE * 2),
          TextFormField(
            controller: professionController,
            textInputAction: TextInputAction.done,
            decoration: const InputDecoration(
              labelText: 'Profession',
              fillColor: AppColors.WHITE,
              filled: true,
            ),
            onChanged: (value) => saveData(),
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: (value) => value == null || value.isEmpty
                ? 'Please enter a valid profession'
                : null,
          ),
        ],
      ),
    );
  }
}
