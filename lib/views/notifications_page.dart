import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_teamonapp/core/constants/app_dimens.dart';
import 'package:flutter_teamonapp/viewmodels/notifications_viewmodel.dart';
import 'package:flutter_teamonapp/widgets/loading.dart';
import 'package:flutter_teamonapp/widgets/message.dart';
import 'package:flutter_teamonapp/widgets/notification.dart';

class NotificationsPage extends ConsumerWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var notificationsAsync = ref.watch(notificationsViewModelProvider);

    return Padding(
      padding: const EdgeInsets.all(AppDimens.MAIN_SPACE),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text("Notifications",
                      style: Theme.of(context).textTheme.titleLarge),
                ),
                IconButton(
                  icon: const Icon(CupertinoIcons.refresh),
                  onPressed: () {
                    ref
                        .read(notificationsViewModelProvider.notifier)
                        .fetchData();
                  },
                )
              ],
            ),
            const SizedBox(height: AppDimens.MAIN_SPACE),
            Expanded(
              child: notificationsAsync.when(
                data: (data) => data.isEmpty
                    ? const MessageWidget(message: "No Notifications!")
                    : ListView(
                        children: data
                            .map((notification) =>
                                NotificationWidget(notification: notification))
                            .toList(),
                      ),
                error: (e, s) => const MessageWidget(),
                loading: () => const LoadingWidget(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
