import 'package:chat_app/core/network.dart';
import 'package:chat_app/models/messaging_model.dart';
import 'package:chat_app/screens/conversation_screen.dart';
import 'package:chat_app/screens/register_screen.dart';
import 'package:chat_app/screens/search_screen.dart';
import 'package:flutter/material.dart';
// import 'package:chat_app/MyCoolButton.dart';
// import 'package:chat_app/counter.dart';
import 'package:chat_app/widgets/message.dart';
import 'package:flutter/rendering.dart';
import 'package:chat_app/screens/login_page.dart';
import 'package:chat_app/screens/other_screen.dart';
import 'package:scoped_model/scoped_model.dart';

void main() {
  // debugPaintSizeEnabled = true;
  final MessagingModel messagingModel = MessagingModel(
      netHandler: NetHandler(useHttps: true, useLocalNetwork: false));

  runApp(ScopedModel<MessagingModel>(model: messagingModel, child: MyApp()));
}

class MyApp extends StatelessWidget {
  final routes = <String, WidgetBuilder>{
    LoginPage.tag: (context) => LoginPage(),
    OtherScreen.tag: (context) => OtherScreen(),
    ConversationScreen.tag: (context) => ConversationScreen(),
    SearchScreen.tag: (context) => SearchScreen(),
    RegisterPage.tag: (context) => RegisterPage()
  };
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'KNetwork',
      //debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.lightBlue,
        // fontFamily: 'Nunito',
      ),
      home: LoginPage(),
      routes: routes,
    );
  }
}

// class TestHome extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//           leading: IconButton(
//             icon: Icon(Icons.menu),
//             tooltip: 'Navigation menu',
//             onPressed: null,
//           ),
//           title: Text('Example Title'),
//           actions: <Widget>[
//             IconButton(
//               icon: Icon(Icons.search),
//               tooltip: 'Search',
//               onPressed: null,
//             )
//           ]),
//       body: Center(
//         child: Column(
//           children: <Widget>[MyCoolButton(), Counter()],
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         tooltip: 'Add',
//         child: Icon(Icons.message),
//         onPressed: null,
//       ),
//     );
//   }
// }
