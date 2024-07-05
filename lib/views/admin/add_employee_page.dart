import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_teamonapp/core/constants/app_colors.dart';
import 'package:flutter_teamonapp/core/constants/app_dimens.dart';
import 'package:flutter_teamonapp/models/add_user_model.dart';
import 'package:flutter_teamonapp/viewmodels/admin/users_viewmodel.dart';
import 'package:flutter_teamonapp/widgets/loading.dart';

class AddEmployeePage extends ConsumerStatefulWidget {
  const AddEmployeePage({super.key});

  @override
  ConsumerState<AddEmployeePage> createState() => _AddEmployeePageState();
}

class _AddEmployeePageState extends ConsumerState<AddEmployeePage> {
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final professionController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  String? roleController;

  @override
  Widget build(BuildContext context) {
    var users = ref.watch(usersProvider);
    if (users.isLoading) return const LoadingWidget();

    return SafeArea(
      child: Container(
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
                Text("New Employee",
                    style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: AppDimens.MAIN_SPACE),
                Text("Login Credintials",
                    style: Theme.of(context).textTheme.displaySmall),
                const SizedBox(height: AppDimens.MAIN_SPACE),
                Column(
                  children: [
                    TextFormField(
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      decoration: const InputDecoration(
                        hintText: 'Email',
                        fillColor: AppColors.WHITE,
                        filled: true,
                      ),
                      validator: (value) =>
                          (!EmailValidator.validate(value ?? ''))
                              ? 'Please enter a valid email'
                              : null,
                    ),
                    const SizedBox(height: AppDimens.MAIN_SPACE),
                    TextFormField(
                      controller: passwordController,
                      keyboardType: TextInputType.visiblePassword,
                      textInputAction: TextInputAction.done,
                      decoration: const InputDecoration(
                        hintText: 'Password',
                        fillColor: AppColors.WHITE,
                        filled: true,
                      ),
                      obscureText: true,
                      validator: (value) => value == null || value.isEmpty
                          ? 'Please enter a valid password'
                          : null,
                    ),
                  ],
                ),
                const SizedBox(height: AppDimens.MAIN_SPACE),
                Text("Role", style: Theme.of(context).textTheme.displaySmall),
                const SizedBox(height: AppDimens.MAIN_SPACE),
                Card(
                  color: AppColors.SECONDARY_LIGHT,
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
                Text("Personal Info",
                    style: Theme.of(context).textTheme.displaySmall),
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
                const SizedBox(height: AppDimens.MAIN_SPACE * 2),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                        style:
                            Theme.of(context).textButtonTheme.style?.copyWith(
                                  foregroundColor:
                                      const WidgetStatePropertyAll<Color>(
                                          AppColors.RED),
                                ),
                        onPressed: () => Navigator.pop(context),
                        child: const Text("Cancel")),
                    ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          final name = nameController.text.trim();
                          final profession = professionController.text.trim();
                          final email = emailController.text.trim();
                          final password = passwordController.text.trim();
                          final role = roleController ?? "employee";

                          var isAdded =
                              await ref.read(usersProvider.notifier).addUser(
                                    AddUserModel(
                                      fullName: name,
                                      email: email,
                                      password: password,
                                      role: role,
                                      profession: profession,
                                    ),
                                  );

                          try {
                            // ignore: use_build_context_synchronously
                            if (isAdded) Navigator.pop(context);
                          } catch (e) {}
                        }
                      },
                      child: const Text('Save'),
                    ),
                  ],
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
