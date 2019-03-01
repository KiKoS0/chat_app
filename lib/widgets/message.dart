import 'dart:async';

import 'package:chat_app/models/conversation_models.dart';
import 'package:chat_app/models/messages_models.dart';
import 'package:chat_app/models/messaging_model.dart';
import 'package:flutter/material.dart';
import 'package:chat_app/widgets/sendwidget.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:scoped_model/scoped_model.dart';

typedef void MessageHandlingCallback(Message message);
typedef void MessageSetHandlingCallback(List<Message> messages);

class MessageItem extends StatelessWidget {
  MessageItem({Message message, this.onDeleteMessage})
      : message = message,
        super(key: ObjectKey(message));
  final Message message;
  final MessageHandlingCallback onDeleteMessage;
  @override
  Widget build(BuildContext context) {
    if (!message.isMine) {
      return ListTile(
          onLongPress: () => onDeleteMessage(message),
          trailing: CircleAvatar(
              backgroundColor: Colors.blue, child: Text(message.text[0])),
          title: Container(
            constraints: BoxConstraints(minHeight: 20.0),
            padding: EdgeInsets.all(15.0),
            child: Text(message.text),
            decoration: BoxDecoration(
                boxShadow: <BoxShadow>[
                  BoxShadow(
                      color: Colors.blueGrey[100],
                      offset: Offset(2.0, 1.0),
                      blurRadius: 1.0),
                ],
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(12.0)),
          ));
    }
    return ListTile(
        onLongPress: () => onDeleteMessage(message),
        leading: CircleAvatar(
            backgroundColor: Colors.blue, child: Text(message.text[0])),
        title: Container(
          alignment: Alignment.bottomLeft,
          constraints: BoxConstraints(minHeight: 20.0),
          padding: EdgeInsets.all(15.0),
          child: Text(message.text),
          decoration: BoxDecoration(
              boxShadow: <BoxShadow>[
                BoxShadow(
                    color: Colors.blueGrey[100],
                    offset: Offset(2.0, 1.0),
                    blurRadius: 1.0),
              ],
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(12.0)),
        ));
  }
}

class MessageList extends StatefulWidget {
  MessageList({Key key, this.conversation}) : super(key: key);

  final Conversation conversation;

  _MessageListState createState() => _MessageListState();
}

class _MessageListState extends State<MessageList> {
  ScrollController _controller = ScrollController();
  List<Message> messages;
  Timer _timer;

  void _updateMessages() async {
    print('update');
    setState(() {
      ScopedModel.of<MessagingModel>(context)
          .netHandler
          .getMessages(widget.conversation)
          .then((lst) {
        _handleGetAllMessages(List<Message>.from(lst.map((e) => e.toMessage(
            ScopedModel.of<MessagingModel>(context).netHandler.userId))));
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        print('update');
        ScopedModel.of<MessagingModel>(context)
            .netHandler
            .getMessages(widget.conversation)
            .then((lst) {
          _handleGetAllMessages(List<Message>.from(lst.map((e) => e.toMessage(
              ScopedModel.of<MessagingModel>(context).netHandler.userId))));
        }).then((_){
          // _scrollListToBottom();
        });
      });
    });
  }

  void _handleMessageDelete(Message message) {
    setState(() {
      messages.remove(message);
    });
  }

  void _handleGetAllMessages(List<Message> msgs) {
    setState(() {
      if (messages == null || msgs.length > messages.length) {
        messages = msgs;
        _scrollListToBottom();
      }
    });
  }

  void _handleMessageAdd(Message message) {
    print('test');
    setState(() {
      messages.add(message);
    });
  }

  void _handleMessagesClearAll() {
    // widget.messages.clear();
  }

  void _scrollListToBottom() {
    setState(() {
      Timer(
          Duration(milliseconds: 300),
          () => _controller.animateTo(_controller.position.maxScrollExtent,
              duration: const Duration(milliseconds: 150),
              curve: Curves.easeOut));
    });
  }

  Widget _buildListMessages() {
    if (messages != null) {
      return ListView(
        controller: _controller,
        padding: EdgeInsets.symmetric(vertical: 8.0),
        children: messages.map((Message message) {
          return Container(
              child: MessageItem(
                  message: message, onDeleteMessage: _handleMessageDelete));
        }).toList(),
      );
    } else {
      return Container(
        child: Center(
            child: SpinKitFadingCube (
          color: Colors.lightBlueAccent,
          size: 60.0,
        )),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    print('rebuilding messagelist state');
    // TODO: implement build
    return Scaffold(
        resizeToAvoidBottomPadding: false,
        appBar: AppBar(
          backgroundColor: Colors.white,
          leading: Hero(
            tag: 'hero',
            child: CircleAvatar(
              backgroundColor: Colors.transparent,
              radius: 15.0,
              child: Image.asset('assets/logo.png'),
            ),
          ),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.menu),
              onPressed: null,
            )
          ],
          title: Text(widget.conversation.others[0]),
        ),
        body: Transform.translate(
          offset: Offset(0.0, -0.0 * MediaQuery.of(context).viewInsets.bottom),
          child: _buildListMessages(),
        ),
        bottomNavigationBar: Transform.translate(
            offset:
                Offset(0.0, -0.0 * MediaQuery.of(context).viewInsets.bottom),
            child: _SystemPadding(
              child: BottomAppBar(
                child: MessageSendBox(
                  conversation: widget.conversation,
                  addMessageCallback: _handleMessageAdd,
                  scrollListCallback: _scrollListToBottom,
                  clearMessagesCallback: _handleMessagesClearAll,
                  setAllMessagesCallback: _handleGetAllMessages,
                ),
              ),
            )));
  }
}

class _SystemPadding extends StatelessWidget {
  final Widget child;
  _SystemPadding({Key key, this.child}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context).viewInsets;
    return new AnimatedContainer(
        padding: mediaQuery,
        duration: const Duration(milliseconds: 300),
        child: child);
  }
}

//@override
//   Widget build(BuildContext context) {
//     print('rebuilding messagelist state');
//     // TODO: implement build
//     return Scaffold(
//         resizeToAvoidBottomPadding: false,
//         body: Column(
//           children: <Widget>[
//             TopHeader(
//               icon: Icon(Icons.menu),
//               title: Text(
//                 "Someone",
//                 style: TextStyle(
//                     fontSize: 20.0,
//                     color: Colors.black,
//                     fontWeight: FontWeight.w400),
//               ),
//             ),
//             Expanded(
//               child: ListView(
//                 controller: _controller,
//                 padding: EdgeInsets.symmetric(vertical: 8.0),
//                 children: widget.messages.map((Message message) {
//                   return Container(
//                       child: MessageItem(
//                           message: message,
//                           onDeleteMessage: _handleMessageDelete));
//                 }).toList(),
//               ),
//             )
//           ],
//         ),
//         bottomNavigationBar: Transform.translate(
//             offset:
//                 Offset(0.0, -0.0 * MediaQuery.of(context).viewInsets.bottom),
//             child: _SystemPadding(
//               child: BottomAppBar(
//                 child: MessageSendBox(
//                   addMessageCallback: _handleMessageAdd,
//                   scrollListCallback: _scrollListToBottom,
//                   clearMessagesCallback: _handleMessagesClearAll,
//                 ),
//               ),
//             )));
//   }
// }
