import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mounarchtech_task/models/MovieModel.dart';
import 'package:mounarchtech_task/models/fav_movie_model.dart';
import 'package:mounarchtech_task/screens/fav_screen.dart';
import 'package:mounarchtech_task/services/firebase_repo.dart';
import 'package:mounarchtech_task/services/movie_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
   late Future<List<MovieModel>> movieList;
  Set<String> favoriteMovieIds = {};
  Map<String, String> favoriteDocIds = {};

  @override
  void initState() {
    super.initState();
    movieList = MovieService.getMovies();
    _fetchFavorites();
  }

  void _toggleFavorite(MovieModel movie) async {
    String movieId = movie.id.toString();
    
    if (favoriteMovieIds.contains(movieId)) {
      String? docId = favoriteDocIds[movieId];
      if (docId != null) {
        try {
          await FirebaseRepo.deleteData(docId);
          setState(() {
            favoriteMovieIds.remove(movieId);
            favoriteDocIds.remove(movieId);
          });
        } catch (e) {
          print("Error removing favorite: $e");
        }
      }
    } else {
      Map<String, dynamic> data = {
        "id": movie.id,
        "title": movie.title,
        "posterPath": movie.posterPath,
        "voteAverage": movie.voteAverage,
        "releaseDate": movie.releaseDate,
      };
      
      try {
        String? newDocId = await FirebaseRepo.addData(data);
        if (newDocId != null) {
          setState(() {
            favoriteMovieIds.add(movieId);
            favoriteDocIds[movieId] = newDocId;
          });
        }
      } catch (e) {
        print("Error adding favorite: $e");
      }
    }
  }

  void _fetchFavorites() async {
    try {
      List<FavoriteMovieModel> favorites = await FirebaseRepo.getFavorites();
      Set<String> ids = {};
      Map<String, String> docIds = {};
      
      for (var fav in favorites) {
       
        String movieId = fav.docId.toString();
        ids.add(movieId);
        docIds[movieId] = fav.docId;
      }
      
      setState(() {
        favoriteMovieIds = ids;
        favoriteDocIds = docIds;
      });
    } catch (e) {
      print("Error fetching favorites: $e");
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 60, left: 20, right: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 30),
                  Text("Explore the",
                      style: GoogleFonts.poppins(
                          fontSize: 38,
                          fontWeight: FontWeight.w400,
                          color: const Color.fromRGBO(46, 50, 62, 1))),
                  const SizedBox(height: 5),
                  RichText(
                    text: TextSpan(children: [
                      TextSpan(
                          text: 'Beautiful',
                          style: GoogleFonts.poppins(
                              fontSize: 38,
                              fontWeight: FontWeight.w400,
                              color: const Color.fromRGBO(27, 30, 40, 1))),
                      TextSpan(
                          text: ' Movies! ',
                          style: GoogleFonts.poppins(
                              fontSize: 38,
                              fontWeight: FontWeight.w400,
                              color: const Color.fromRGBO(255, 112, 41, 1))),
                    ]),
                  ),
                  const SizedBox(height: 25),
                  Row(
                    children: [
                      Text("Best Movies",
                          style: GoogleFonts.poppins(
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                              color: const Color.fromRGBO(27, 30, 40, 1))),
                      const Spacer(),
                    
                    ],
                  ),
                  const SizedBox(height: 10),

             
                  FutureBuilder<List<MovieModel>>(
                    future: movieList,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(child: Text("Error: ${snapshot.error}"));
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return const Center(child: Text("No movies found"));
                      }

                      List<MovieModel> movies = snapshot.data!;

                      return SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: movies.map((movie) {
                            return Padding(
                              padding: const EdgeInsets.only(right: 20),
                              child: GestureDetector(
                                onTap: () {},
                                child: Container(
                                  padding: const EdgeInsets.only(top: 10,bottom: 35,left: 10,right: 10),
                                  height: 375,
                                  width: 268,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(24),
                                      color: const Color.fromRGBO(255, 255, 255, 1),
                                      boxShadow: const [
                                        BoxShadow(
                                            color:
                                                Color.fromRGBO(180, 188, 201, 0.12),
                                            blurRadius: 16,
                                            offset: Offset(0, 6))
                                      ]),
                                  child: Stack(children: [
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
                                                    color: const Color.fromRGBO(
                                                        27, 30, 40, 1)),
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
                                                    color: const Color.fromRGBO(
                                                        27, 30, 40, 1)))
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
                                                    color: const Color.fromRGBO(
                                                        125, 132, 141, 1)))
                                          ],
                                        ),
                                        const Spacer(),
                                       GestureDetector(
  onTap: () {
    Map<String, dynamic> data = {
      "title": movie.title,
      "posterPath": movie.posterPath,
      "voteAverage": movie.voteAverage,
      "releaseDate": movie.releaseDate,
    };

       _toggleFavorite(movie);

   



  },
                                          child: Container(
                                            height: 50,
                                            width: 120,
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(
                                              color: Colors.blue,
                                              borderRadius: BorderRadius.circular(15)
                                            ),
                                            child: Text(
      favoriteMovieIds.contains(movie.id.toString()) ? "Remove" : "Add to Favourite",
      style: GoogleFonts.poppins(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: const Color.fromRGBO(27, 30, 40, 1),
      ),  
      textAlign: TextAlign.center,
                                            )
                                          )
                                        ),


                                      ],
                                    ),
                                  ]),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(
  height: 45,
),

            GestureDetector(
  onTap: () {
   Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      return FavouriteScreen(onUpdateFavorites : _fetchFavorites);
   },));
                                                                                                                                                  



  },
                                          child: Container(
                                            height: 50,
                                            width: 120,
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(
                                              color: Colors.blue,
                                              borderRadius: BorderRadius.circular(15)
                                            ),
                                            child: Text(
           "See Favourite",
      style: GoogleFonts.poppins(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: const Color.fromRGBO(27, 30, 40, 1),
      ),  
      textAlign: TextAlign.center,
                                            )
                                          )
                                        ),

          ],
        ),
      ]),
    );
  }
}
