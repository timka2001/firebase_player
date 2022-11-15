import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../music/music_bloc/music_bloc.dart';

import 'my_music_collection/my_music_collection.dart';

class My_Musics extends StatefulWidget {
  @override
  _My_MusicsState createState() => _My_MusicsState();
}

class _My_MusicsState extends State<My_Musics> {
  MusicBloc myMusicBloc = MusicBloc('My musics');

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: FirebaseFirestore.instance
            .collection('users')
            .doc('My musics')
            .get()
            .then((value) => value.data()),
        builder: (context, snapshot) {
          if (snapshot.data.toString() == '{}') {
            return Center(child: Text('Data Is Empty'));
          } else if (snapshot.data == null) {
            return Center(child: Text('Check name collection or doc'));
          }
          myMusicBloc.addAllMusic(snapshot.data as Map<String, dynamic>);
          return My_Music_collection(myMusicBloc);
        });
  }
}
