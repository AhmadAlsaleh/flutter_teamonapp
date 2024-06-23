import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MessageWidget extends StatelessWidget {
  const MessageWidget({super.key, this.message, this.height});

  final String? message;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: Center(
        child: Text(
          message ?? "Something went wrong",
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
