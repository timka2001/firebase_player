import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_firebase_player/screens/music/music_collection/music_collection.dart';
import 'package:flutter_firebase_player/services/music_bloc.dart';
import '../../firebase/info.dart';
import '../../services/music_bloc.dart';

class Musics extends StatefulWidget {
  @override
  _MusicsState createState() => _MusicsState();
}

class _MusicsState extends State<Musics> {
  // ignore: non_constant_identifier_names
  // late AudioConverter my_audio_information;
  // final userRef = FirebaseFirestore.instance.collection('users').doc('Musics');
  // @override
  // Widget build(BuildContext context) {
  //   return StreamBuilder<DocumentSnapshot>(
  //       stream: userRef.snapshots().map((event) => event),
  //       builder:
  //           (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
  //         if (snapshot.connectionState == ConnectionState.active) {
  //           if (snapshot.data?.data() != null) {
  //             if (snapshot.data?.data().toString() == "{}") {
  //               return Center(
  //                   child: Text("Empty: my_audio_information.artsit"));
  //             } else {
  //               my_audio_information = AudioConverter.fromJson(
  //                   snapshot.data!.data() as Map<String, dynamic>);
  //               return Music_collection(my_audio_information);
  //             }
  //           }
  //           return Center(child: Text('active'));
  //         }
  //         return Center(child: Text("Error"));
  //       });
  // }
  MusicBloc musicBloc = MusicBloc();
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: musicBloc.outputStateController,
        builder: (context, snapshot) {
          if (musicBloc.connectionServise == false) {
            print(' connection  firebase');
            musicBloc.inputEventSink.add(MusicEvent.event_add_all_music);
          } else {
            print('try connection with firebase');
          }
          if (snapshot.data != null) {
            return Center(
              child: Text('Data'),
            );
          } else {
            return Text('Eror');
          }
        });
  }
}
