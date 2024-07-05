import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_teamonapp/core/constants/app_colors.dart';
import 'package:flutter_teamonapp/core/constants/app_dimens.dart';
import 'package:flutter_teamonapp/models/change_password_model.dart';
import 'package:flutter_teamonapp/models/user_model.dart';
import 'package:flutter_teamonapp/viewmodels/auth_viewmodel.dart';
import 'package:flutter_teamonapp/viewmodels/user_viewmodel.dart';

class ChangePassword extends ConsumerStatefulWidget {
  const ChangePassword({super.key, required this.userModel});

  final UserModel userModel;

  @override
  ConsumerState<ChangePassword> createState() => _EditInformationState();
}

class _EditInformationState extends ConsumerState<ChangePassword> {
  final _formKey = GlobalKey<FormState>();
  String? message;

  final emailController = TextEditingController();
  final currentPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();

  @override
  void initState() {
    emailController.text = widget.userModel.email;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
                Text("Change Password",
                    style: Theme.of(context).textTheme.titleLarge),
                Text(widget.userModel.email,
                    style: Theme.of(context).textTheme.bodyLarge),
                const SizedBox(height: AppDimens.MAIN_SPACE * 2),
                Column(
                  children: [
                    TextFormField(
                      controller: currentPasswordController,
                      keyboardType: TextInputType.visiblePassword,
                      textInputAction: TextInputAction.next,
                      decoration: const InputDecoration(
                        hintText: 'Current Password',
                        fillColor: AppColors.WHITE,
                        filled: true,
                      ),
                      validator: (value) => value == null || value.isEmpty
                          ? 'Please enter current password'
                          : null,
                    ),
                    const SizedBox(height: AppDimens.MAIN_SPACE),
                    TextFormField(
                      controller: newPasswordController,
                      keyboardType: TextInputType.visiblePassword,
                      textInputAction: TextInputAction.next,
                      decoration: const InputDecoration(
                        hintText: 'New Password',
                        fillColor: AppColors.WHITE,
                        filled: true,
                      ),
                      validator: (value) => value == null || value.isEmpty
                          ? 'Please enter a valid password'
                          : null,
                    ),
                  ],
                ),
                const SizedBox(height: AppDimens.MAIN_SPACE * 2),
                if (message != null)
                  Text(message ?? "",
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.copyWith(color: AppColors.RED)),
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
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text("Cancel")),
                    ElevatedButton(
                      onPressed: () => _saveInformation(context),
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

  Future<void> _saveInformation(BuildContext context) async {
    setState(() => message = null);
    if (_formKey.currentState!.validate()) {
      final email = emailController.text.trim();
      final currentPassword = currentPasswordController.text.trim();
      final newPassword = newPasswordController.text.trim();

      var updated =
          await ref.read(authViewModelProvider.notifier).changePassword(
                ChangePasswordModel(
                    email: email,
                    currentPassword: currentPassword,
                    newPassword: newPassword),
              );

      try {
        if (updated) {
          // ignore: unused_result
          ref.refresh(userViewModelProvider);
          // ignore: use_build_context_synchronously
          Navigator.of(context).pop();
        } else {
          setState(() {
            message = "invalid password";
          });
        }
      } catch (e) {}
    }
  }
}
