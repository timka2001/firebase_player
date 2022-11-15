import 'package:audioplayers/audioplayers.dart';

import 'package:flutter/material.dart';

import '../../ui/custom_list/custom_list.dart';
import '../../ui/custom_list/custom_list_on.dart';
import '../../ui/show_modal_bottom/show_modal_bottom.dart';
import '../music_bloc/music_bloc.dart';

class Music_collection extends StatefulWidget {
  // ignore: use_key_in_widget_constructors
  Music_collection(MusicBloc musicBloc) {
    print("object");
    information = musicBloc;
  }

  @override
  _Music_collectionState createState() => _Music_collectionState();
}

late MusicBloc information;

class _Music_collectionState extends State<Music_collection> {
  @override
  void dispose() {
    information.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: information.outputStateController,
        builder: (context, snapshot) {
          return Column(
            children: [
              Expanded(
                child: StreamBuilder(
                    stream: information.outputAudioStateController,
                    builder: (context, snapshot) {
                      return ListView.builder(
                          itemCount:
                              information.audio_on_screen.artist.length + 1,
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            if (index == 0) {
                              return Padding(
                                  padding: EdgeInsets.only(
                                      bottom: 40, left: 10, right: 10),
                                  child: TextField(
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                      onChanged: (value) {
                                        information.runFilter(value);
                                      },
                                      decoration: const InputDecoration(
                                        fillColor:
                                            Color.fromRGBO(18, 18, 18, 18),
                                        filled: true,
                                        labelStyle: TextStyle(
                                          color: Colors.amber,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        labelText: "Search",
                                        suffixIcon: Icon(Icons.search,
                                            color: Colors.pink),
                                        focusedBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(25.0)),
                                            borderSide: BorderSide(
                                              color: Colors.greenAccent,
                                              width: 3,
                                            )),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(25.0)),
                                        ),
                                      )));
                            } else {
                              return Padding(
                                padding: EdgeInsets.only(
                                    right: 10, left: 10, bottom: 10),
                                child: customListTile(
                                    onTap: () {
                                      information.audioTaped(index - 1);
                                    },
                                    title: information
                                        .audio_on_screen.artist[index - 1],
                                    single: information
                                        .audio_on_screen.trackName[index - 1],
                                    cover: information
                                        .audio_on_screen.trackImage[index - 1]),
                              );
                            }
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
                    if (information.audio_on_screen.artist.length == 0) {
                      return ElevatedButton(
                          onPressed: () {
                            information.inputEventSink
                                .add(MusicEvent.event_add_music);
                          },
                          child: Center(
                            child: Text("Add Music"),
                          ));
                    } else {
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
                                    max: information.playNow.duration.inSeconds
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
                                    cover:
                                        information.audio_on_screen.trackImage[
                                            information.playNow.tapIndex])
                              ],
                            ));
                      } else {
                        return Text('');
                      }
                    }
                  })
            ],
          );
        });
  }
}

class SecondRoute extends StatefulWidget {
  SecondRoute();
  @override
  _SecondRouteState createState() => _SecondRouteState();
}

class _SecondRouteState extends State<SecondRoute> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Click Me Page"),
        backgroundColor: Colors.green,
      ),
      body: Center(
        child: RaisedButton(
          onPressed: () {},
          child: Text('Home!'),
        ),
      ),
    );
  }
}
