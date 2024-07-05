import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_teamonapp/core/constants/app_colors.dart';
import 'package:flutter_teamonapp/core/constants/app_dimens.dart';
import 'package:flutter_teamonapp/models/add_user_model.dart';
import 'package:flutter_teamonapp/viewmodels/admin/add_employee_viewmodel.dart';

class AddEmployeeAccount extends ConsumerStatefulWidget {
  const AddEmployeeAccount({super.key});

  @override
  ConsumerState<AddEmployeeAccount> createState() => _AddEmployeeAccountState();
}

class _AddEmployeeAccountState extends ConsumerState<AddEmployeeAccount> {
  late final TextEditingController emailController;
  late final TextEditingController passwordController;
  String? role = 'employee';

  @override
  void initState() {
    super.initState();

    final userData = ref.read(addEmployeeProvider);
    emailController = TextEditingController(text: userData?.email);
    passwordController = TextEditingController(text: userData?.password);
    role = userData?.role ?? 'employee';
  }

  void saveData() {
    final userData = ref.read(addEmployeeProvider) ?? AddUserModel();
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    ref.read(addEmployeeProvider.notifier).state = userData.copyWith(
      email: email,
      password: password,
      role: role,
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
            "Login Credintials",
            style: Theme.of(context)
                .textTheme
                .titleMedium
                ?.copyWith(color: AppColors.PRIMARY),
          ),
          const SizedBox(height: AppDimens.MAIN_SPACE * 2),
          TextFormField(
            controller: emailController,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            decoration: const InputDecoration(
              labelText: 'Email',
              fillColor: AppColors.WHITE,
              filled: true,
            ),
            onChanged: (value) => saveData(),
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: (value) => (!EmailValidator.validate(value ?? ''))
                ? 'Please enter a valid email'
                : null,
          ),
          const SizedBox(height: AppDimens.MAIN_SPACE * 2),
          TextFormField(
            controller: passwordController,
            keyboardType: TextInputType.visiblePassword,
            textInputAction: TextInputAction.done,
            decoration: const InputDecoration(
              labelText: 'Password',
              fillColor: AppColors.WHITE,
              filled: true,
            ),
            obscureText: true,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            onChanged: (value) => saveData(),
            validator: (value) => value == null || value.isEmpty
                ? 'Please enter a valid password'
                : null,
          ),
          const SizedBox(height: AppDimens.MAIN_SPACE * 2),
          RadioListTile(
            title: Text("Admin", style: Theme.of(context).textTheme.bodyMedium),
            value: "admin",
            groupValue: role,
            onChanged: (value) {
              setState(() => role = value);
              saveData();
            },
          ),
          RadioListTile(
            title:
                Text("Employee", style: Theme.of(context).textTheme.bodyMedium),
            value: "employee",
            groupValue: role,
            onChanged: (value) {
              setState(() => role = value);
              saveData();
            },
          ),
        ],
      ),
    );
  }
}
