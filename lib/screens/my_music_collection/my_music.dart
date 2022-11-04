import 'package:flutter/material.dart';

class My_Musics extends StatefulWidget {
  @override
  _My_MusicsState createState() => _My_MusicsState();
}

class _My_MusicsState extends State<My_Musics> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Text(
          'This is the My Music Collection.',
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
      ),
    );
  }
}
