import 'package:audioplayers/audioplayers.dart';

import 'package:flutter/material.dart';

import '../../servic/my_servic.dart';

class My_Music_collection extends StatefulWidget {
  // ignore: use_key_in_widget_constructors
  My_Music_collection(MyMusicBloc musicBloc) {
    print("object");
    information = musicBloc;
  }

  @override
  _My_Music_collectionState createState() => _My_Music_collectionState();
}

late MyMusicBloc information;

class _My_Music_collectionState extends State<My_Music_collection> {
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
                                                      child: Column(
                                                        children: [
                                                          Padding(
                                                            padding:
                                                                EdgeInsets.only(
                                                                    top: 10),
                                                            child: ClipRRect(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          20),
                                                              child:
                                                                  Image.network(
                                                                information
                                                                        .audio_on_screen
                                                                        .trackImage[
                                                                    information
                                                                        .playNow
                                                                        .tapIndex],
                                                                width: 350,
                                                                height: 350,
                                                                fit: BoxFit
                                                                    .cover,
                                                              ),
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                            height: 32,
                                                          ),
                                                          Padding(
                                                            padding:
                                                                EdgeInsets.only(
                                                                    left: 40),
                                                            child: ListTile(
                                                              title: Center(
                                                                child: Text(
                                                                  information
                                                                          .audio_on_screen
                                                                          .artist[
                                                                      information
                                                                          .playNow
                                                                          .tapIndex],
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          24,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      color: Colors
                                                                          .white),
                                                                ),
                                                              ),
                                                              subtitle: Center(
                                                                child: Text(
                                                                  information
                                                                          .audio_on_screen
                                                                          .trackName[
                                                                      information
                                                                          .playNow
                                                                          .tapIndex],
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          24,
                                                                      color: Colors
                                                                          .white),
                                                                ),
                                                              ),
                                                              trailing:
                                                                  SizedBox(
                                                                height: 20,
                                                              ),
                                                            ),
                                                          ),
                                                          StatefulBuilder(
                                                              builder: (context,
                                                                  state) {
                                                            return Slider(
                                                                min: 0,
                                                                max: information
                                                                    .playNow
                                                                    .duration
                                                                    .inSeconds
                                                                    .toDouble(),
                                                                value: information
                                                                    .playNow
                                                                    .position
                                                                    .inSeconds
                                                                    .toDouble(),
                                                                onChanged:
                                                                    (value) {
                                                                  state(() {
                                                                    final position =
                                                                        Duration(
                                                                            seconds:
                                                                                value.toInt());

                                                                    information
                                                                        .playNow
                                                                        .audioPlayer
                                                                        .seek(
                                                                            position);
                                                                  });
                                                                });
                                                          }),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .symmetric(
                                                                    horizontal:
                                                                        16),
                                                            child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              children: [
                                                                Text(
                                                                  formatTime(
                                                                      information
                                                                          .playNow
                                                                          .position),
                                                                  style:
                                                                      TextStyle(
                                                                    color: Colors
                                                                        .white,
                                                                  ),
                                                                ),
                                                                Text(
                                                                  formatTime(information
                                                                          .playNow
                                                                          .duration -
                                                                      information
                                                                          .playNow
                                                                          .position),
                                                                  style:
                                                                      TextStyle(
                                                                    color: Colors
                                                                        .white,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: [
                                                              Padding(
                                                                padding: EdgeInsets
                                                                    .only(
                                                                        top: 40,
                                                                        right:
                                                                            15),
                                                                child:
                                                                    CircleAvatar(
                                                                  radius: 35,
                                                                  child: IconButton(
                                                                      icon: Icon(
                                                                        Icons
                                                                            .skip_previous_rounded,
                                                                      ),
                                                                      iconSize: 40,
                                                                      onPressed: () async {
                                                                        information
                                                                            .inputAudioEventSink
                                                                            .add(AudioEvent.event_skip_back);
                                                                      }),
                                                                ),
                                                              ),
                                                              Padding(
                                                                padding:
                                                                    EdgeInsets
                                                                        .only(
                                                                  top: 40,
                                                                ),
                                                                child: StatefulBuilder(
                                                                    builder:
                                                                        (context,
                                                                            state) {
                                                                  return CircleAvatar(
                                                                    radius: 35,
                                                                    child:
                                                                        IconButton(
                                                                      icon:
                                                                          Icon(
                                                                        information.playNow.isPlaying
                                                                            ? Icons.pause
                                                                            : Icons.play_arrow,
                                                                      ),
                                                                      iconSize:
                                                                          40,
                                                                      onPressed:
                                                                          () async {
                                                                        information.playNow.isPlaying
                                                                            ? information.inputAudioEventSink.add(AudioEvent.event_stop)
                                                                            : information.inputAudioEventSink.add(AudioEvent.event_play);
                                                                      },
                                                                    ),
                                                                  );
                                                                }),
                                                              ),
                                                              Padding(
                                                                padding: EdgeInsets
                                                                    .only(
                                                                        top: 40,
                                                                        left:
                                                                            15),
                                                                child: StatefulBuilder(
                                                                    builder:
                                                                        (context,
                                                                            state) {
                                                                  return CircleAvatar(
                                                                    radius: 35,
                                                                    child: IconButton(
                                                                        icon: Icon(
                                                                          Icons
                                                                              .skip_next_rounded,
                                                                        ),
                                                                        iconSize: 40,
                                                                        onPressed: () async {
                                                                          information
                                                                              .inputAudioEventSink
                                                                              .add(AudioEvent.event_skip_next);
                                                                        }),
                                                                  );
                                                                }),
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    );
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

  Widget customListTile(
      {required String title,
      required String single,
      required String cover,
      onTap}) {
    return ListTile(
        onTap: onTap,
        tileColor: Color.fromRGBO(18, 18, 18, 18),
        textColor: Colors.white,
        iconColor: Colors.white,
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

  Widget customListTileOn(
      {required String title,
      required String single,
      required String cover,
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
                    : information.inputAudioEventSink
                        .add(AudioEvent.event_play);
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
}


  

//child: Column(children: [
  
    //   Expanded(
    //       flex: 6,
    //       child: StreamBuilder(
    //           stream: information.outputAudioStateController,
    //           builder: (context, snapshot) {
    //             return ListView.builder(
    //                 itemCount: information.audio_on_screen.artist.length,
    //                 itemBuilder: (BuildContext context, int i) {
    //                   return Padding(
    //                       padding:
    //                           EdgeInsets.only(right: 10, left: 10, bottom: 10),
    //                       child: ListTile(
    
    //                           onTap: () async {
    //                             information.audioTaped(i);

    //                             showModalBottomSheet(
    //                                 context: context,
    //                                 backgroundColor:
    //                                     Color.fromRGBO(34, 34, 34, 34),
    //                                 isScrollControlled: true,
    //                                 builder: (context) {
    //                                   return StreamBuilder(
    //                                       stream: information
    //                                           .outputAudioStateController,
    //                                       builder: (context, snapshot) {
    //                                         return FractionallySizedBox(
    //                                             heightFactor: 0.8,
    //                                             child: Column(children: [
    //                                               Padding(
    //                                                 padding: EdgeInsets.only(
    //                                                     top: 10),
    //                                                 child: ClipRRect(
    //                                                   borderRadius:
    //                                                       BorderRadius.circular(
    //                                                           20),
    //                                                   child: Image.network(
    //                                                     information
    //                                                         .audio_on_screen
    //                                                         .trackImage[i],
    //                                                     width: 350,
    //                                                     height: 350,
    //                                                     fit: BoxFit.cover,
    //                                                   ),
    //                                                 ),
    //                                               ),
    //                                               const SizedBox(
    //                                                 height: 32,
    //                                               ),
    //                                               Padding(
    //                                                   padding: EdgeInsets.only(
    //                                                       left: 40),
    //                                                   child: ListTile(
    //                                                       title: Center(
    //                                                         child: Text(
    //                                                           information
    //                                                               .audio_on_screen
    //                                                               .artist[i],
    //                                                           style: TextStyle(
    //                                                               fontSize: 24,
    //                                                               fontWeight:
    //                                                                   FontWeight
    //                                                                       .bold,
    //                                                               color: Colors
    //                                                                   .white),
    //                                                         ),
    //                                                       ),
    //                                                       subtitle: Center(
    //                                                         child: Text(
    //                                                           information
    //                                                               .audio_on_screen
    //                                                               .trackName[i],
    //                                                           style: TextStyle(
    //                                                               fontSize: 24,
    //                                                               color: Colors
    //                                                                   .white),
    //                                                         ),
    //                                                       ),
    //                                                       trailing: IconButton(
    //                                                         icon: Icon(
    //                                                           Icons.add,
    //                                                         ),
    //                                                         iconSize: 20,
    //                                                         onPressed: () {},
    //                                                       ))),
    //                                               StatefulBuilder(builder:
    //                                                   (context, state) {
    //                                                 return Slider(
    //                                                     min: 0,
    //                                                     max: information.playNow
    //                                                         .duration.inSeconds
    //                                                         .toDouble(),
    //                                                     value: information
    //                                                         .playNow
    //                                                         .position
    //                                                         .inSeconds
    //                                                         .toDouble(),
    //                                                     onChanged: (value) {
    //                                                       final position =
    //                                                           Duration(
    //                                                               seconds: value
    //                                                                   .toInt());
    //                                                       information.playNow
    //                                                           .audioPlayer
    //                                                           .seek(position);
    //                                                       information.playNow
    //                                                           .audioPlayer
    //                                                           .resume();
    //                                                     });
    //                                               }),
    //                                               Padding(
    //                                                 padding: const EdgeInsets
    //                                                         .symmetric(
    //                                                     horizontal: 16),
    //                                                 child: Row(
    //                                                   mainAxisAlignment:
    //                                                       MainAxisAlignment
    //                                                           .spaceBetween,
    //                                                   children: [
    //                                                     Text(
    //                                                         formatTime(
    //                                                             information
    //                                                                 .playNow
    //                                                                 .position),
    //                                                         style: TextStyle(
    //                                                           color:
    //                                                               Colors.white,
    //                                                           fontWeight:
    //                                                               FontWeight
    //                                                                   .bold,
    //                                                         )),
    //                                                     Text(
    //                                                         formatTime(information
    //                                                                 .playNow
    //                                                                 .duration -
    //                                                             information
    //                                                                 .playNow
    //                                                                 .position),
    //                                                         style: TextStyle(
    //                                                           color:
    //                                                               Colors.white,
    //                                                           fontWeight:
    //                                                               FontWeight
    //                                                                   .bold,
    //                                                         )),
    //                                                   ],
    //                                                 ),
    //                                               ),
    //                                               Padding(
    //                                                 padding: EdgeInsets.all(10),
    //                                                 child: Row(
    //                                                     mainAxisAlignment:
    //                                                         MainAxisAlignment
    //                                                             .center,
    //                                                     children: [
    //                                                       CircleAvatar(
    //                                                         radius: 35,
    //                                                         child: IconButton(
    //                                                           icon: Icon(
    //                                                             Icons
    //                                                                 .skip_previous_rounded,
    //                                                           ),
    //                                                           onPressed: () {},
    //                                                         ),
    //                                                       ),
    //                                                       Padding(
    //                                                         padding:
    //                                                             EdgeInsets.only(
    //                                                                 right: 10,
    //                                                                 left: 10),
    //                                                         child: CircleAvatar(
    //                                                           radius: 35,
    //                                                           child: IconButton(
    //                                                             icon: Icon(
    //                                                               information.playNow
    //                                                                           .isPlaying[
    //                                                                       i]
    //                                                                   ? Icons
    //                                                                       .pause
    //                                                                   : Icons
    //                                                                       .play_arrow,
    //                                                             ),
    //                                                             onPressed:
    //                                                                 () {},
    //                                                           ),
    //                                                         ),
    //                                                       ),
    //                                                       CircleAvatar(
    //                                                         radius: 35,
    //                                                         child: IconButton(
    //                                                           icon: Icon(
    //                                                             Icons
    //                                                                 .skip_next_rounded,
    //                                                           ),
    //                                                           onPressed: () {},
    //                                                         ),
    //                                                       ),
    //                                                     ]),
    //                                               )
    //                                             ]));
                                                
    //                                       });
    //                                 }
    //                                 );
                                    
    //                           }));
    //                 });
    //           })),
      
    //   ElevatedButton(
    //     onPressed: () {
    //       information.inputEventSink.add(MusicEvent.event_add_music);
    //     },
    //     child: Text("Add Music"),
    //   )
    // ])