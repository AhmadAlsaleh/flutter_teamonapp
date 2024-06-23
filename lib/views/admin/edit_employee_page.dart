import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_teamonapp/core/constants/app_colors.dart';
import 'package:flutter_teamonapp/core/constants/app_dimens.dart';
import 'package:flutter_teamonapp/models/user_model.dart';
import 'package:flutter_teamonapp/viewmodels/admin/users_viewmodel.dart';
import 'package:flutter_teamonapp/widgets/loading.dart';

class EditEmployeePage extends ConsumerStatefulWidget {
  const EditEmployeePage({super.key, required this.userModel});

  final UserModel userModel;

  @override
  ConsumerState<EditEmployeePage> createState() => _EditEmployeePageState();
}

class _EditEmployeePageState extends ConsumerState<EditEmployeePage> {
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final professionController = TextEditingController();
  bool isActive = true;
  String? roleController = "employee";

  @override
  void initState() {
    nameController.text = widget.userModel.fullName;
    professionController.text = widget.userModel.profession;
    roleController = widget.userModel.role;
    isActive = widget.userModel.isActive;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var users = ref.watch(usersProvider);
    if (users.isLoading) return const LoadingWidget();

    return SafeArea(
      child: Container(
        height: MediaQuery.of(context).size.height * 0.85,
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppDimens.MAIN_SPACE),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: AppDimens.MAIN_SPACE),
                Text("Edit Employee",
                    style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: AppDimens.MAIN_SPACE * 2),
                Text(
                  "Personal Info",
                  style: Theme.of(context).textTheme.displaySmall,
                ),
                const SizedBox(height: AppDimens.MAIN_SPACE),
                Column(
                  children: [
                    TextFormField(
                      controller: nameController,
                      keyboardType: TextInputType.name,
                      textInputAction: TextInputAction.next,
                      decoration: const InputDecoration(
                        hintText: 'Full Name',
                        fillColor: AppColors.WHITE,
                        filled: true,
                      ),
                      validator: (value) => value == null || value.isEmpty
                          ? 'Please enter a valid name'
                          : null,
                    ),
                    const SizedBox(height: AppDimens.MAIN_SPACE),
                    TextFormField(
                      controller: professionController,
                      textInputAction: TextInputAction.next,
                      decoration: const InputDecoration(
                        hintText: 'Profession',
                        fillColor: AppColors.WHITE,
                        filled: true,
                      ),
                      validator: (value) => value == null || value.isEmpty
                          ? 'Please enter a valid profession'
                          : null,
                    ),
                  ],
                ),
                const SizedBox(height: AppDimens.MAIN_SPACE),
                Text(
                  "Role",
                  style: Theme.of(context).textTheme.displaySmall,
                ),
                Card(
                  child: Column(
                    children: [
                      RadioListTile(
                        title: const Text("Admin"),
                        value: "admin",
                        groupValue: roleController,
                        onChanged: (value) =>
                            setState(() => roleController = value),
                      ),
                      RadioListTile(
                        title: const Text("Employee"),
                        value: "employee",
                        groupValue: roleController,
                        onChanged: (value) =>
                            setState(() => roleController = value),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppDimens.MAIN_SPACE),
                CheckboxListTile(
                    value: isActive,
                    title: const Text("Active"),
                    onChanged: (value) =>
                        setState(() => isActive = value ?? false)),
                const SizedBox(height: AppDimens.MAIN_SPACE * 2),
                ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      final name = nameController.text.trim();
                      final profession = professionController.text.trim();
                      final role = roleController ?? "employee";

                      var updated =
                          await ref.read(usersProvider.notifier).updateUser(
                                widget.userModel.copyWith(
                                  fullName: name,
                                  profession: profession,
                                  role: role,
                                  isActive: isActive,
                                ),
                              );

                      try {
                        if (updated) Navigator.pop(context);
                      } catch (e) {}
                    }
                  },
                  child: const Text('Save'),
                ),
                const SizedBox(height: AppDimens.MAIN_SPACE),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
