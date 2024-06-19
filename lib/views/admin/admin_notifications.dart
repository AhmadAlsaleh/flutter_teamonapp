import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_teamonapp/core/constants/app_colors.dart';
import 'package:flutter_teamonapp/core/constants/app_dimens.dart';
import 'package:flutter_teamonapp/viewmodels/admin/users_viewmodel.dart';
import 'package:flutter_teamonapp/widgets/loading.dart';
import 'package:flutter_teamonapp/widgets/message.dart';

class AdminNotifications extends ConsumerWidget {
  const AdminNotifications({super.key});

  get error => null;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var users = ref.watch(usersProvider);

    return Scaffold(
      backgroundColor: AppColors.WHITE,
      appBar: AppBar(
        title:
            const Text("Admin Notifications", style: TextStyle(fontSize: 22)),
      ),
      body: Container(
        padding: const EdgeInsets.all(AppDimens.MAIN_SPACE),
        child: Column(
          children: [
            TextFormField(
              onChanged: (q) => ref.read(usersProvider.notifier).search(q),
              decoration: const InputDecoration(
                  hintText: 'Search', prefixIcon: Icon(CupertinoIcons.search)),
            ),
            const SizedBox(width: AppDimens.MAIN_SPACE),
            users.when(
                data: (data) {
                  if (data.isEmpty) {
                    return const MessageWidget(message: "No Data");
                  }

                  return Expanded(child: ListView());
                },
                error: (e, s) => const Expanded(child: MessageWidget()),
                loading: () => const LoadingWidget()),
          ],
        ),
      ),
    );
  }
}
