import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_teamonapp/core/constants/app_colors.dart';
import 'package:flutter_teamonapp/core/constants/app_dimens.dart';
import 'package:flutter_teamonapp/models/user_model.dart';
import 'package:flutter_teamonapp/viewmodels/admin/users_viewmodel.dart';
import 'package:flutter_teamonapp/viewmodels/auth_viewmodel.dart';
import 'package:flutter_teamonapp/views/admin/employees/edit_employee.dart';
import 'package:flutter_teamonapp/widgets/confirmation_bottom_sheet.dart';

class UserWidget extends ConsumerWidget {
  const UserWidget({super.key, required this.userModel});

  final UserModel userModel;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var auth = ref.watch(authViewModelProvider);
    var user = auth.value;
    if (user == null) return Container();

    return ExpansionTile(
      backgroundColor: AppColors.WHITE,
      shape: Border.all(color: Colors.transparent),
      leading: userModel.isActive
          ? const Icon(CupertinoIcons.checkmark_circle_fill)
          : const Icon(CupertinoIcons.clear_circled),
      title: Text(userModel.fullName),
      subtitle: Text(
        userModel.role,
        style:
            Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey),
      ),
      tilePadding:
          const EdgeInsets.symmetric(horizontal: AppDimens.MAIN_SPACE * 2),
      childrenPadding: const EdgeInsets.only(
        left: AppDimens.MAIN_SPACE * 2,
        right: AppDimens.MAIN_SPACE * 2,
        bottom: AppDimens.MAIN_SPACE,
      ),
      expandedAlignment: Alignment.centerLeft,
      expandedCrossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(userModel.email),
        const SizedBox(height: AppDimens.MAIN_SPACE / 2),
        Text(userModel.profession),
        const SizedBox(height: AppDimens.MAIN_SPACE / 2),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextButton.icon(
              onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => EditEmployee(userModel: userModel))),
              icon: const Icon(CupertinoIcons.pen),
              label: const Text("Edit"),
            ),
            if (user.userId != userModel.id)
              TextButton.icon(
                onPressed: () {
                  showConfirmationBottomSheet(context, "Delete Employee",
                      "sure to delete ${userModel.fullName}?\nnote: all his notification and content will be deleted",
                      () {
                    ref.read(usersProvider.notifier).deleteUser(userModel.id);
                  });
                },
                icon: const Icon(CupertinoIcons.delete),
                label: const Text("Delete"),
              ),
          ],
        )
      ],
    );
  }
}
