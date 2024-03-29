import 'package:chat_app/core/network.dart';
import 'package:chat_app/models/conversation_models.dart';
import 'package:chat_app/models/messages_models.dart';
import 'package:chat_app/models/messaging_model.dart';
import 'package:flutter/material.dart';
import 'package:chat_app/widgets/message.dart';
import 'package:scoped_model/scoped_model.dart';

class MessageSendBox extends StatefulWidget {
  _MessageSendBox createState() => new _MessageSendBox();
  final MessageHandlingCallback addMessageCallback;
  final VoidCallback scrollListCallback;
  final VoidCallback clearMessagesCallback;
  final MessageSetHandlingCallback setAllMessagesCallback;
  final Conversation conversation;
  MessageSendBox(
      {this.addMessageCallback,
      this.scrollListCallback,
      this.clearMessagesCallback,
      this.conversation,
      this.setAllMessagesCallback});
}

class _MessageSendBox extends State<MessageSendBox> {
  _MessageSendBox() {
    myController.addListener(_onChangedMessageText);
  }
  final myController = new TextEditingController();
  bool _isButtonDisabled = true;
  void _onChangedMessageText() {
    setState(() {
      if (myController.text != "") {
        _isButtonDisabled = false;
      } else {
        _isButtonDisabled = true;
      }
    });
  }

  bool _alternate = true;
  void _sendMessage() async {
    setState(() {
      // handler.sendMessage(myController.text, widget.conversation).then((value) {
      //   print(value ? "Message sent" : "Message sent");
      // });
      // widget.clearMessagesCallback();

      ScopedModel.of<MessagingModel>(context)
          .netHandler
          .sendMessage(myController.text, widget.conversation)
          .then((_) {
        myController.text = "";
      });

      // final c = AuthenticationModel(
      //     username: 'testflutter@yahoo.fr', password: 'Abc!123');
      // handler.authenticate(c).then((_) {
      //   handler.sendMessage(myController.text, widget.conversation).then((_) {
      //     myController.text = "";
      //     handler.getMessages(widget.conversation).then((lst) {
      //       widget.setAllMessagesCallback(
      //           List<Message>.from(lst.map((e) => e.toMessage('b-b-b-b-b'))));
      //       widget.scrollListCallback();
      //     });
      //   });
      // });
      // widget.addMessageCallback(
      //     Message(text: myController.text, isMine: _alternate));
      // _alternate = !_alternate;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: Container(
              constraints: BoxConstraints(maxHeight: 100.0),
              padding: EdgeInsets.fromLTRB(8.0, 8.0, 5.0, 15.0),
              child: TextField(
                onTap: widget.scrollListCallback,
                style: TextStyle(fontSize: 16.0, color: Colors.black),
                controller: myController,
                maxLines: null,
                keyboardType: TextInputType.multiline,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 0.0),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(32.0)),
                  hintText: 'Send message',
                ),
              )),
        ),
        IconButton(
            icon: Icon(Icons.send),
            onPressed: _isButtonDisabled ? null : _sendMessage)
      ],
    );
  }
}
