import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_teamonapp/core/constants/app_colors.dart';
import 'package:flutter_teamonapp/core/constants/app_dimens.dart';
import 'package:flutter_teamonapp/models/notification_model.dart';
import 'package:flutter_teamonapp/viewmodels/main_provider.dart';
import 'package:flutter_teamonapp/viewmodels/notifications_viewmodel.dart';
import 'package:flutter_teamonapp/views/home_page.dart';
import 'package:flutter_teamonapp/views/notifications_page.dart';
import 'package:flutter_teamonapp/views/profile_page.dart';

class MainPage extends ConsumerWidget {
  MainPage({super.key});

  final _pages = [
    const HomePage(),
    const NotificationsPage(),
    const ProfilePage(),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedPageIndex = ref.watch(selectedMainPageIndexProvider);
    final notificationsAsync = ref.watch(notificationsViewModelProvider);

    final i = (notificationsAsync.value ?? [])
        .where((n) => n.receiver?.status == NotificationModel.UNREAD)
        .toList();

    final notificationIcon = i.isEmpty
        ? const BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.bell),
            label: 'Notification',
          )
        : BottomNavigationBarItem(
            icon: Badge(
                label: Text("${i.length}"),
                child: const Icon(CupertinoIcons.bell)),
            label: 'Notification',
          );

    return Scaffold(
      backgroundColor: AppColors.WHITE,
      body: _pages[selectedPageIndex],
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
            color: AppColors.SECONDARY_LIGHT,
            borderRadius: BorderRadius.vertical(
                top: Radius.circular(AppDimens.BORDER_RADUIS))),
        child: BottomNavigationBar(
          showSelectedLabels: true,
          showUnselectedLabels: false,
          iconSize: 30,
          currentIndex: selectedPageIndex,
          onTap: (index) =>
              ref.read(selectedMainPageIndexProvider.notifier).state = index,
          items: [
            const BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.home),
              label: 'Home',
            ),
            notificationIcon,
            const BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.person),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}
