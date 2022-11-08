import 'package:equatable/equatable.dart';

class AudioConverter extends Equatable {
  AudioConverter({
    required this.artist,
    required this.trackName,
    required this.trackImage,
    required this.musicUrl,
  });

  List<String> artist;
  List<String> trackName;
  List<String> trackImage;
  List<String> musicUrl;

  factory AudioConverter.fromJson(Map<String, dynamic> json) => AudioConverter(
        artist: List<String>.from(json["artist"].map((x) => x)),
        trackName: List<String>.from(json["trackName"].map((x) => x)),
        trackImage: List<String>.from(json["trackImage"].map((x) => x)),
        musicUrl: List<String>.from(json["musicUrl"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "artist": List<dynamic>.from(artist.map((x) => x)),
        "trackName": List<dynamic>.from(trackName.map((x) => x)),
        "trackImage": List<dynamic>.from(trackImage.map((x) => x)),
        "musicUrl": List<dynamic>.from(musicUrl.map((x) => x)),
      };

  @override
  // TODO: implement props
  List<Object?> get props =>
      [this.artist, this.trackName, this.trackImage, this.musicUrl];
}

class TrackNameConverter extends Equatable {
  List<String> trackName;

  TrackNameConverter({
    required this.trackName,
  });
  factory TrackNameConverter.fromJson(Map<String, dynamic> json) =>
      TrackNameConverter(
        trackName: List<String>.from(json["trackName"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "trackName": List<dynamic>.from(trackName.map((x) => x)),
      };
  @override
  List<Object?> get props => [this.trackName];
}
