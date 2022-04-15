import 'package:equatable/equatable.dart';

class Result extends Equatable {
  late String overview;
  late String name;
  late double voteAverage;
  late String posterPath;
  late int id;
  late String mediaType;

  Result({
    required this.overview,
    required this.name,
    required this.voteAverage,
    required this.posterPath,
    required this.id,
    required this.mediaType,
  });

  factory Result.fromJson(Map<String, dynamic> json) => Result(
        voteAverage: json["vote_average"].toDouble(),
        overview: json["overview"],
        name: json["name"] == null ? json["title"] : json["name"],
        posterPath: json["poster_path"],
        id: json["id"],
        mediaType: (json["media_type"] == null) ? "movie" : json["media_type"],
      );

  Map<String, dynamic> toJson() => {
        "vote_average": voteAverage,
        "overview": overview,
        "name": name,
        "id": id,
        "poster_path": posterPath,
        "media_type": mediaType,
      };
  @override
  // TODO: implement props
  List<Object?> get props =>
      [overview, name, voteAverage, posterPath, id, mediaType];
}
