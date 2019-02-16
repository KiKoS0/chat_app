import 'package:flutter/material.dart';
// import 'package:chat_app/MyCoolButton.dart';
// import 'package:chat_app/counter.dart';
import 'package:chat_app/widgets/message.dart';
import 'package:flutter/rendering.dart';
import 'package:chat_app/screens/login_page.dart';
import 'package:chat_app/screens/other_screen.dart';

void main() {
  //debugPaintSizeEnabled = true;
  runApp(MyApp());
}


class MyApp extends StatelessWidget {
  final routes = <String, WidgetBuilder>{
    LoginPage.tag: (context) => LoginPage(),
    OtherScreen.tag: (context) => OtherScreen()
  };
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kodeversitas',
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
