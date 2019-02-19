import 'package:chat_app/models/conversation_models.dart';
import 'package:chat_app/widgets/message.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'dart:io';

class NetHandler {
  String _apiCookieKey;
  String get apiCookieKey => _apiCookieKey;
  Future<bool> authenticate(AuthenticationModel credentials) async {
    try {
      final login = await http.post('http://192.168.1.22:8080/account/login',
          headers: {
            HttpHeaders.contentTypeHeader: "application/json",
          },
          body: json.encode(credentials.toJsonEncodable()));
      _apiCookieKey = login.headers[HttpHeaders.setCookieHeader].split(';')[0];
    } on Exception catch (e) {
      print(e.toString());
      return false;
    }
    return true;
  }

  Future<bool> sendMessage(String message) async {
    try {
      Map data = {'conversationId': '1', 'text': message};
      final rep = await http.post('http://192.168.1.22:8080/message/send',
          headers: {
            HttpHeaders.contentTypeHeader: "application/json",
          },
          body: json.encode(data));
      if (rep.statusCode == 200) {
        return true;
      }
    } on Exception catch (e) {
      print(e.toString());
    }
    return false;
  }

  Future<List<Message>> getMessages() async {
    try {
      Map data = {'conversationId': '1'};
      final rep = await http.post('http://192.168.1.22:8080/message/get',
          headers: {
            HttpHeaders.contentTypeHeader: "application/json",
          },
          body: json.encode(data));
      final messages = json.decode(rep.body);
      List ret = List<Message>();
      for (var msg in messages['1']) {
        ret.add(Message(text: msg['text'], isMine: true));
      }
      return ret;
    } on Exception catch (e) {
      print(e.toString());
    }
  }

  Future<bool> isAuthenticated() async {
    try {
      final res = await http.get('http://192.168.1.22:8080/api/protected',
          headers: {HttpHeaders.cookieHeader: apiCookieKey});
      print(res.statusCode);
      if (res.statusCode == 200) {
        return true;
      }
    } on Exception catch (e) {
      print(e.toString());
    }
    return false;
  }

  Future<bool> register(RegisterModel credentials) async {
    try {
      final login = await http.post('http://192.168.1.22:8080/account/register',
          headers: {
            HttpHeaders.contentTypeHeader: "application/json",
          },
          body: json.encode(credentials.toJsonEncodable()));
      _apiCookieKey = login.headers[HttpHeaders.setCookieHeader].split(';')[0];
    } on Exception catch (e) {
      print(e.toString());
      return false;
    }
    return true;
  }

  Future<List<ConversationModel>> getConversations() async {
    try {
      final convs = await http.post(
        'http://192.168.1.22:8080/conversation/get',
        headers: {
          HttpHeaders.contentTypeHeader: "application/json",
          HttpHeaders.cookieHeader: apiCookieKey
        },
      );
      print(convs.body);
      List<dynamic> decoded = json.decode(convs.body);
      List<ConversationModel> ret = List<ConversationModel>.from(
          decoded.map((hashMap) => ConversationModel.fromJson(hashMap)));
      print(ret[0].id);
      print(ret[0].others);
      return ret;
    } on Exception catch (e) {
      print(e.toString());
    }
    return null;
  }
}

class AuthenticationModel {
  AuthenticationModel({this.username, this.password});

  final String username;
  final String password;

  Map toJsonEncodable() {
    return {'email': username, 'password': password};
  }
}

class RegisterModel extends AuthenticationModel {
  RegisterModel({String username, String password})
      : super(username: username, password: password);

  @override
  Map toJsonEncodable() {
    return super.toJsonEncodable();
  }
}

class Post {
  final int userId;
  final int id;
  final String title;
  final String body;

  Post({this.userId, this.id, this.title, this.body});

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      userId: json['userId'],
      id: json['id'],
      title: json['title'],
      body: json['body'],
    );
  }
}
