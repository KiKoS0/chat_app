import 'package:flutter/material.dart';


class MyCoolButton extends StatelessWidget{
@override
  Widget build(BuildContext context) {
    // TODO: implement build
    return GestureDetector(
      onTap: () {
        print('Cool Button pressed');
      },
      onLongPress: () {
        print('Double tab motherfucker');
      },
      child: Container(
        height: 36.0,
        padding: const EdgeInsets.all(8.0),
        margin: const EdgeInsets.symmetric(horizontal: 8.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5.0),
          color: Colors.lightGreen[500],
        ),
        child: Center(
          child:Text('Engage')

        ),
      ),
    );
  }
}