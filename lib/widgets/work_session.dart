import 'package:flutter/material.dart';
import 'package:flutter_teamonapp/models/work_session_model.dart';
import 'package:flutter_teamonapp/widgets/work_session_step.dart';

class WorkSession extends StatelessWidget {
  final WorkSessionModel workSessionModel;

  const WorkSession({super.key, required this.workSessionModel});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: workSessionModel.workSteps
          .map((step) => WorkSessionStep(step: step))
          .toList(),
    );
  }
}
