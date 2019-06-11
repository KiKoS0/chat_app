import 'package:flutter/material.dart';
class Counter extends StatefulWidget{


  _CounterState createState() => _CounterState();

}

class _CounterState extends State<Counter>{

  int _counter = 0;
  void _increment(){
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Row(
      children: <Widget> [
        RaisedButton(
          onPressed: _increment,
          child: Text('Increment')
        ),
        Text('Count: $_counter')
      ]
    );
  }
}