import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:smart_chef/APIfunctions/APIutils.dart';

class Recipes {
  static const String apiRoute = 'recipes';

  static Future<http.Response> searchRecipes(Map<String, dynamic> queries) async {
    http.Response response;

    try {
      response = await http.get(Uri.https(API_PREFIX, apiRoute, queries),
          headers: baseHeader);
    } catch (e) {
      print(e.toString());
      throw Exception('Could not connect to server');
    }

    return response;
  }

  static Future<http.Response> getRecipeByID(int recipeID) async {
    http.Response response;

    try {
      response = await http.get(Uri.https(API_PREFIX, '$apiRoute/$recipeID'),
          headers: baseHeader);
    } catch (e) {
      print(e.toString());
      throw Exception('Could not connect to server');
    }

    return response;
  }

  static Future<http.Response> getFavoriteRecipes() async {
    http.Response response;

    try {
      response = await http.get(Uri.https(API_PREFIX, '/user/favorite-recipes'),
          headers: baseHeader);
    } catch (e) {
      print(e.toString());
      throw Exception('Could not connect to server');
    }

    return response;
  }

  static Future<http.Response> addRecipesToFavorite(Map<String, dynamic> recipe) async {
    http.Response response;

    try {
      response = await http.post(Uri.https(API_PREFIX, '/user/favorite-recipes'),
          body: json.encode(recipe),
          headers: baseHeader);
    } catch (e) {
      print(e.toString());
      throw Exception('Could not connect to server');
    }

    return response;
  }

  static Future<http.Response> getFavoriteRecipeByID(int ID) async {
    http.Response response;

    try {
      response = await http.get(Uri.https(API_PREFIX, '/user/favorite-recipes/$ID'),
          headers: baseHeader);
    } catch (e) {
      print(e.toString());
      throw Exception('Could not connect to server');
    }

    return response;
  }

  static Future<http.Response> removeFavoriteRecipe(int ID) async {
    http.Response response;

    try {
      response = await http.delete(Uri.https(API_PREFIX, '/user/favorite-recipes/$ID'),
          headers: baseHeader);
    } catch (e) {
      print(e.toString());
      throw Exception('Could not connect to server');
    }

    return response;
  }
}
