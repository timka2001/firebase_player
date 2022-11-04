import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_firebase_player/firebase/info.dart';
import 'dart:async';
import 'package:rxdart/rxdart.dart';

enum MusicEvent { event_add_all_music, event_add_music, event_serch_audio }

class MusicBloc {
  late AudioConverter audio_on_screen =
      AudioConverter(artsit: [], trackImage: [], trackName: [], musicUrl: []);
  bool connectionServise = false;
  final userRef = FirebaseFirestore.instance.collection('users').doc('Musics');
  MusicBloc() {
    _inputEventController.stream.listen(_increaseStream);
  }

  final StreamController _inputEventController = StreamController<MusicEvent>();
  StreamSink get inputEventSink => _inputEventController.sink;

  final _outputStateController = StreamController<AudioConverter>();
  Stream<AudioConverter> get outputStateController =>
      _outputStateController.stream;

  void _increaseStream(event) {
    if (event == MusicEvent.event_add_all_music) {
      userRef.get().then((value) {
        if (value.data() == '{}' || value.data() == null) {
        } else {
          if (audio_on_screen ==
              AudioConverter.fromJson(value.data() as Map<String, dynamic>)) {
            connectionServise = true;
          } else {
            print(value.data());
            audio_on_screen =
                AudioConverter.fromJson(value.data() as Map<String, dynamic>);
            connectionServise = false;
          }
        }
      });
    } else if (event == MusicEvent.event_serch_audio && connectionServise) {
    } else if (event == MusicEvent.event_add_music) {
    } else {
      throw Exception('Wrang Event Type');
    }
    _outputStateController.sink.add(audio_on_screen);
  }

  void dispose() {
    _inputEventController.close();
    _outputStateController.close();
  }
}
