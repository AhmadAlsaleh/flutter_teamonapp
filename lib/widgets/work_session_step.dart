// ignore_for_file: constant_identifier_names, unused_field

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_teamonapp/core/constants/app_colors.dart';
import 'package:flutter_teamonapp/core/extensions/date_time_ext.dart';
import 'package:flutter_teamonapp/models/work_step_model.dart';

class WorkSessionStep extends StatelessWidget {
  const WorkSessionStep({
    super.key,
    required this.step,
  });

  static const START_WORK = "start_work";
  static const END_WORK = "end_work";
  static const START_BREAK = "start_break";
  static const END_BREAK = "end_break";

  final WorkStepModel step;

  String get _title {
    switch (step.type) {
      case START_WORK:
        return "Start Work";
      case END_WORK:
        return "End Work";
      case START_BREAK:
        return "Start Break";
      case END_BREAK:
        return "End Break";
      default:
        return "";
    }
  }

  Widget get _icon {
    switch (step.type) {
      case START_WORK:
        return const Icon(CupertinoIcons.briefcase);
      case END_WORK:
        return const Icon(CupertinoIcons.house);
      case START_BREAK:
        return const Icon(CupertinoIcons.play);
      case END_BREAK:
        return const Icon(CupertinoIcons.pause);
      default:
        return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.WHITE,
      elevation: 0,
      child: ListTile(
        leading: _icon,
        title: Text(_title),
        subtitle: Text(step.dateTime.toLocal().getTime()),
      ),
    );
  }
}
