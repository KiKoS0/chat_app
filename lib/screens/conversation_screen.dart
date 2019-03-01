import 'package:chat_app/core/network.dart';
import 'package:chat_app/models/conversation_models.dart';
import 'package:chat_app/models/messaging_model.dart';
import 'package:chat_app/screens/other_screen.dart';
import 'package:chat_app/screens/search_screen.dart';
import 'package:chat_app/widgets/top_header_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:scoped_model/scoped_model.dart';

class ConversationItem extends StatelessWidget {
  ConversationItem({@required this.conversation});
  final Conversation conversation;

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.grey[200],
        child: ListTile(
            leading: CircleAvatar(
                backgroundColor: Colors.blue,
                child: Text(conversation.others[0][0])),
            title: InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) => OtherScreen(
                                conversation: conversation,
                              )));
                },
                child: Container(
                  constraints: BoxConstraints(minHeight: 20.0),
                  padding: EdgeInsets.all(10.0),
                  child: Text(conversation.others[0]),
                ))));
  }
}

class ConversationList extends StatefulWidget {
  ConversationList({Key key}) : super(key: key);

  _ConversationListState createState() => _ConversationListState();
}

class _ConversationListState extends State<ConversationList> {
  List<Conversation> conversations;
  _ConversationListState();
  @override
  void initState() {
    print('INITITITTITTIT');
    super.initState();

    ScopedModel.of<MessagingModel>(context)
        .netHandler
        .getConversations()
        .then((convs) {
      setState(() {
        if (convs != null) {
          conversations = List<Conversation>.from(
              convs.map((element) => element.toConversation()));
        } else {
          print('convs returned null for some reason');
        }
      });
    });
  }

  bool isConversationsReady;
  Widget _buildListViewConversations() {
    if (conversations != null) {
      return ListView(
        padding: EdgeInsets.symmetric(vertical: 8.0),
        children: conversations.map((Conversation conversation) {
          return Container(child: ConversationItem(conversation: conversation));
        }).toList(),
      );
    } else {
      return Container(
        child: Center(
            child: SpinKitRotatingCircle(
          color: Colors.lightBlueAccent,
          size: 60.0,
        )),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return _buildListViewConversations();
  }
}

class ConversationScreen extends StatelessWidget {
  static String tag = 'conv-page';
  ConversationScreen() {
    print('building conv screen');
  }

  void _selectMenuButton(ConversationMenuChoice choice) {
    // THIS IS PROBABLY A SHITTY IDEA MAYBE CHANGE IT TO A STATEFUL WIDGET
    if (choice.choiceCallback != null) {
      choice.choiceCallback(ctxt);
    }
  }

  BuildContext ctxt;
  @override
  Widget build(BuildContext context) {
    this.ctxt = context;
    return WillPopScope(
        onWillPop: () {
          SystemChannels.platform.invokeMethod('SystemNavigator.pop');
          return Future(() => false);
        },
        child: Scaffold(
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
              PopupMenuButton(
                onSelected: _selectMenuButton,
                itemBuilder: (BuildContext context) {
                  return choices.map((ConversationMenuChoice choice) {
                    return PopupMenuItem<ConversationMenuChoice>(
                      value: choice,
                      child: Row(
                        children: <Widget>[
                          Container(
                            child: choice.icon ?? Container(),
                            margin: EdgeInsets.only(right: 10.0, left: 0.0),
                          ),
                          Expanded(
                            child: Text(choice.title),
                          ),
                        ],
                      ),
                    );
                  }).toList();
                },
              )
              // IconButton(
              //   icon: Icon(Icons.menu),
              //   onPressed: null,
              // )
            ],
            title: Text('My Messages'),
          ),
          body: ConversationList(),
          floatingActionButton: FloatingActionButton(
            child: Icon(
              Icons.add,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.of(context).pushNamed(SearchScreen.tag);
            },
          ),
        ));
  }
}

void _addCallback(BuildContext context) {
  Navigator.of(context).pushNamed(SearchScreen.tag);
}

void _disconnectCallback(BuildContext context) {
  ScopedModel.of<MessagingModel>(context).netHandler.logout();
  Navigator.pop(context);
}

const List<ConversationMenuChoice> choices = const <ConversationMenuChoice>[
  const ConversationMenuChoice(
      title: 'Disconnect',
      choiceCallback: _disconnectCallback,
      icon: Icon(
        Icons.lock_outline,
        color: Colors.lightBlueAccent,
      ))
];

typedef void ChoiceCallback(BuildContext message);

class ConversationMenuChoice {
  final String title;
  final Icon icon;
  final ChoiceCallback choiceCallback;
  const ConversationMenuChoice({this.title, this.choiceCallback, this.icon});
}
