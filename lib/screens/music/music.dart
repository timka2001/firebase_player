import 'package:flutter/material.dart';

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
    return StreamBuilder(
        stream: musicBloc.outputStateController,
        builder: (context, snapshot) {
          if (!musicBloc.connectionServise) {
            musicBloc.inputEventSink.add(MusicEvent.event_add_all_music);
          }

          if (musicBloc.connectionServise) {
            if (musicBloc.checkCount()) {
              return Music_collection(musicBloc);
            } else {
              return Center(
                  child: Text('Проверь Firebase у тебя ошибка со списками'));
            }
          }
          return Center(
            child: Text("Error"),
          );
        });
  }
}
