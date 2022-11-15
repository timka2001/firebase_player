import 'package:flutter/material.dart';

import '../../music/music_bloc/music_bloc.dart';

Widget columnBottomShet({required MusicBloc information}) {
  return Column(
    children: [
      Padding(
        padding: EdgeInsets.only(top: 10),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Image.network(
            information
                .audio_on_screen.trackImage[information.playNow.tapIndex],
            width: 350,
            height: 350,
            fit: BoxFit.cover,
          ),
        ),
      ),
      const SizedBox(
        height: 32,
      ),
      Padding(
        padding: EdgeInsets.only(left: 40),
        child: ListTile(
            title: Center(
              child: Text(
                information
                    .audio_on_screen.artist[information.playNow.tapIndex],
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
            ),
            subtitle: Center(
              child: Text(
                information
                    .audio_on_screen.trackName[information.playNow.tapIndex],
                style: TextStyle(fontSize: 24, color: Colors.white),
              ),
            ),
            trailing: information.nameDocument == 'Musics'
                ? StatefulBuilder(builder: (context, state) {
                    return IconButton(
                      icon: Icon(
                        Icons.add,
                        color: Colors.pink,
                      ),
                      iconSize: 20,
                      onPressed: () {
                        information.inputAudioEventSink
                            .add(AudioEvent.evvent_add_My_musics);
                      },
                    );
                  })
                : Text('')),
      ),
      StatefulBuilder(builder: (context, state) {
        return Slider(
            min: 0,
            max: information.playNow.duration.inSeconds.toDouble(),
            value: information.playNow.position.inSeconds.toDouble(),
            onChanged: (value) {
              state(() {
                final position = Duration(seconds: value.toInt());

                information.playNow.audioPlayer.seek(position);
              });
            });
      }),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              formatTime(information.playNow.position),
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            Text(
              formatTime(
                  information.playNow.duration - information.playNow.position),
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.only(top: 40, right: 15),
            child: CircleAvatar(
              radius: 35,
              child: IconButton(
                  icon: Icon(
                    Icons.skip_previous_rounded,
                  ),
                  iconSize: 40,
                  onPressed: () async {
                    information.inputAudioEventSink
                        .add(AudioEvent.event_skip_back);
                  }),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
              top: 40,
            ),
            child: StatefulBuilder(builder: (context, state) {
              return CircleAvatar(
                radius: 35,
                child: IconButton(
                  icon: Icon(
                    information.playNow.isPlaying
                        ? Icons.pause
                        : Icons.play_arrow,
                  ),
                  iconSize: 40,
                  onPressed: () async {
                    information.playNow.isPlaying
                        ? information.inputAudioEventSink
                            .add(AudioEvent.event_stop)
                        : information.inputAudioEventSink
                            .add(AudioEvent.event_play);
                  },
                ),
              );
            }),
          ),
          Padding(
            padding: EdgeInsets.only(top: 40, left: 15),
            child: StatefulBuilder(builder: (context, state) {
              return CircleAvatar(
                radius: 35,
                child: IconButton(
                    icon: Icon(
                      Icons.skip_next_rounded,
                    ),
                    iconSize: 40,
                    onPressed: () async {
                      information.inputAudioEventSink
                          .add(AudioEvent.event_skip_next);
                    }),
              );
            }),
          ),
        ],
      ),
    ],
  );
}

String formatTime(Duration duration) {
  String twoDigits(int n) {
    return n.toString().padLeft(2, '0');
  }

  final hours = twoDigits(duration.inHours);
  final minutes = twoDigits(duration.inMinutes.remainder(60));
  final seconds = twoDigits(duration.inSeconds.remainder(60));
  return [
    if (duration.inHours > 0) hours,
    minutes,
    seconds,
  ].join(':');
}
