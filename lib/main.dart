import 'package:flutter/material.dart';
import 'package:chat_app/MyCoolButton.dart';
import 'package:chat_app/counter.dart';
import 'package:chat_app/message.dart';
import 'package:flutter/rendering.dart';
void main() {
     debugPaintSizeEnabled = true;
  runApp(MaterialApp(
    title: 'Messages',
    home: MessageList(
      messages: <Message>[],
    ),
  ));

}

class TestHome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.menu),
            tooltip: 'Navigation menu',
            onPressed: null,
          ),
          title: Text('Example Title'),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.search),
              tooltip: 'Search',
              onPressed: null,
            )
          ]),
      body: Center(
        child: Column(
          children: <Widget>[MyCoolButton(), Counter()],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Add',
        child: Icon(Icons.message),
        onPressed: null,
      ),
    );
  }
}
