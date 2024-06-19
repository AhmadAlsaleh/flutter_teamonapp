import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_teamonapp/core/constants/app_dimens.dart';
import 'package:flutter_teamonapp/models/user_model.dart';
import 'package:flutter_teamonapp/viewmodels/admin/users_viewmodel.dart';
import 'package:flutter_teamonapp/views/admin/edit_employee_page.dart';

class UserWidget extends ConsumerWidget {
  const UserWidget({super.key, required this.userModel});

  final UserModel userModel;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      child: ExpansionTile(
        leading: userModel.isActive
            ? const Icon(CupertinoIcons.checkmark_circle_fill)
            : const Icon(CupertinoIcons.clear_circled),
        shape: Border.all(color: Colors.transparent),
        title: Text(userModel.fullName),
        subtitle: Text(
          userModel.role,
          style: Theme.of(context)
              .textTheme
              .bodySmall
              ?.copyWith(color: Colors.grey),
        ),
        childrenPadding: const EdgeInsets.all(AppDimens.MAIN_SPACE),
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
                onPressed: () => showModalBottomSheet(
                  context: context,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(
                        top: Radius.circular(AppDimens.BORDER_RADUIS)),
                  ),
                  backgroundColor: Colors.white,
                  builder: (_) => EditEmployeePage(userModel: userModel),
                ),
                icon: const Icon(CupertinoIcons.pen),
                label: const Text("Edit"),
              ),
              TextButton.icon(
                onPressed: () =>
                    ref.read(usersProvider.notifier).deleteUser(userModel.id),
                icon: const Icon(CupertinoIcons.delete),
                label: const Text("Delete"),
              ),
            ],
          )
        ],
      ),
    );
  }
}
