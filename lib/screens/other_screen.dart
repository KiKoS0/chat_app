import 'package:flutter/material.dart';
import 'package:chat_app/widgets/message.dart';

class OtherScreen extends StatelessWidget {
  static String tag = 'other-page';
  @override
  Widget build(BuildContext context) {
  return MessageList(
        messages: <Message>[],
      );
  }
}