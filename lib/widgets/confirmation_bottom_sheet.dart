import 'package:flutter/material.dart';
import 'package:flutter_teamonapp/core/constants/app_colors.dart';
import 'package:flutter_teamonapp/core/constants/app_dimens.dart';

showConfirmationBottomSheet(
    BuildContext context, String title, String message, VoidCallback onConfirm,
    {VoidCallback? onCancel}) {
  showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius:
          BorderRadius.vertical(top: Radius.circular(AppDimens.BORDER_RADUIS)),
    ),
    backgroundColor: Colors.white,
    builder: (_) => ConfirmationBottomSheet(
      title: title,
      message: message,
      onConfirm: onConfirm,
      onCancel: onCancel,
    ),
  );
}

class ConfirmationBottomSheet extends StatelessWidget {
  final String title;
  final String message;
  final VoidCallback onConfirm;
  final VoidCallback? onCancel;

  const ConfirmationBottomSheet({
    super.key,
    required this.title,
    required this.message,
    required this.onConfirm,
    this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Container(
          padding: const EdgeInsets.all(AppDimens.MAIN_SPACE),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(title, style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: AppDimens.MAIN_SPACE),
              Text(message, style: Theme.of(context).textTheme.bodyLarge),
              const SizedBox(height: AppDimens.MAIN_SPACE),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      style: Theme.of(context)
                          .elevatedButtonTheme
                          .style
                          ?.copyWith(
                              backgroundColor: const WidgetStatePropertyAll(
                                  AppColors.SECONDARY)),
                      onPressed: () {
                        Navigator.of(context).pop();
                        onCancel?.call();
                      },
                      child: const Text('Cancel'),
                    ),
                  ),
                  const SizedBox(width: AppDimens.MAIN_SPACE),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        onConfirm();
                      },
                      child: const Text('Confirm'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
