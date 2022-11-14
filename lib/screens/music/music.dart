import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_player/firebase/info.dart';

import 'package:flutter_firebase_player/screens/music/music_collection/music_collection.dart';

import '../servic/servic.dart';

class Musics extends StatefulWidget {
  @override
  _MusicsState createState() => _MusicsState();
}

class _MusicsState extends State<Musics> {
  MusicBloc musicBloc = MusicBloc();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: FirebaseFirestore.instance
            .collection('users')
            .doc('Musics')
            .get()
            .then((value) => value.data()),
        builder: (context, snapshot) {
          if (snapshot.data.toString() == '{}') {
            return Center(child: Text('Data Is Empty'));
          } else if (snapshot.data == null) {
            return Center(child: Text('Check name collection or doc'));
          }
          musicBloc.addAllMusic(snapshot.data as Map<String, dynamic>);
          return Music_collection(musicBloc);
        });
  }
}
