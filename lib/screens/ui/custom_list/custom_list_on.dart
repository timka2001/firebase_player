import 'package:flutter/material.dart';

import '../../music/music_bloc/music_bloc.dart';

Widget customListTileOn(
    {required String title,
    required String single,
    required String cover,
    required MusicBloc information,
    onTap}) {
  return ListTile(
      onTap: onTap,
      tileColor: Color.fromRGBO(18, 18, 18, 18),
      textColor: Colors.white,
      iconColor: Colors.white,
      trailing: LayoutBuilder(builder: (context, constraints) {
        return IconButton(
            onPressed: () {
              information.playNow.isPlaying
                  ? information.inputAudioEventSink.add(AudioEvent.event_stop)
                  : information.inputAudioEventSink.add(AudioEvent.event_play);
            },
            icon: Icon(
              information.playNow.isPlaying ? Icons.pause : Icons.play_arrow,
              color: Color.fromARGB(255, 209, 51, 237),
            ));
      }),
      leading: ConstrainedBox(
        constraints: BoxConstraints(
            maxHeight: 44, minHeight: 44, maxWidth: 64, minWidth: 64),
        child: Image.network(cover),
      ),
      title: Text(
        title,
        textAlign: TextAlign.left,
      ),
      subtitle: Text(
        single,
        textAlign: TextAlign.start,
      ));
}
