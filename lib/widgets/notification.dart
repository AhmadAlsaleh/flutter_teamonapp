import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_teamonapp/core/constants/app_colors.dart';
import 'package:flutter_teamonapp/core/constants/app_dimens.dart';
import 'package:flutter_teamonapp/models/notification_model.dart';
import 'package:flutter_teamonapp/viewmodels/notifications_viewmodel.dart';
import 'package:timeago/timeago.dart' as timeago;

class NotificationWidget extends ConsumerWidget {
  const NotificationWidget({super.key, required this.notification});

  final NotificationModel notification;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ExpansionTile(
      collapsedBackgroundColor:
          notification.receiver?.status == NotificationModel.READ
              ? AppColors.WHITE
              : AppColors.SECONDARY_LIGHT,
      onExpansionChanged: (b) {
        if (notification.receiver?.status == NotificationModel.UNREAD) {
          ref.read(notificationsViewModelProvider.notifier).read(notification);
        }
      },
      shape: Border.all(color: Colors.transparent),
      title: Text(notification.title),
      subtitle: Text(
        timeago.format(notification.createdAt.toLocal()),
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
        Text(notification.body),
        Text(
          "Sent by ${notification.sender.fullName}",
          style: Theme.of(context)
              .textTheme
              .bodySmall
              ?.copyWith(color: Colors.grey),
        ),
      ],
    );
  }
}
