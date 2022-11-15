import 'package:audioplayers/audioplayers.dart';

import 'package:flutter/material.dart';
import 'package:flutter_firebase_player/screens/ui/show_modal_bottom/show_modal_bottom.dart';

import '../../music/music_bloc/music_bloc.dart';
import '../../ui/custom_list/custom_list.dart';
import '../../ui/custom_list/custom_list_on.dart';

class My_Music_collection extends StatefulWidget {
  // ignore: use_key_in_widget_constructors
  My_Music_collection(MusicBloc musicBloc) {
    print("object");
    information = musicBloc;
  }

  @override
  _My_Music_collectionState createState() => _My_Music_collectionState();
}

late MusicBloc information;

class _My_Music_collectionState extends State<My_Music_collection> {
  @override
  void dispose() {
    information.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Align(
              alignment: Alignment.bottomLeft,
              child: Padding(
                  padding: EdgeInsets.only(left: 10),
                  child: Text(
                    "Page 2",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ))),
          backgroundColor: Colors.black87,
        ),
        backgroundColor: Color.fromRGBO(34, 34, 34, 34),
        body: StreamBuilder(
            stream: information.outputStateController,
            builder: (context, snapshot) {
              return Column(
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  Expanded(
                    child: StreamBuilder(
                        stream: information.outputAudioStateController,
                        builder: (context, snapshot) {
                          return ListView.builder(
                              itemCount:
                                  information.audio_on_screen.artist.length,
                              shrinkWrap: true,
                              itemBuilder: (context, index) {
                                return Dismissible(
                                    background: Container(
                                        color: Colors.red,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.delete,
                                              color: Colors.white,
                                              size: 44,
                                            ),
                                            Text(
                                              "delete",
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        )),
                                    key: new UniqueKey(),
                                    onDismissed: (direction) {
                                      information.onDismissible(index);
                                    },
                                    child: Padding(
                                      padding: EdgeInsets.only(
                                          right: 10, left: 10, bottom: 10),
                                      child: customListTile(
                                          onTap: () {
                                            information.audioTaped(index);
                                          },
                                          title: information
                                              .audio_on_screen.artist[index],
                                          single: information
                                              .audio_on_screen.trackName[index],
                                          cover: information.audio_on_screen
                                              .trackImage[index]),
                                    ));
                              });
                        }),
                  ),
                  StreamBuilder(
                      stream: information.outputAudioStateController,
                      builder: (context, snapshot) {
                        if (information.playNow.audioPlayer.state ==
                            PlayerState.completed) {
                          if (information.playNow.tapIndex + 1 !=
                              information.audio_on_screen.musicUrl.length) {
                            print('Hi Spoty');
                            information.inputAudioEventSink
                                .add(AudioEvent.event_skip_next);
                          }
                        }

                        if (information.playNow.onTap) {
                          return Container(
                              decoration: BoxDecoration(
                                  color: Color.fromRGBO(18, 18, 18, 18),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Color.fromRGBO(18, 18, 18, 18),
                                      blurRadius: 8.0,
                                    )
                                  ]),
                              child: Column(
                                children: [
                                  Slider.adaptive(
                                      min: 0,
                                      max: information
                                          .playNow.duration.inSeconds
                                          .toDouble(),
                                      value: information
                                          .playNow.position.inSeconds
                                          .toDouble(),
                                      onChanged: (value) {}),
                                  customListTileOn(
                                      information: information,
                                      onTap: () {
                                        print(
                                            'position: ${information.playNow.position}');
                                        showModalBottomSheet(
                                            context: context,
                                            backgroundColor:
                                                Color.fromRGBO(34, 34, 34, 34),
                                            isScrollControlled: true,
                                            builder: (context) {
                                              return StreamBuilder(
                                                  stream: information
                                                      .outputAudioStateController,
                                                  builder: (context, snapshot) {
                                                    return FractionallySizedBox(
                                                        heightFactor: 0.8,
                                                        child: columnBottomShet(
                                                          information:
                                                              information,
                                                        ));
                                                  });
                                            });
                                      },
                                      title: information.audio_on_screen
                                          .artist[information.playNow.tapIndex],
                                      single:
                                          information.audio_on_screen.trackName[
                                              information.playNow.tapIndex],
                                      cover: information
                                              .audio_on_screen.trackImage[
                                          information.playNow.tapIndex])
                                ],
                              ));
                        } else {
                          return Text('');
                        }
                      })
                ],
              );
            }));
  }
}
