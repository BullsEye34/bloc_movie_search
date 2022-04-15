import 'package:equatable/equatable.dart';

class Result extends Equatable {
  late String overview;
  late DateTime? releaseDate;
  late String name;
  late double voteAverage;
  late String posterPath;
  late int id;
  late String mediaType;

  Result({
    required this.overview,
    required this.releaseDate,
    required this.name,
    required this.voteAverage,
    required this.posterPath,
    required this.id,
    required this.mediaType,
  });

  factory Result.fromJson(Map<String, dynamic> json) => Result(
        voteAverage: json["vote_average"].toDouble(),
        overview: json["overview"],
        releaseDate: json["release_date"] == null
            ? null
            : DateTime.parse(json["release_date"]),
        name: json["name"] == null ? json["title"] : json["name"],
        posterPath: json["poster_path"],
        id: json["id"],
        mediaType: json["media_type"],
      );

  Map<String, dynamic> toJson() => {
        "vote_average": voteAverage,
        "overview": overview,
        "release_date":
            "${releaseDate!.year.toString().padLeft(4, '0')}-${releaseDate!.month.toString().padLeft(2, '0')}-${releaseDate!.day.toString().padLeft(2, '0')}",
        "name": name,
        "id": id,
        "poster_path": posterPath,
        "media_type": mediaType,
      };
  @override
  // TODO: implement props
  List<Object?> get props =>
      [overview, releaseDate, name, voteAverage, posterPath, id, mediaType];
}
