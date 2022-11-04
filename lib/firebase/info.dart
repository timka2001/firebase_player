class AudioConverter {
  AudioConverter({
    required this.artsit,
    required this.trackName,
    required this.trackImage,
    required this.musicUrl,
  });

  List<String> artsit;
  List<String> trackName;
  List<String> trackImage;
  List<String> musicUrl;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AudioConverter &&
          runtimeType == other.runtimeType &&
          artsit == other.artsit &&
          trackName == other.trackName &&
          trackImage == other.trackImage &&
          musicUrl == other.musicUrl;
  @override
  int get hashCode =>
      artsit.hashCode ^
      trackName.hashCode ^
      trackImage.hashCode ^
      musicUrl.hashCode;

  factory AudioConverter.fromJson(Map<String, dynamic> json) => AudioConverter(
        artsit: List<String>.from(json["artist"].map((x) => x)),
        trackName: List<String>.from(json["trackName"].map((x) => x)),
        trackImage: List<String>.from(json["trackImage"].map((x) => x)),
        musicUrl: List<String>.from(json["musicUrl"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "artist": List<dynamic>.from(artsit.map((x) => x)),
        "trackName": List<dynamic>.from(trackName.map((x) => x)),
        "trackImage": List<dynamic>.from(trackImage.map((x) => x)),
        "musicUrl": List<dynamic>.from(musicUrl.map((x) => x)),
      };
}

class TrackNameConverter {
  List<String> trackName;
  int name;
  TrackNameConverter({
    required this.trackName,
    required this.name,
  });
  factory TrackNameConverter.fromJson(Map<String, dynamic> json) =>
      TrackNameConverter(
        trackName: List<String>.from(json["trackName"].map((x) => x)),
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "trackName": List<dynamic>.from(trackName.map((x) => x)),
        "name": name,
      };
}
