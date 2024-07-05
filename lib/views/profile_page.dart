import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_teamonapp/core/constants/app_colors.dart';
import 'package:flutter_teamonapp/core/constants/app_dimens.dart';
import 'package:flutter_teamonapp/viewmodels/user_viewmodel.dart';
import 'package:flutter_teamonapp/views/change_password.dart';
import 'package:flutter_teamonapp/views/edit_information.dart';
import 'package:flutter_teamonapp/widgets/loading.dart';
import 'package:flutter_teamonapp/widgets/logout.dart';
import 'package:flutter_teamonapp/widgets/message.dart';
import 'package:flutter_teamonapp/widgets/admin/profile_admin_widget.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userModelAsync = ref.watch(userViewModelProvider);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppDimens.MAIN_SPACE),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minHeight: AppDimens.screenHeight(context),
        ),
        child: SafeArea(
          child: userModelAsync.when(
              data: (data) => data == null
                  ? const MessageWidget()
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(data.profession,
                            style: Theme.of(context).textTheme.titleLarge),
                        Text(data.fullName,
                            style: Theme.of(context).textTheme.displayLarge),
                        const SizedBox(height: AppDimens.MAIN_SPACE * 2),
                        if (data.role == 'admin') const ProfileAdminWidget(),
                        const SizedBox(height: AppDimens.MAIN_SPACE),
                        Card(
                          color: AppColors.SECONDARY_LIGHT,
                          child: Column(
                            children:
                                ListTile.divideTiles(context: context, tiles: [
                              ListTile(
                                title: const Text("Edit information"),
                                onTap: () => showModalBottomSheet(
                                  context: context,
                                  isScrollControlled: true,
                                  isDismissible: false,
                                  shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.vertical(
                                        top: Radius.circular(
                                            AppDimens.BORDER_RADUIS)),
                                  ),
                                  backgroundColor: Colors.white,
                                  builder: (_) =>
                                      EditInformation(userModel: data),
                                ),
                              ),
                              ListTile(
                                title: const Text("Change Password"),
                                onTap: () => showModalBottomSheet(
                                  context: context,
                                  isScrollControlled: true,
                                  isDismissible: false,
                                  shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.vertical(
                                        top: Radius.circular(
                                            AppDimens.BORDER_RADUIS)),
                                  ),
                                  backgroundColor: Colors.white,
                                  builder: (_) =>
                                      ChangePassword(userModel: data),
                                ),
                              ),
                            ]).toList(),
                          ),
                        ),
                        const SizedBox(height: AppDimens.MAIN_SPACE),
                        const Card(
                          color: AppColors.SECONDARY_LIGHT,
                          child: LogoutWidget(),
                        ),
                      ],
                    ),
              error: (e, s) => const MessageWidget(),
              loading: () => const LoadingWidget()),
        ),
      ),
    );
  }
}
