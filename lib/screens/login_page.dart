import 'package:chat_app/models/messaging_model.dart';
import 'package:chat_app/screens/conversation_screen.dart';
import 'package:flutter/material.dart';
import 'package:chat_app/main.dart';
import 'package:chat_app/screens/other_screen.dart';
import 'package:chat_app/core/network.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:io';
import 'dart:convert';

import 'package:scoped_model/scoped_model.dart';

class LoginPage extends StatefulWidget {
  static String tag = 'login-page';

  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final usernameController =
      TextEditingController(text: 'testflutter@yahoo.fr');
  final passwordController = TextEditingController(text: 'Abc!123');

  @override
  Widget build(BuildContext context) {
    final logo = Hero(
      tag: 'hero',
      child: CircleAvatar(
        backgroundColor: Colors.transparent,
        radius: 48.0,
        child: Image.asset('assets/logo.png'),
      ),
    );

    final email = TextFormField(
      keyboardType: TextInputType.emailAddress,
      autofocus: false,
      controller: usernameController,
      decoration: InputDecoration(
        hintText: 'Email',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
    );

    final password = TextFormField(
      autofocus: false,
      obscureText: true,
      controller: passwordController,
      decoration: InputDecoration(
        hintText: 'Password',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
    );

    final loginButton = Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        onPressed: () async {
          //  Navigator.of(context).pushNamed(OtherScreen.tag);
          Future<http.Response> fetchPost() async {
            // Map cred = {
            //   'email' : 'testflutter@yahoo.fr',
            //   'password' : 'Abc!123'
            // };
            // final rep = await http.post('http://192.168.1.22:8080/account/register',
            //                   headers: {HttpHeaders.contentTypeHeader: "application/json",},
            //                   body: json.encode(cred));
            final c = AuthenticationModel(
                username: usernameController.text,
                password: passwordController.text);
            // final login = await http.post('http://192.168.1.22:8080/account/login',
            //                   headers: {HttpHeaders.contentTypeHeader: "application/json",},
            //                   body: json.encode(c.toJsonEncodable()));
            // print(login.statusCode);
            // final cookie = login.headers[HttpHeaders.setCookieHeader].split(';')[0];
            // print(cookie);
            // final res = await http.get('http://192.168.1.22:8080/api/protected',
            //             headers: {HttpHeaders.cookieHeader: cookie});
            // print(res.statusCode);
            // print(res.body);
            await ScopedModel.of<MessagingModel>(context).netHandler.authenticate(c).then((value){
              print(value ? "Connected" : "Not Connected");
              if (value) {
                Navigator.of(context).pushNamed(ConversationScreen.tag);
              }
            });


            // final net = NetHandler();
            // await net.authenticate(c);
            // await net.isAuthenticated().then((value) {
            //   print(value ? "Connected" : "Not Connected");
            //   if (value) {
            //     Navigator.of(context).pushNamed(ConversationScreen.tag);
            //   }
            // });
          }

          fetchPost();

        },
        padding: EdgeInsets.all(12),
        color: Colors.lightBlueAccent,
        child: Text('Log In', style: TextStyle(color: Colors.white)),
      ),
    );

    final forgotLabel = FlatButton(
      child: Text(
        'Forgot password?',
        style: TextStyle(color: Colors.black54),
      ),
      onPressed: () {},
    );

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: ListView(
          shrinkWrap: true,
          padding: EdgeInsets.only(left: 24.0, right: 24.0),
          children: <Widget>[
            logo,
            SizedBox(
              height: 48.0,
            ),
            email,
            SizedBox(
              height: 8.0,
            ),
            password,
            SizedBox(
              height: 24.0,
            ),
            loginButton,
            forgotLabel
          ],
        ),
      ),
    );
  }
}
