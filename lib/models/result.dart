import 'package:equatable/equatable.dart';

class Result extends Equatable {
  late String overview;
  late DateTime releaseDate;
  late String title;
  late String voteAverage;
  late String posterPath;

  Result(
      {required this.overview,
      required this.releaseDate,
      required this.title,
      required this.voteAverage,
      required this.posterPath});

  factory Result.fromJson(Map<String, dynamic> json) => Result(
        voteAverage: json["vote_average"].toDouble(),
        overview: json["overview"],
        releaseDate: DateTime.parse(json["release_date"]),
        title: json["title"],
        posterPath: json["poster_path"],
      );

  Map<String, dynamic> toJson() => {
        "vote_average": voteAverage,
        "overview": overview,
        "release_date":
            "${releaseDate.year.toString().padLeft(4, '0')}-${releaseDate.month.toString().padLeft(2, '0')}-${releaseDate.day.toString().padLeft(2, '0')}",
        "title": title,
        "poster_path": posterPath,
      };
  @override
  // TODO: implement props
  List<Object?> get props => [
        overview,
        releaseDate,
        title,
        voteAverage,
        posterPath,
      ];
}
