import 'package:flutter/material.dart';
import 'package:flutter_teamonapp/views/login_page.dart';
import 'package:flutter_teamonapp/views/main_page.dart';
import 'package:flutter_teamonapp/views/splash_page.dart';

class AppRoutes {
  static const SPLASH = '/';
  static const LOGIN = '/login';
  static const MAIN = '/main';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case SPLASH:
        return MaterialPageRoute(builder: (_) => const SplashPage());

      case LOGIN:
        return MaterialPageRoute(builder: (_) => LoginPage());

      case MAIN:
        return MaterialPageRoute(builder: (_) => MainPage());

      default:
        return MaterialPageRoute(
            builder: (_) => Scaffold(
                  body: Center(
                      child: Text('No route defined for ${settings.name}')),
                ));
    }
  }
}
