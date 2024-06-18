import 'package:flutter/cupertino.dart';
import 'package:flutter_teamonapp/core/constants/app_colors.dart';
import 'package:flutter_teamonapp/core/constants/app_dimens.dart';

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(AppDimens.MAIN_SPACE),
        child: const CupertinoActivityIndicator(
          color: AppColors.SECONDARY,
        ),
      ),
    );
  }
}
