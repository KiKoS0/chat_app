import 'package:chat_app/models/conversation_models.dart';
import 'package:chat_app/models/messages_models.dart';
import 'package:flutter/material.dart';
import 'package:chat_app/widgets/message.dart';

class OtherScreen extends StatelessWidget {
  static String tag = 'other-page';
  final Conversation conversation;

  OtherScreen({this.conversation});
  @override
  Widget build(BuildContext context) {
  return MessageList(
        conversation: this.conversation,
      );
  }
}