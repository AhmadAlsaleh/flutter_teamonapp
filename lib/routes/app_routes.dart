// ignore_for_file: constant_identifier_names

import 'package:flutter/material.dart';
import 'package:flutter_teamonapp/views/admin/admin_dashboard.dart';
import 'package:flutter_teamonapp/views/admin/admin_employees.dart';
import 'package:flutter_teamonapp/views/admin/admin_notifications.dart';
import 'package:flutter_teamonapp/views/login_page.dart';
import 'package:flutter_teamonapp/views/main_page.dart';
import 'package:flutter_teamonapp/views/splash_page.dart';

class AppRoutes {
  static const SPLASH = '/';
  static const LOGIN = '/login';
  static const MAIN = '/main';

  static const ADMIN_NOTIFICATIONS = '/admin-notifications';
  static const ADMIN_EMPLOYEES = '/admin-employees';
  static const ADMIN_DASHBOARD = '/admin-dashboard';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case SPLASH:
        return MaterialPageRoute(builder: (_) => const SplashPage());

      case LOGIN:
        return MaterialPageRoute(builder: (_) => LoginPage());

      case MAIN:
        return MaterialPageRoute(builder: (_) => MainPage());

      case ADMIN_NOTIFICATIONS:
        return MaterialPageRoute(builder: (_) => const AdminNotifications());

      case ADMIN_EMPLOYEES:
        return MaterialPageRoute(builder: (_) => const AdminEmployees());

      case ADMIN_DASHBOARD:
        return MaterialPageRoute(builder: (_) => const AdminDashboard());

      default:
        return MaterialPageRoute(
            builder: (_) => Scaffold(
                  body: Center(
                      child: Text('No route defined for ${settings.name}')),
                ));
    }
  }
}
