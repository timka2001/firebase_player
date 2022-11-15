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
enum AudioEvent {
  event_play,
  event_stop,
  event_skip_next,
  event_skip_back,
  evvent_add_My_musics
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

class MusicBloc {
  AudioConverter audio_on_screen =
      AudioConverter(artist: [], trackImage: [], trackName: [], musicUrl: []);
  bool _isDisposed = false;
  late String nameDocument;
  /////
  Audio playNow = Audio();
  /////
  final _userRef = FirebaseFirestore.instance.collection('users');

  MusicBloc(String document) {
    nameDocument = document;
    _userRef.doc(document);
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
      } else if (event == AudioEvent.evvent_add_My_musics) {
        bool addValue = false;
        AudioConverter my_music = AudioConverter(
            artist: [], trackImage: [], trackName: [], musicUrl: []);
        final userMyRef =
            FirebaseFirestore.instance.collection('users').doc('My musics');
        userMyRef.get().then((value) {
          print("value");
          print(value.data().toString());
          if (value.data().toString() != '{}' && value.data != null) {
            value.data()?.forEach((key, val) {
              print("key");
              if (key == 'musicUrl') {
                val.forEach((element) {
                  if (element.toString() ==
                      audio_on_screen.musicUrl[playNow.tapIndex]) {
                    addValue = true;
                    print("addValue");
                  }
                });
                if (!addValue) {
                  print(addValue);
                  my_music = AudioConverter.fromJson(
                      value.data() as Map<String, dynamic>);
                  my_music.artist.add(audio_on_screen.artist[playNow.tapIndex]);
                  my_music.trackName
                      .add(audio_on_screen.trackName[playNow.tapIndex]);
                  my_music.trackImage
                      .add(audio_on_screen.trackImage[playNow.tapIndex]);
                  my_music.musicUrl
                      .add(audio_on_screen.musicUrl[playNow.tapIndex]);
                  print("my_music");
                  print(my_music.toJson());

                  userMyRef.set(my_music.toJson());
                }
              }
            });
          } else if (value.data().toString() == '{}') {
            print("Hi");
            my_music.artist.add(audio_on_screen.artist[playNow.tapIndex]);
            my_music.trackName.add(audio_on_screen.trackName[playNow.tapIndex]);
            my_music.trackImage
                .add(audio_on_screen.trackImage[playNow.tapIndex]);
            my_music.musicUrl.add(audio_on_screen.musicUrl[playNow.tapIndex]);
            print("my_music");
            print(my_music.toJson());

            userMyRef.set(my_music.toJson());
          }
        });
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
    _userRef.doc(nameDocument).set(audio_on_screen.toJson());
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

  Future<void> _increaseStream(event) async {
    if (event == MusicEvent.event_add_music) {
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

  void addAllMusic(Map<String, dynamic> value) {
    if (_isDisposed) {
      return;
    }

    audio_on_screen = AudioConverter.fromJson(value);
    _iniAudio();
    _outputStateController.sink.add(audio_on_screen);
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
                    .add('Artist ${audio_on_screen.artist.length + 1}');
                audio_on_screen.trackName
                    .add('Track Name ${audio_on_screen.trackName.length + 1}');
                audio_on_screen.trackImage.add(
                    'https://flutter.github.io/assets-for-api-docs/assets/widgets/owl.jpg');
                _userRef.doc(nameDocument).set(audio_on_screen.toJson());
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
                      .add('Artist ${audio_on_screen.artist.length + 1}');
                  audio_on_screen.trackName.add(
                      'Track Name ${audio_on_screen.trackName.length + 1}');
                  audio_on_screen.trackImage.add(
                      'https://flutter.github.io/assets-for-api-docs/assets/widgets/owl.jpg');
                  _userRef.doc(nameDocument).set(audio_on_screen.toJson());
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

    if (enteredKeyword.isEmpty) {
      print('uuuuuusssssseeeeeerrrrr');
      _userRef.doc(nameDocument).get().then((value) => audio_on_screen =
          AudioConverter.fromJson(value.data() as Map<String, dynamic>));
      print(audio_on_screen.artist.length);
      print('uuuuuusssssseeeeeerrrrr');
      print('Hi Mom');
      _outputStateController.sink.add(audio_on_screen);
    } else if (enteredKeyword.isNotEmpty) {
      print('uuuuuusssssseeeeeerrrrr');
      _userRef.doc(nameDocument).get().then((value) => audio_on_screen =
          AudioConverter.fromJson(value.data() as Map<String, dynamic>));
      print(audio_on_screen.artist.length);
      print('uuuuuusssssseeeeeerrrrr');
      print('Hi Mom');
      print('Hi Man');
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
  void dispose() {
    print("Hello");

    playNow.audioPlayer.dispose();
    _inputAudioEventController.close();
    _outputAudioStateController.close();
    _inputEventController.close();
    _outputStateController.close();
    _isDisposed = true;
  }
}

class MusicClass {
  List<String> artist = [];
  List<String> musicUrl = [];
  List<String> trackName = [];
  List<String> trackImage = [];
}
