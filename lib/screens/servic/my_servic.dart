import 'package:audioplayers/audioplayers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter_firebase_player/firebase/info.dart';
import 'dart:async' show Future, Stream, StreamController, StreamSink;

enum AudioEvent {
  event_play,
  event_stop,
  event_skip_next,
  event_skip_back,
}

////
class Audio {
  final audioPlayer = AudioPlayer();
  bool isPlaying = false;
  Duration duration = Duration.zero;
  Duration position = Duration.zero;
  bool onTap = false;
  int tapIndex = 0;
}
// /

class MyMusicBloc {
  AudioConverter audio_on_screen =
      AudioConverter(artist: [], trackImage: [], trackName: [], musicUrl: []);

  /////
  Audio playNow = Audio();
  /////
  final _userRef =
      FirebaseFirestore.instance.collection('users').doc('My musics');

  MyMusicBloc() {
    _inputAudioEventController.stream.listen(_increaseAudioStream);
  }

  void _iniAudio() {
    playNow.audioPlayer.onDurationChanged.listen((totalDuration) {
      playNow.duration = totalDuration;
      _outputAudioStateController.sink.add(playNow);
    });
    playNow.audioPlayer.onPositionChanged.listen((totalDuration) {
      playNow.position = totalDuration;
      _outputAudioStateController.sink.add(playNow);
    });
  }

  final _outputStateController = StreamController<AudioConverter>();
  Stream<AudioConverter> get outputStateController =>
      _outputStateController.stream;

  final StreamController _inputAudioEventController =
      StreamController<AudioEvent>();
  StreamSink get inputAudioEventSink => _inputAudioEventController.sink;

  final _outputAudioStateController = StreamController<Audio>.broadcast();
  Stream<Audio> get outputAudioStateController =>
      _outputAudioStateController.stream;

  Future<void> _increaseAudioStream(event) async {
    if (playNow.onTap) {
      if (event == AudioEvent.event_play) {
        print('play');

        print('position: ${playNow.position}');
        print('duration: ${playNow.duration}');
        playNow.isPlaying = true;
        print('isPlaying: ${playNow.isPlaying}');
        await playNow.audioPlayer.resume();

        _outputAudioStateController.sink.add(playNow);
      } else if (event == AudioEvent.event_stop) {
        await playNow.audioPlayer.pause();
        print('stop');
        print('position: ${playNow.position}');
        print('duration: ${playNow.duration}');
        playNow.isPlaying = false;
        print('isPlaying: ${playNow.isPlaying}');
        _outputAudioStateController.sink.add(playNow);
      } else if (event == AudioEvent.event_skip_back) {
        if (playNow.tapIndex != 0) {
          audioTaped(playNow.tapIndex - 1);
        } else {
          _inputAudioEventController.add(AudioEvent.event_stop);
          playNow.audioPlayer.seek(Duration.zero);
        }
      } else if (event == AudioEvent.event_skip_next) {
        if (playNow.tapIndex != audio_on_screen.musicUrl.length - 1) {
          audioTaped(playNow.tapIndex + 1);
        } else {
          _inputAudioEventController.add(AudioEvent.event_stop);
          playNow.audioPlayer.seek(Duration.zero);
        }
      }
    }
  }

  void onDismissible(int i) {
    if (playNow.onTap = true) {
      playNow.audioPlayer.stop();
      playNow.onTap = false;

      _outputAudioStateController.sink.add(playNow);
    }
    audio_on_screen.artist.removeAt(i);
    audio_on_screen.trackName.removeAt(i);
    audio_on_screen.trackImage.removeAt(i);
    audio_on_screen.musicUrl.removeAt(i);
    _userRef.set(audio_on_screen.toJson());
    _outputStateController.sink.add(audio_on_screen);
  }

  Future<void> audioTaped(int i) async {
    playNow.tapIndex = i;
    if (playNow.onTap) {
      playNow.audioPlayer.pause();
      playNow.audioPlayer.seek(Duration.zero);
    }
    playNow.onTap = true;

    await playNow.audioPlayer
        .play(UrlSource(audio_on_screen.musicUrl[playNow.tapIndex]));
    _inputAudioEventController.add(AudioEvent.event_play);
    print('position: ${playNow.position}');
    print('duration: ${playNow.duration}');

    _outputAudioStateController.sink.add(playNow);
  }

  bool checkCount() {
    if (audio_on_screen.artist.length == audio_on_screen.musicUrl.length &&
        audio_on_screen.artist.length == audio_on_screen.trackImage.length &&
        audio_on_screen.artist.length == audio_on_screen.trackName.length) {
      return true;
    } else {
      return false;
    }
  }

  void addAllMusic(Map<String, dynamic> value) {
    audio_on_screen = AudioConverter.fromJson(value);
    _iniAudio();
    _outputStateController.sink.add(audio_on_screen);
  }

  @override
  void disposeAudio() {
    _inputAudioEventController.close();
    _outputAudioStateController.close();
  }

  @override
  void dispose() {
    _outputStateController.close();
  }
}
