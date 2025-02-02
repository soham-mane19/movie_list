class FavoriteMovieModel {
  final String title;
  final String posterPath;
  final double voteAverage;
  final String releaseDate;
  final String docId; // Document ID from Firebase for easy deletion

  FavoriteMovieModel({
    required this.title,
    required this.posterPath,
    required this.voteAverage,
    required this.releaseDate,
    required this.docId,
  });

  factory FavoriteMovieModel.fromFirestore(Map<String, dynamic> data, String docId) {
    return FavoriteMovieModel(
      title: data['title'],
      posterPath: data['posterPath'],
      voteAverage: (data['voteAverage'] as num).toDouble(),
      releaseDate: data['releaseDate'],
      docId: docId,
    );
  }
}
