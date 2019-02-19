import 'dart:async';

import 'package:flutter/material.dart';
import 'package:chat_app/widgets/sendwidget.dart';

class Message {
  const Message({this.text, this.isMine});
  final bool isMine;
  final String text;
}

typedef void MessageHandlingCallback(Message message);

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
  MessageList({Key key, this.messages}) : super(key: key);

  List<Message> messages;

  _MessageListState createState() => _MessageListState();
}

class _MessageListState extends State<MessageList> {
  ScrollController _controller = ScrollController();

  void _handleMessageDelete(Message message) {
    setState(() {
      widget.messages.remove(message);
    });
  }

  void _handleMessageAdd(Message message) {
    print('test');
    setState(() {
      widget.messages.add(message);
    });
  }
  void _handleMessagesClearAll(){
    widget.messages.clear();
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
            IconButton(icon: Icon(Icons.menu) ,onPressed: null,)
          ],
          title: Text('Super cool messenger'),
        ),
        body: Transform.translate(
          offset: Offset(0.0, -0.0 * MediaQuery.of(context).viewInsets.bottom),
          child: ListView(
            controller: _controller,
            padding: EdgeInsets.symmetric(vertical: 8.0),
            children: widget.messages.map((Message message) {
              return Container(
                  child: MessageItem(
                      message: message, onDeleteMessage: _handleMessageDelete));
            }).toList(),
          ),
        ),
        bottomNavigationBar: Transform.translate(
            offset:
                Offset(0.0, -0.0 * MediaQuery.of(context).viewInsets.bottom),
            child: _SystemPadding(
              child: BottomAppBar(
                child: MessageSendBox(
                  addMessageCallback: _handleMessageAdd,
                  scrollListCallback: _scrollListToBottom,
                  clearMessagesCallback: _handleMessagesClearAll,
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
