import 'package:flutter/material.dart';

class TopHeader extends StatelessWidget {
  TopHeader({this.icon, this.title});

  final Icon icon;
  final Widget title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 20.0),
      child: Row(
        children: <Widget>[
          Hero(
            tag: 'hero',
            child: CircleAvatar(
              backgroundColor: Colors.transparent,
              radius: 30.0,
              child: Image.asset('assets/logo.png'),
            ),
          ),
          Expanded(
            child: Padding(
                padding: const EdgeInsets.only(left: 8.0), child: title),
          ),
          icon,
        ],
      ),
    );
  }
}
