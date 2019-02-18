
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:chat_app/core/network.dart';

class MessagingModel extends Model {
  MessagingModel({this.network});

  final NetHandler network;
}