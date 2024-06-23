import 'dart:math' as math;
import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_teamonapp/core/constants/app_colors.dart';
import 'package:flutter_teamonapp/core/constants/app_dimens.dart';

class MyRefreshIndicator extends StatelessWidget {
  const MyRefreshIndicator(
      {super.key, required this.action, required this.child});

  final Future<void> Function() action;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return CustomRefreshIndicator(
      onRefresh: action,
      builder: (BuildContext context, Widget child,
              IndicatorController controller) =>
          Stack(
        alignment: Alignment.topCenter,
        children: <Widget>[
          if (!controller.isIdle)
            Column(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 60.0 * (controller.value + .5),
                  alignment: Alignment.center,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Transform.rotate(
                        angle: math.min(math.pi * controller.value, math.pi),
                        child: const Icon(CupertinoIcons.arrow_down,
                            color: AppColors.PRIMARY),
                      ),
                      const SizedBox(width: AppDimens.MAIN_SPACE),
                      Text(
                        "Pull to refresh",
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.copyWith(color: AppColors.PRIMARY),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          if (controller.isLoading)
            Container(
              color: AppColors.WHITE,
              width: MediaQuery.of(context).size.width,
              height: 60,
              padding: const EdgeInsets.all(AppDimens.MAIN_SPACE),
              child: const CupertinoActivityIndicator(
                color: AppColors.PRIMARY,
              ),
            ),
          Transform.translate(
            offset: Offset(0, 60.0 * controller.value),
            child: child,
          ),
        ],
      ),
      child: child,
    );
  }
}
