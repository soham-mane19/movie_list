import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mounarchtech_task/models/MovieModel.dart';
import 'package:mounarchtech_task/models/fav_movie_model.dart';
import 'package:mounarchtech_task/services/firebase_repo.dart';

class FavouriteScreen extends StatefulWidget {
  final VoidCallback onUpdateFavorites; 

  const FavouriteScreen({super.key, required this.onUpdateFavorites});

  @override
  State<FavouriteScreen> createState() => _FavouriteScreenState();
}

class _FavouriteScreenState extends State<FavouriteScreen> {
  late Future<List<FavoriteMovieModel>> favoriteMovies;

  @override
  void initState() {
    super.initState();
    favoriteMovies = _fetchFavoriteMovies();
  }

  Future<List<FavoriteMovieModel>> _fetchFavoriteMovies() async {
    try {
      
      return await FirebaseRepo.getFavorites();
    } catch (e) {
      print("Error fetching favorite movies: $e");
      return [];
    }
  }

  void _removeFavorite(FavoriteMovieModel movie) async {
  try {
    await FirebaseRepo.deleteData(movie.docId.toString());

    setState(() {
      favoriteMovies = _fetchFavoriteMovies();
    });

    widget.onUpdateFavorites(); // Notify HomeScreen
  } catch (e) {
    print("Error removing favorite: $e");
  }
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("My Favorites")),
      body: FutureBuilder<List<FavoriteMovieModel>>(
        future: favoriteMovies,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No favorites found"));
          }

          List<FavoriteMovieModel> movies = snapshot.data!;

          return SingleChildScrollView(
            child: Column(
              children: movies.map((movie) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: GestureDetector(
                    onTap: () {},
                    child: Container(
                      padding: const EdgeInsets.only(top: 10, bottom: 35, left: 10, right: 10),
                      height: 375,
                      width: 268,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(24),
                        color: const Color.fromRGBO(255, 255, 255, 1),
                        boxShadow: const [
                          BoxShadow(
                            color: Color.fromRGBO(180, 188, 201, 0.12),
                            blurRadius: 16,
                            offset: Offset(0, 6)
                          ),
                        ],
                      ),
                      child: Stack(
                        children: [
                          Column(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: Image.network(
                                  "https://image.tmdb.org/t/p/w500${movie.posterPath}",
                                  height: 200,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      movie.title,
                                      style: GoogleFonts.poppins(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                          color: const Color.fromRGBO(27, 30, 40, 1)),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  const SizedBox(width: 5),
                                  const Icon(
                                    Icons.star,
                                    color: Color.fromRGBO(255, 211, 54, 1),
                                  ),
                                  Text(movie.voteAverage.toString(),
                                      style: GoogleFonts.poppins(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w400,
                                          color: const Color.fromRGBO(27, 30, 40, 1))),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Row(
                                children: [
                                  const Icon(Icons.date_range),
                                  const SizedBox(width: 3),
                                  Text(movie.releaseDate,
                                      style: GoogleFonts.poppins(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w400,
                                          color: const Color.fromRGBO(125, 132, 141, 1))),
                                ],
                              ),
                              const Spacer(),
                              GestureDetector(
                                onTap: () => _removeFavorite(movie),
                                child: Container(
                                  height: 50,
                                  width: 120,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: Colors.red,
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: Text(
                                    "Remove",
                                    style: GoogleFonts.poppins(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      color: const Color.fromRGBO(27, 30, 40, 1),
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          );
        },
      ),
    );
  }
}
