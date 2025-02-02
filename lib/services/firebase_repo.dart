import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:mounarchtech_task/models/fav_movie_model.dart';

class FirebaseRepo {
  static final CollectionReference favMoviesRef = 
      FirebaseFirestore.instance.collection('favMovies');

  static Future<String?> addData(Map<String, dynamic> data) async {
    try {
      DocumentReference docRef = await favMoviesRef.add(data);
      return docRef.id; 
    } catch (e) {
      print("Error adding data: $e");
      return null;
    }
  }

  static Future<void> deleteData(String docId) async {
    try {
      await favMoviesRef.doc(docId).delete();
    } catch (e) {
      print("Error deleting data: $e");
    }
  }

  static Future<List<FavoriteMovieModel>> getFavorites() async {
    try {
      QuerySnapshot querySnapshot = await favMoviesRef.get();
      return querySnapshot.docs
          .map((doc) =>
           FavoriteMovieModel.fromFirestore(doc.data() as Map<String, dynamic>, doc.id))
          .toList();
    } catch (e) {
      print("Error fetching favorites: $e");
      return [];
    }
  }
}
