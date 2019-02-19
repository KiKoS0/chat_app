import 'package:chat_app/core/network.dart';
import 'package:chat_app/models/conversation_models.dart';
import 'package:chat_app/widgets/top_header_widget.dart';
import 'package:flutter/material.dart';

class ConversationItem extends StatelessWidget {
  ConversationItem({this.conversation});
  final Conversation conversation;

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.grey[200],
        child: ListTile(
            leading: CircleAvatar(
                backgroundColor: Colors.blue,
                child: Text(conversation.others[0][0])),
            title: Container(
              constraints: BoxConstraints(minHeight: 20.0),
              padding: EdgeInsets.all(10.0),
              child: Text(conversation.others[0]),
            )));
  }
}

class ConversationList extends StatefulWidget {
  ConversationList({Key key, this.conversations}) : super(key: key);

  List<Conversation> conversations;

  _ConversationListState createState() => _ConversationListState();
}

class _ConversationListState extends State<ConversationList> {
  @override
  void initState() {
    super.initState();
    final c = AuthenticationModel(
        username: 'testflutter@yahoo.fr', password: 'Abc!123');
    NetHandler netHandler = NetHandler();
    netHandler
        .authenticate(c)
        .then((_) => netHandler.getConversations())
        .then((convs) {
      setState(() {
        widget.conversations = List<Conversation>.from(
            convs.map((element) => element.toConversation()));
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return ListView(
      padding: EdgeInsets.symmetric(vertical: 8.0),
      children: widget.conversations.map((Conversation conversation) {
        return Container(child: ConversationItem(conversation: conversation));
      }).toList(),
    );
  }
}

class ConversationScreen extends StatelessWidget {
  static String tag = 'conv-page';
  ConversationScreen() {
    print('building conv screen');
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        title: Text('My Messages'),
      ),
      body: ConversationList(
      ),
    );
  }
}
