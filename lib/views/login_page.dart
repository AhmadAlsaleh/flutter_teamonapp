import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_teamonapp/core/constants/app_colors.dart';
import 'package:flutter_teamonapp/core/constants/app_dimens.dart';
import 'package:flutter_teamonapp/viewmodels/auth_viewmodel.dart';

class LoginPage extends ConsumerWidget {
  LoginPage({super.key});

  final _formKey = GlobalKey<FormState>();
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppColors.WHITE,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppDimens.MAIN_SPACE),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: MediaQuery.of(context).size.height,
          ),
          child: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  children: [
                    const SizedBox(height: AppDimens.MAIN_SPACE * 2),
                    Text("Hi There!",
                        style: Theme.of(context).textTheme.titleLarge),
                    const SizedBox(height: AppDimens.MAIN_SPACE),
                    Text("Team\nON".toUpperCase(),
                        style: Theme.of(context).textTheme.displayLarge),
                  ],
                ),
                const SizedBox(height: AppDimens.MAIN_SPACE),
                Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextFormField(
                        controller: usernameController,
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                        decoration: const InputDecoration(hintText: 'Username'),
                        validator: (value) => value == null || value.isEmpty
                            ? 'Please enter a valid username'
                            : null,
                      ),
                      const SizedBox(height: AppDimens.MAIN_SPACE),
                      TextFormField(
                        controller: passwordController,
                        decoration: const InputDecoration(hintText: 'Password'),
                        obscureText: true,
                        validator: (value) => value == null || value.isEmpty
                            ? 'Please enter a valid password'
                            : null,
                      ),
                      const SizedBox(height: AppDimens.MAIN_SPACE),
                      TextButton(
                        onPressed: () => showForgetPasswordBottomSheet(context),
                        child: const Text('Forgot Password?'),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppDimens.MAIN_SPACE),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          final username = usernameController.text.trim();
                          final password = passwordController.text.trim();

                          ref.read(authViewModelProvider.notifier).login(
                                username,
                                password,
                              );
                        }
                      },
                      icon: const Icon(Icons.arrow_forward),
                      label: const Text('Login'),
                    ),
                    const SizedBox(height: AppDimens.MAIN_SPACE),
                    Text("by logging in you agree to the terms and conditions",
                        style: Theme.of(context).textTheme.bodySmall),
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

  void showForgetPasswordBottomSheet(BuildContext context) {
    /**
     * todo
     * implementation forget and reset password
     * create bottom sheet
     */
  }
}
