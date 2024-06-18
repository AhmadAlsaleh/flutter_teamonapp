import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_teamonapp/core/constants/app_strings.dart';
import 'package:flutter_teamonapp/core/constants/app_themes.dart';
import 'package:flutter_teamonapp/routes/app_routes.dart';

Future<void> main() async {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppStrings.APP_NAME,
      debugShowCheckedModeBanner: false,
      theme: appTheme(context),
      initialRoute: AppRoutes.SPLASH,
      onGenerateRoute: AppRoutes.generateRoute,
    );
  }
}
