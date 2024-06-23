// ignore_for_file: constant_identifier_names

import 'package:flutter/material.dart';

class AppDimens {
  static const double BORDER_RADUIS = 12.0;
  static const double MAIN_SPACE = 14.0;

  static double screenHeight(BuildContext context) {
    const appBarHeight = kToolbarHeight;
    const bottomAppBarHeight = 60;

    final screenHeight = MediaQuery.of(context).size.height;
    return screenHeight -
        appBarHeight -
        bottomAppBarHeight -
        AppDimens.MAIN_SPACE;
  }
}
