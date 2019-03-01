import 'package:chat_app/models/messaging_model.dart';
import 'package:chat_app/screens/conversation_screen.dart';
import 'package:chat_app/screens/search_screen.dart';
import 'package:flutter/material.dart';
import 'package:chat_app/main.dart';
import 'package:chat_app/screens/other_screen.dart';
import 'package:chat_app/core/network.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:scoped_model/scoped_model.dart';

class RegisterPage extends StatefulWidget {
  static String tag = 'register-page';

  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final usernameController =
      TextEditingController(text: 'testflutter@yahoo.fr');
  final passwordController = TextEditingController(text: 'Abc!123');
  final confirmPasswordController = TextEditingController(text: 'Abc!123');

  bool isLoggingIn = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      isLoggingIn = true;
    });
    ScopedModel.of<MessagingModel>(context)
        .netHandler
        .initialize()
        .then((value) {
      print(value ? "Connected" : "Not Connected");
      if (value) {
        Navigator.of(context).pushNamed(ConversationScreen.tag);
        isLoggingIn = false;
      } else {
        setState(() {
          isLoggingIn = false;
        });
      }
    });
  }

  Widget _buildLoginPage() {
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
    final confirmPassword = TextFormField(
      autofocus: false,
      obscureText: true,
      controller: confirmPasswordController,
      decoration: InputDecoration(
        hintText: 'Confirm Password',
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
          Future<http.Response> fetchPost() async {
            if (confirmPasswordController.text == passwordController.text) {
              final c = AuthenticationModel(
                  username: usernameController.text,
                  password: passwordController.text);
              await ScopedModel.of<MessagingModel>(context)
                  .netHandler
                  .authenticate(c,false)
                  .then((value) {
                print(value ? "Connected" : "Not Connected");
                if (value) {
                  Navigator.of(context).popAndPushNamed(ConversationScreen.tag);
                  isLoggingIn = false;
                } else {
                  setState(() {
                    isLoggingIn = false;
                  });
                }
              });
            } else {
              setState(() {
                isLoggingIn = false;
              });
            }
          }

          setState(() {
            isLoggingIn = true;
          });
          fetchPost();
        },
        padding: EdgeInsets.all(12),
        color: Colors.lightBlueAccent,
        child: Text('Register', style: TextStyle(color: Colors.white)),
      ),
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
              height: 8.0,
            ),
            confirmPassword,
            SizedBox(
              height: 24.0,
            ),
            loginButton,
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isLoggingIn) {
      return Scaffold(
        backgroundColor: Colors.white,
        body: Center(
            child: SpinKitCubeGrid(
          color: Colors.lightBlueAccent,
          size: 100.0,
        )),
      );
    } else {
      return _buildLoginPage();
    }
  }
}