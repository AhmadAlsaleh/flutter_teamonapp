import 'package:flutter/cupertino.dart';

class MessageWidget extends StatelessWidget {
  const MessageWidget({super.key, this.message});

  final String? message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        message ?? "Something went wrong",
        textAlign: TextAlign.center,
      ),
    );
  }
}
