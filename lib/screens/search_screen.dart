import 'dart:async';

import 'package:chat_app/core/network.dart';
import 'package:chat_app/models/conversation_models.dart';
import 'package:chat_app/models/messaging_model.dart';
import 'package:chat_app/models/users_model.dart';
import 'package:chat_app/screens/conversation_screen.dart';
import 'package:chat_app/screens/other_screen.dart';
import 'package:chat_app/widgets/top_header_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:scoped_model/scoped_model.dart';

class UserItem extends StatelessWidget {
  UserItem({@required this.user});
  final User user;

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.grey[200],
        child: ListTile(
            trailing: IconButton(
              icon: Icon(Icons.group_add),
              onPressed: () {
                ScopedModel.of<MessagingModel>(context)
                    .netHandler.createConversation(user.id).then((onValue){
                      if(onValue!=null){
                        print("created");
                        Navigator.popAndPushNamed(context, ConversationScreen.tag);
                      }
                    });
                  
              },
            ),
            leading: CircleAvatar(
                backgroundColor: Colors.blue, child: Text(user.username[0][0])),
            title: InkWell(
                onTap: () {},
                child: Container(
                  constraints: BoxConstraints(minHeight: 20.0),
                  padding: EdgeInsets.all(10.0),
                  child: Text(user.username),
                ))));
  }
}

class UserList extends StatefulWidget {
  UserList({Key key}) : super(key: key);

  _UserListState createState() => _UserListState();
}

class _UserListState extends State<UserList> {
  List<User> users;
  Timer _timer;
  final TextEditingController searchController = TextEditingController();
  _UserListState();
  @override
  void initState() {
    super.initState();

    // ScopedModel.of<MessagingModel>(context)
    //     .netHandler
    //     .getConversations()
    //     .then((convs) {
    //   setState(() {
    //     if (convs != null) {
    //       users =
    //           List<User>.from(convs.map((element) => element.toConversation()));
    //     } else {
    //       print('convs returned null for some reason');
    //     }
    //   });
    // });
  }

  Widget _buildListViewConversations() {
    if (users != null && users.isNotEmpty) {
      return ListView(
        padding: EdgeInsets.symmetric(vertical: 8.0),
        children: users.map((User user) {
          return Container(child: UserItem(user: user));
        }).toList(),
      );
    } else {
      return Container(
        child: Center(
            child: Text(searchController.text != "" ? "No results found" : "")),
      );
    }
  }

  void _searchUsers(String str) {
    setState(() {
      if (_timer != null) {
        _timer.cancel();
      }
      if (str == "") {
        _timer = null;
        users = null;
      } else {
        _timer = Timer(Duration(milliseconds: 700), () {
          ScopedModel.of<MessagingModel>(context)
              .netHandler
              .getUsers(str)
              .then((us) {
            setState(() {
              if (us != null) {
                users = List<User>.from(us.map((element) => element.toUser()));
              } else {
                print('convs returned null for some reason');
              }
            });
          });
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Column(
      children: <Widget>[
        Container(
          constraints: BoxConstraints(maxHeight: 100.0),
          padding: EdgeInsets.fromLTRB(8.0, 8.0, 5.0, 15.0),
          child: TextField(
            onChanged: _searchUsers,
            controller: searchController,
            style: TextStyle(fontSize: 16.0, color: Colors.black),
            maxLines: null,
            keyboardType: TextInputType.multiline,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 0.0),
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
              hintText: 'Search user',
            ),
          ),
        ),
        Expanded(child: _buildListViewConversations()),
      ],
    );
  }
}

class SearchScreen extends StatelessWidget {
  static String tag = 'search-page';
  SearchScreen();
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
        title: Text('Add User'),
      ),
      body: UserList(),
    );
  }
}
