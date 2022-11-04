import 'package:flutter/material.dart';
import 'package:flutter_firebase_player/firebase/info.dart';

class Music_collection extends StatefulWidget {
  Music_collection(AudioConverter my_audio_information) {
    information = my_audio_information;
  }

  @override
  _Music_collectionState createState() => _Music_collectionState();
}

late AudioConverter information;

class _Music_collectionState extends State<Music_collection> {
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.only(top: 50),
        child: Column(children: [
          Expanded(
            flex: 1,
            child: Padding(
              padding: EdgeInsets.only(right: 20, left: 20),
              child: TextField(
                  style: TextStyle(color: Colors.white),
                  onChanged: (value) {},
                  decoration: const InputDecoration(
                    fillColor: Color.fromRGBO(18, 18, 18, 18),
                    filled: true,
                    labelStyle: TextStyle(
                      color: Colors.amber,
                      fontWeight: FontWeight.bold,
                    ),
                    labelText: "Search",
                    suffixIcon: Icon(
                      Icons.search,
                      color: Colors.pink,
                    ),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(25.0)),
                        borderSide: BorderSide(
                          color: Colors.greenAccent,
                          width: 3,
                        )),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(25.0)),
                    ),
                  )),
            ),
          ),
          Expanded(
            flex: 10,
            child: ListView.builder(
                itemCount: 1,
                itemBuilder: (BuildContext context, int index) {
                  return Padding(
                      padding: EdgeInsets.all(5),
                      child: ListTile(
                          tileColor: Color.fromRGBO(18, 18, 18, 18),
                          textColor: Colors.white,
                          iconColor: Colors.white,
                          trailing:
                              LayoutBuilder(builder: (context, constraints) {
                            return Icon(
                              Icons.pause,
                              color: Color.fromARGB(255, 209, 51, 237),
                            );
                          }),
                          leading: ConstrainedBox(
                            constraints: BoxConstraints(
                                maxHeight: 44,
                                minHeight: 44,
                                maxWidth: 64,
                                minWidth: 64),
                            child: Image.network(
                                "https://flutter.github.io/assets-for-api-docs/assets/widgets/owl.jpg"),
                          ),
                          title: Text(
                            "artist",
                            textAlign: TextAlign.left,
                          ),
                          subtitle: Text(
                            information.trackName[index],
                            textAlign: TextAlign.start,
                          ),
                          onTap: () async {}));
                }),
          ),
          ElevatedButton(
            onPressed: () {},
            child: Text("Add Music"),
          )
        ]));
  }
}
