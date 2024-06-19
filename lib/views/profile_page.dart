import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_teamonapp/core/constants/app_dimens.dart';
import 'package:flutter_teamonapp/routes/app_routes.dart';
import 'package:flutter_teamonapp/viewmodels/user_viewmodel.dart';
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
                          child: Column(
                            children:
                                ListTile.divideTiles(context: context, tiles: [
                              const ListTile(title: Text("Edit information")),
                              const ListTile(title: Text("Change Password")),
                            ]).toList(),
                          ),
                        ),
                        const SizedBox(height: AppDimens.MAIN_SPACE),
                        const Card(child: LogoutWidget()),
                      ],
                    ),
              error: (e, s) => const MessageWidget(),
              loading: () => const LoadingWidget()),
        ),
      ),
    );
  }
}
