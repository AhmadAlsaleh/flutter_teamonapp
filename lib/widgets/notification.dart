import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_teamonapp/core/constants/app_colors.dart';
import 'package:flutter_teamonapp/core/constants/app_dimens.dart';
import 'package:flutter_teamonapp/core/extensions/date_time_ext.dart';
import 'package:flutter_teamonapp/models/notification_model.dart';
import 'package:flutter_teamonapp/viewmodels/notifications_viewmodel.dart';

class NotificationWidget extends ConsumerWidget {
  const NotificationWidget({super.key, required this.notification});

  final NotificationModel notification;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.read(notificationsViewModelProvider);

    return Card(
      color: notification.status == NotificationModel.READ
          ? AppColors.WHITE
          : null,
      child: ListTile(
        onTap: () => (notification.status == NotificationModel.UNREAD)
            ? ref
                .read(notificationsViewModelProvider.notifier)
                .read(notification)
            : null,
        contentPadding: const EdgeInsets.all(AppDimens.MAIN_SPACE),
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: Text(notification.title)),
            const SizedBox(width: AppDimens.MAIN_SPACE / 2),
            Text(
              "${notification.createdAt.toLocal().getDate()}\n${notification.createdAt.toLocal().getTime()}",
              textAlign: TextAlign.end,
              style: const TextStyle(fontSize: 14),
            ),
          ],
        ),
        subtitle: Text(notification.body),
      ),
    );
  }
}
