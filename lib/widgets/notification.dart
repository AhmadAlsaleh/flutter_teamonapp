import 'package:flutter/cupertino.dart';
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
        color: notification.receiver?.status == NotificationModel.READ
            ? AppColors.WHITE
            : null,
        child: ExpansionTile(
          tilePadding:
              const EdgeInsets.only(left: 0.0, right: AppDimens.MAIN_SPACE),
          leading: IconButton(
              onPressed: () =>
                  (notification.receiver?.status == NotificationModel.UNREAD)
                      ? ref
                          .read(notificationsViewModelProvider.notifier)
                          .read(notification.receiver!)
                      : null,
              icon: notification.receiver?.status == NotificationModel.UNREAD
                  ? const Icon(CupertinoIcons.circle)
                  : const Icon(CupertinoIcons.checkmark_circle_fill)),
          shape: Border.all(color: Colors.transparent),
          title: Text(notification.title),
          subtitle: Text(
            notification.createdAt.getDateTime(),
            style: Theme.of(context)
                .textTheme
                .bodySmall
                ?.copyWith(color: Colors.grey),
          ),
          childrenPadding: const EdgeInsets.all(AppDimens.MAIN_SPACE),
          expandedAlignment: Alignment.centerLeft,
          expandedCrossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(notification.body),
            const SizedBox(height: AppDimens.MAIN_SPACE / 2),
            Text(
              "Sent by ${notification.sender.fullName}",
              style: Theme.of(context)
                  .textTheme
                  .bodySmall
                  ?.copyWith(color: Colors.grey),
            ),
          ],
        ));
  }
}
