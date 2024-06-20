import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_teamonapp/core/constants/app_colors.dart';
import 'package:flutter_teamonapp/core/constants/app_dimens.dart';
import 'package:flutter_teamonapp/viewmodels/admin/sent_notifications_viewmodel.dart';
import 'package:flutter_teamonapp/views/admin/push_notification_page.dart';
import 'package:flutter_teamonapp/widgets/admin/sent_notification.dart';
import 'package:flutter_teamonapp/widgets/loading.dart';
import 'package:flutter_teamonapp/widgets/message.dart';

class AdminNotifications extends ConsumerWidget {
  const AdminNotifications({super.key});

  get error => null;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var notifications = ref.watch(sentNotificationsViewModelProvider);

    return Scaffold(
      backgroundColor: AppColors.WHITE,
      appBar: AppBar(
        title: const Text("Sent Notifications", style: TextStyle(fontSize: 22)),
        actions: [
          IconButton(
            onPressed: () => ref
                .read(sentNotificationsViewModelProvider.notifier)
                .fetchData(),
            icon: const Icon(CupertinoIcons.refresh),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
                top: Radius.circular(AppDimens.BORDER_RADUIS)),
          ),
          backgroundColor: Colors.white,
          builder: (_) => const PushNotificationPage(),
        ),
        label: const Text(
          "Push Notification",
          style: TextStyle(fontSize: 16),
        ),
      ),
      body: Container(
        padding: const EdgeInsets.all(AppDimens.MAIN_SPACE),
        child: notifications.when(
            data: (data) => data.isEmpty
                ? const Center(child: MessageWidget(message: "No Data"))
                : Expanded(
                    child: ListView(
                      children: data
                          .map((notification) => SentNotificationWidget(
                              notification: notification))
                          .toList(),
                    ),
                  ),
            error: (e, s) => const Center(child: MessageWidget()),
            loading: () => const LoadingWidget()),
      ),
    );
  }
}
