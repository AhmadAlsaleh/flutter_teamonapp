import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_teamonapp/core/constants/app_colors.dart';
import 'package:flutter_teamonapp/core/constants/app_dimens.dart';
import 'package:flutter_teamonapp/viewmodels/admin/sent_notifications_viewmodel.dart';
import 'package:flutter_teamonapp/views/admin/push_notification_page.dart';
import 'package:flutter_teamonapp/widgets/admin/sent_notification.dart';
import 'package:flutter_teamonapp/widgets/message.dart';
import 'package:flutter_teamonapp/widgets/my_refresh_indicator.dart';

class AdminNotifications extends ConsumerStatefulWidget {
  const AdminNotifications({super.key});

  @override
  ConsumerState<AdminNotifications> createState() => _AdminNotificationsState();
}

class _AdminNotificationsState extends ConsumerState<AdminNotifications> {
  final ScrollController _scrollController = ScrollController();
  bool _isFabVisible = true;

  @override
  initState() {
    super.initState();

    _scrollController.addListener(() {
      if (_scrollController.position.userScrollDirection ==
          ScrollDirection.reverse) {
        if (_isFabVisible == true) {
          setState(() => _isFabVisible = false);
        }
      } else {
        if (_scrollController.position.userScrollDirection ==
            ScrollDirection.forward) {
          if (_isFabVisible == false) {
            setState(() => _isFabVisible = true);
          }
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var notifications = ref.watch(sentNotificationsViewModelProvider);
    var data = notifications.valueOrNull ?? [];
    var isError = notifications.hasError;
    var isData = notifications.hasValue;

    return Scaffold(
      backgroundColor: AppColors.WHITE,
      appBar: AppBar(title: const Text("Sent Notifications")),
      floatingActionButton: Visibility(
        visible: _isFabVisible,
        child: FloatingActionButton.extended(
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
          label: const Text("Push Notification"),
        ),
      ),
      body: Column(
        children: [
          if (isError) const Expanded(child: MessageWidget()),
          Expanded(
            child: MyRefreshIndicator(
              action: () => ref
                  .read(sentNotificationsViewModelProvider.notifier)
                  .fetchData(),
              child: ListView(
                  controller: _scrollController,
                  physics: const AlwaysScrollableScrollPhysics(),
                  children: [
                    if (isData && data.isEmpty)
                      MessageWidget(
                        message: "No Notifications!",
                        height: AppDimens.screenHeight(context),
                      ),
                    ...ListTile.divideTiles(
                        context: context,
                        tiles: data.map((notification) =>
                            SentNotificationWidget(notification: notification)))
                  ]),
            ),
          ),
        ],
      ),
    );
  }
}
