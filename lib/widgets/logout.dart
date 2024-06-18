import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_teamonapp/core/constants/app_colors.dart';
import 'package:flutter_teamonapp/viewmodels/auth_viewmodel.dart';

class LogoutWidget extends ConsumerWidget {
  const LogoutWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListTile(
      title: const Text("Logout"),
      textColor: AppColors.RED,
      onTap: () async {
        ref.read(authViewModelProvider.notifier).logout();
      },
    );
  }
}
