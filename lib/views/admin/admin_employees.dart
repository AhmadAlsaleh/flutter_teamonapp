import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_teamonapp/core/constants/app_colors.dart';
import 'package:flutter_teamonapp/core/constants/app_dimens.dart';

class AdminEmployees extends ConsumerWidget {
  const AdminEmployees({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppColors.WHITE,
      body: Container(
        padding: EdgeInsets.all(AppDimens.MAIN_SPACE),
        child: Column(
          children: [],
        ),
      ),
    );
  }
}
