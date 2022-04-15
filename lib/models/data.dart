import 'dart:convert';

import 'package:tmdb/models/result.dart';

DataModel DataModelFromJson(String str) => DataModel.fromJson(json.decode(str));

String DataModelToJson(DataModel data) => json.encode(data.toJson());

class DataModel {
  DataModel({
    required this.results,
  });

  List<Result> results;

  DataModel copyWith({
    List<Result>? results,
  }) =>
      DataModel(
        results: this.results,
      );

  factory DataModel.fromJson(Map<String, dynamic> json) => DataModel(
        results:
            List<Result>.from(json["results"].map((x) => Result.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "results": List<dynamic>.from(results.map((x) => x.toJson())),
      };
}
