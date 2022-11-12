import 'package:audioplayers/audioplayers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_firebase_player/firebase/info.dart';
import 'dart:async' show Future, Stream, StreamController, StreamSink;
import 'dart:io';

enum MusicEvent {
  event_add_all_music,
  event_add_music,
  event_searh_music,
}
enum AudioEvent { event_play, event_stop, event_skip_next, event_skip_back }

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

class MusicBloc {
  AudioConverter audio_on_screen =
      AudioConverter(artist: [], trackImage: [], trackName: [], musicUrl: []);

  bool connectionServise = false;
  /////
  Audio playNow = Audio();
  /////
  final _userRef = FirebaseFirestore.instance.collection('users').doc('Musics');

  MusicBloc() {
    _inputEventController.stream.listen(_increaseStream);

    _inputAudioEventController.stream.listen(_increaseAudioStream);
  }

  final StreamController _inputEventController = StreamController<MusicEvent>();
  StreamSink get inputEventSink => _inputEventController.sink;
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
        playNow.audioPlayer.resume();
        playNow.isPlaying = true;
        _outputAudioStateController.sink.add(playNow);
      } else if (event == AudioEvent.event_stop) {
        playNow.audioPlayer.stop();
        playNow.isPlaying = false;
        _outputAudioStateController.sink.add(playNow);
      }
    }
  }

  Future<void> audioTaped(int i) async {
    playNow.tapIndex = i;
    playNow.onTap = true;

    await playNow.audioPlayer.setSourceUrl(audio_on_screen.musicUrl[i]);
    playNow.audioPlayer
        .play(UrlSource(audio_on_screen.musicUrl[playNow.tapIndex]));

    print('position: ${playNow.position}');
    print('duration: ${playNow.duration}');

    _outputAudioStateController.sink.add(playNow);
  }

  Future<void> _increaseStream(event) async {
    if (event == MusicEvent.event_add_all_music) {
      _addAllMusic();
    } else if (event == MusicEvent.event_add_music) {
      _addMusic();
    } else {
      throw Exception('Wrang Event Type');
    }
    _outputStateController.sink.add(audio_on_screen);
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

  void _addAllMusic() {
    _userRef.get().then((value) {
      if (value.data() == null || value.data()!.isEmpty) {
        connectionServise = false;

        print('--------kkkkkkkk------');

        print(connectionServise);
      } else if (value.data()!.isNotEmpty) {
        connectionServise = true;

        print('--------fffffff------');
        print(connectionServise);
        print(value.data());

        audio_on_screen =
            AudioConverter.fromJson(value.data() as Map<String, dynamic>);
        _iniAudio();
      }
    });
  }

  void _addMusic() async {
    final result = await FilePicker.platform.pickFiles(allowMultiple: true);

    if (result == null) {
      return null;
    }

    final trackRef =
        FirebaseFirestore.instance.collection('users').doc('Track Name');

    Set<int> countFile = {};

    late TrackNameConverter my_tracs;
    trackRef.get().then((value) async {
      if (value.data() == null || value.data()!.isEmpty) {
        print(value.data());
        my_tracs = TrackNameConverter(
            trackName: result.files.map((e) => e.name).toList());
        trackRef.set(my_tracs.toJson());
        for (int i = 0; i < result.files.length; i++) {
          File file = File(result.files[i].path!);
          await FirebaseStorage.instance
              .ref(result.files[i].name)
              .putFile(file)
              .then((taskSnapshot) {
            print("task done");
            if (taskSnapshot.state == TaskState.success) {
              FirebaseStorage.instance
                  .ref(result.files[i].name)
                  .getDownloadURL()
                  .then((url) {
                print("task done Name : $url");
                audio_on_screen.musicUrl.add(url);
                audio_on_screen.artist
                    .add('artist ${audio_on_screen.artist.length + 1}');
                audio_on_screen.trackName
                    .add('Track Name ${audio_on_screen.trackName.length + 1}');
                audio_on_screen.trackImage.add(
                    'https://flutter.github.io/assets-for-api-docs/assets/widgets/owl.jpg');
                _userRef.set(audio_on_screen.toJson());
                _outputStateController.sink.add(audio_on_screen);
                print("task done Class : ${audio_on_screen.artist.length}");
              });
            }
          });
        }
      } else {
        print('value.data() : ${value.data()}');
        my_tracs =
            TrackNameConverter.fromJson(value.data() as Map<String, dynamic>);

        for (int i = 0; i < result.files.length; i++) {
          bool check = false;
          for (var name in my_tracs.trackName) {
            if (name == result.files[i].name) {
              check = true;
            }
          }
          if (!check) {
            my_tracs.trackName.add(result.files[i].name);
            countFile.add(i);
            print('myTrackName: ${my_tracs.trackName}');
            print('countFile: ${countFile}');
          }
        }
        if (countFile.isNotEmpty) {
          trackRef.set(my_tracs.toJson());
          for (var i in countFile) {
            File file = File(result.files[i].path!);
            await FirebaseStorage.instance
                .ref(result.files[i].name)
                .putFile(file)
                .then((taskSnapshot) {
              print("task done Name");
              if (taskSnapshot.state == TaskState.success) {
                FirebaseStorage.instance
                    .ref(result.files[i].name)
                    .getDownloadURL()
                    .then((url) {
                  audio_on_screen.musicUrl.add(url);
                  audio_on_screen.artist
                      .add('artist ${audio_on_screen.artist.length + 1}');
                  audio_on_screen.trackName.add(
                      'Track Name ${audio_on_screen.trackName.length + 1}');
                  audio_on_screen.trackImage.add(
                      'https://flutter.github.io/assets-for-api-docs/assets/widgets/owl.jpg');
                  _userRef.set(audio_on_screen.toJson());
                  _outputStateController.sink.add(audio_on_screen);
                });
              }
            });
          }
        }
      }
    });
  }

  void runFilter(String enteredKeyword) {
    Set<int> listResult = {};
    if (playNow.onTap = true) {
      playNow.audioPlayer.stop();
      playNow.onTap = false;

      _outputAudioStateController.sink.add(playNow);
    }

    if (connectionServise == true) {
      print('uuuuuusssssseeeeeerrrrr');
      _userRef.get().then((value) => audio_on_screen =
          AudioConverter.fromJson(value.data() as Map<String, dynamic>));
      print(audio_on_screen.artist.length);
      print('uuuuuusssssseeeeeerrrrr');
    }

    if (enteredKeyword.isEmpty) {
      _outputStateController.sink.add(audio_on_screen);
    } else if (enteredKeyword.isNotEmpty) {
      for (int i = 0; i < audio_on_screen.artist.length; i++) {
        if (audio_on_screen.artist[i]
            .toString()
            .contains(enteredKeyword.toLowerCase())) {
          listResult.add(i);
          print('artist: $listResult');
        }
      }

      for (int i = 0; i < audio_on_screen.trackImage.length; i++) {
        if (audio_on_screen.trackImage[i]
            .toString()
            .contains(enteredKeyword.toLowerCase())) {
          listResult.add(i);
          print('trackName: $listResult');
        }
      }

      MusicClass addItem = MusicClass();

      if (listResult.isNotEmpty) {
        for (var n in listResult) {
          addItem.artist.add(audio_on_screen.artist[n]);
          addItem.trackName.add(audio_on_screen.trackName[n]);
          addItem.trackImage.add(audio_on_screen.trackImage[n]);
          addItem.musicUrl.add(audio_on_screen.musicUrl[n]);
        }
        audio_on_screen = AudioConverter(
            artist: addItem.artist,
            trackName: addItem.trackName,
            trackImage: addItem.trackImage,
            musicUrl: addItem.musicUrl);
        print('--------aaaa------------');
        print('audio_on_screen');
        print('${audio_on_screen.artist}');
        print(listResult);
      } else {
        audio_on_screen = AudioConverter(
            artist: [], trackImage: [], trackName: [], musicUrl: []);
        print('--------bbbb------------');

        print('${audio_on_screen.artist}');
      }

      _outputStateController.sink.add(audio_on_screen);
    }
  }

  @override
  void disposeAudio() {
    _inputAudioEventController.close();
    _outputAudioStateController.close();
  }

  @override
  void dispose() {
    _inputEventController.close();
    _outputStateController.close();
  }
}

class MusicClass {
  List<String> artist = [];
  List<String> musicUrl = [];
  List<String> trackName = [];
  List<String> trackImage = [];
}
