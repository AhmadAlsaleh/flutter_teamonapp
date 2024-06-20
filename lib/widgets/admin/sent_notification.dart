import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_teamonapp/core/constants/app_colors.dart';
import 'package:flutter_teamonapp/core/constants/app_dimens.dart';
import 'package:flutter_teamonapp/models/notification_model.dart';
import 'package:timeago/timeago.dart' as timeago;

class SentNotificationWidget extends ConsumerWidget {
  const SentNotificationWidget({super.key, required this.notification});

  final NotificationModel notification;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
        child: ExpansionTile(
      shape: Border.all(color: Colors.transparent),
      title: Text(notification.title),
      subtitle: Text(
        timeago.format(notification.createdAt.toLocal()),
        style: Theme.of(context)
            .textTheme
            .bodySmall
            ?.copyWith(color: AppColors.PRIMARY),
      ),
      childrenPadding: const EdgeInsets.all(AppDimens.MAIN_SPACE),
      expandedAlignment: Alignment.centerLeft,
      expandedCrossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(notification.body),
        const SizedBox(height: AppDimens.MAIN_SPACE),
        Text(
          "Receivers",
          style: Theme.of(context)
              .textTheme
              .bodyMedium
              ?.copyWith(color: AppColors.SECONDARY),
        ),
        Column(
          children: ListTile.divideTiles(
              context: context,
              tiles: notification.notificationReceivers.map((r) => ListTile(
                    trailing: r.status == NotificationModel.UNREAD
                        ? const Icon(CupertinoIcons.circle)
                        : const Icon(CupertinoIcons.checkmark_circle_fill),
                    title: Text(
                      r.user.fullName,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    subtitle: Text(
                      r.user.email,
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall
                          ?.copyWith(color: AppColors.PRIMARY),
                    ),
                  ))).toList(),
        ),
      ],
    ));
  }
}
