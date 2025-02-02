import 'dart:convert';

class MovieModel {
  final int id;
  final String title;
  final String overview;
  final String posterPath;
  final String backdropPath;
  final double voteAverage;
  final String releaseDate;
  final double popularity;

  MovieModel({
    required this.id,
    required this.title,
    required this.overview,
    required this.posterPath,
    required this.backdropPath,
    required this.voteAverage,
    required this.releaseDate,
    required this.popularity,
  });

  
  factory MovieModel.fromJson(Map<String, dynamic> json) {
    return MovieModel(
      id: json['id'] ?? 0,
      title: json['title'] ?? 'No Title',
      overview: json['overview'] ?? 'No Description',
      posterPath: json['poster_path'] ?? '',
      backdropPath: json['backdrop_path'] ?? '',
      voteAverage: (json['vote_average'] ?? 0).toDouble(),
      releaseDate: json['release_date'] ?? 'Unknown',
      popularity: (json['popularity'] ?? 0).toDouble(),
    );
  }


  static List<MovieModel> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => MovieModel.fromJson(json)).toList();
  }
}
