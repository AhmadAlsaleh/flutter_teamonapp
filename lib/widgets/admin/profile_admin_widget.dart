import 'package:flutter/material.dart';
import 'package:flutter_teamonapp/core/constants/app_dimens.dart';
import 'package:flutter_teamonapp/routes/app_routes.dart';

class ProfileAdminWidget extends StatelessWidget {
  const ProfileAdminWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Admin Tools",
          style: Theme.of(context).textTheme.displaySmall,
        ),
        const SizedBox(height: AppDimens.MAIN_SPACE / 2),
        Card(
          child: Column(
            children: ListTile.divideTiles(context: context, tiles: [
              ListTile(
                  title: const Text("Dashboard"),
                  onTap: () =>
                      Navigator.pushNamed(context, AppRoutes.ADMIN_DASHBOARD)),
              ListTile(
                  title: const Text("Employees"),
                  onTap: () =>
                      Navigator.pushNamed(context, AppRoutes.ADMIN_EMPLOYEES)),
              ListTile(
                  title: const Text("Notifications"),
                  onTap: () => Navigator.pushNamed(
                      context, AppRoutes.ADMIN_NOTIFICATIONS)),
            ]).toList(),
          ),
        ),
      ],
    );
  }
}
