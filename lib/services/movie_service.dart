
import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mounarchtech_task/models/MovieModel.dart';

class MovieService {


static Future<List<MovieModel>> getMovies()async{
  
  String baseUrl = "https://api.themoviedb.org/3/movie/popular";
  String apiKey = "818e927ce9d199b8efd7212ce8c93152";

     Uri url = Uri.parse("$baseUrl?api_key=$apiKey");
   
        http.Response responce = await http.get(url);

    try{   
    if(responce.statusCode ==200){

 var data =   jsonDecode(responce.body);


 List<MovieModel> movielist = MovieModel.fromJsonList(data['results']);

 return movielist;

    }else{
      return [];
    }
    } catch(e){
       print("error:$e");
       
       return [];


    }
          



}




}