import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_teamonapp/core/constants/app_colors.dart';
import 'package:flutter_teamonapp/viewmodels/auth_viewmodel.dart';
import 'package:flutter_teamonapp/widgets/confirmation_bottom_sheet.dart';

class LogoutWidget extends ConsumerWidget {
  const LogoutWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListTile(
      title: const Text("Logout"),
      textColor: AppColors.RED,
      onTap: () {
        showConfirmationBottomSheet(context, "Logout", "sure to logout?", () {
          ref.read(authViewModelProvider.notifier).logout();
        });
      },
    );
  }
}
