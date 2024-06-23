import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_teamonapp/core/constants/app_dimens.dart';
import 'package:flutter_teamonapp/viewmodels/notifications_viewmodel.dart';
import 'package:flutter_teamonapp/widgets/message.dart';
import 'package:flutter_teamonapp/widgets/my_refresh_indicator.dart';
import 'package:flutter_teamonapp/widgets/notification.dart';

class NotificationsPage extends ConsumerWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var notificationsAsync = ref.watch(notificationsViewModelProvider);

    var data = notificationsAsync.valueOrNull ?? [];
    var isError = notificationsAsync.hasError;
    var isData = notificationsAsync.hasValue;

    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(AppDimens.MAIN_SPACE),
            child: Text("Notifications",
                style: Theme.of(context).textTheme.titleLarge),
          ),
          if (isError) const Expanded(child: MessageWidget()),
          Expanded(
            child: MyRefreshIndicator(
              action: () =>
                  ref.read(notificationsViewModelProvider.notifier).fetchData(),
              child: ListView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  children: [
                    if (isData && data.isEmpty)
                      MessageWidget(
                        message: "No Notifications!",
                        height: AppDimens.screenHeight(context) - 115,
                      ),
                    ...ListTile.divideTiles(
                        context: context,
                        tiles: data.map((notification) =>
                            NotificationWidget(notification: notification)))
                  ]),
            ),
          ),
        ],
      ),
    );
  }
}
