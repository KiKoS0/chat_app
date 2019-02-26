import 'package:chat_app/models/conversation_models.dart';
import 'package:chat_app/models/messages_models.dart';
import 'package:chat_app/models/users_model.dart';
import 'package:chat_app/widgets/message.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart';

class NetHandler {
  String _apiCookieKey;
  String get apiCookieKey => _apiCookieKey;
  String userName;
  String userId;
  bool useHttps = true;
  bool useLocalNetwork = false;

  NetHandler({this.useHttps, this.useLocalNetwork});

  final String _localUrl = "192.168.1.22:8080/";
  final String _deployUrl = "kn-chat.herokuapp.com/";

  String _getUrl() {
    return (useHttps ? "https://" : "http://") +
        (useLocalNetwork ? _localUrl : _deployUrl);
  }

  bool _checkOk(Response response) {
    return response.statusCode == 200;
  }

  Future<bool> authenticate(AuthenticationModel credentials) async {
    try {
      print(useHttps);
      print(useLocalNetwork);
      String test = _getUrl() + 'account/login';
      print(test);
      final login = await http.post(test,
          headers: {
            HttpHeaders.contentTypeHeader: "application/json",
          },
          body: json.encode(credentials.toJsonEncodable()));
      print(login.statusCode);
      if (_checkOk(login)) {
        _apiCookieKey =
            login.headers[HttpHeaders.setCookieHeader].split(';')[0];
        await getInfo();
        return true;
      }
    } on Exception catch (e) {
      print(e.toString());
    }
    return false;
  }

  Future<void> getInfo() async {
    final inf = await http.post(
      _getUrl() + 'account/info',
      headers: {
        HttpHeaders.contentTypeHeader: "application/json",
        HttpHeaders.cookieHeader: apiCookieKey
      },
    );
    var decoded = json.decode(inf.body);
    userId = decoded['ui'];
    userName = decoded['un'];
    print(userId);
    print(userName);
  }

  Future<bool> sendMessage(String message, Conversation conv) async {
    try {
      // print("DEBUGGGG");
      // print(message);
      // print(conv.id);
      Map data = {'ConversationId': conv.id.toString(), 'Text': message};
      var a = json.encode(data);
      print(a);
      final rep = await http.post(_getUrl() + 'message/send',
          headers: {
            HttpHeaders.contentTypeHeader: "application/json",
            HttpHeaders.cookieHeader: apiCookieKey
          },
          body: json.encode(data));
      print('message ' + rep.statusCode.toString());
      if (rep.statusCode == 200) {
        return true;
      }
    } on Exception catch (e) {
      print(e.toString());
    }
    return false;
  }

  Future<bool> isAuthenticated() async {
    try {
      final res = await http.get(_getUrl() + 'api/protected',
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
      final login = await http.post(_getUrl() + 'account/register',
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

  Future<List<MessageModel>> getMessages(Conversation conversation) async {
    try {
      Map data = {'ConversationId': conversation.id.toString()};
      print("api cookie " + _apiCookieKey);
      final rep = await http.post(_getUrl() + 'message/get',
          headers: {
            HttpHeaders.contentTypeHeader: "application/json",
            HttpHeaders.cookieHeader: apiCookieKey
          },
          body: json.encode(data));

      print("heyehaeha " + rep.body);
      List<dynamic> decoded = json.decode(rep.body);
      List<MessageModel> ret = List<MessageModel>.from(
          decoded.map((hashMap) => MessageModel.fromJson(hashMap)));
      return ret;
    } on Exception catch (e) {
      print(e.toString());
    }
    return null;
  }

  Future<List<ConversationModel>> getConversations() async {
    try {
      final convs = await http.post(
        _getUrl() + 'conversation/get',
        headers: {
          HttpHeaders.contentTypeHeader: "application/json",
          HttpHeaders.cookieHeader: apiCookieKey
        },
      );
      // print(convs.body);
      List<dynamic> decoded = json.decode(convs.body);
      List<ConversationModel> ret = List<ConversationModel>.from(
          decoded.map((hashMap) => ConversationModel.fromJson(hashMap)));
      return ret;
    } on Exception catch (e) {
      print(e.toString());
    }
    return null;
  }

  Future<ConversationModel> createConversation(String id) async {
    try {
      Map data = {'ui': id};
      final conv = await http.post(_getUrl() + 'conversation/create',
          headers: {
            HttpHeaders.contentTypeHeader: "application/json",
            HttpHeaders.cookieHeader: apiCookieKey
          },
          body: json.encode(data));
      print(conv.body);
      ConversationModel ret =
          ConversationModel.fromJson(json.decode(conv.body));
      return ret;
    } on Exception catch (e) {
      print(e.toString());
    }
    return null;
  }

  Future<List<UserModel>> getUsers(String username) async {
    try {
      Map data = {'username': username};
      final convs = await http.post(_getUrl() + 'user/search',
          headers: {
            HttpHeaders.contentTypeHeader: "application/json",
            HttpHeaders.cookieHeader: apiCookieKey
          },
          body: json.encode(data));
      print(convs.body);
      List<dynamic> decoded = json.decode(convs.body);
      List<UserModel> ret = List<UserModel>.from(
          decoded.map((hashMap) => UserModel.fromJson(hashMap)));
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
