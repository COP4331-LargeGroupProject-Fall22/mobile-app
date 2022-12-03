import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:smart_chef/utils/APIutils.dart';

class FavRecipe {

  static const String apiRoute = 'user/favorite-recipes';

  static Future<http.Response> getFavoriteRecipes() async {
    http.Response response;

    try {
      response = await http.get(Uri.parse('$API_PREFIX$apiRoute'), headers: accessTokenHeader);
    } catch (e) {
      print(e.toString());
      throw Exception('Could not connect to server');
    }

    return response;
  }

  static Future<http.Response> addFavoriteRecipe(Map<String, dynamic> recipe) async {
    http.Response response;

    try {
      response = await http.post(Uri.parse('$API_PREFIX$apiRoute'),
          body: json.encode(recipe),
          headers: accessTokenHeader);
    } catch (e) {
      print(e.toString());
      throw Exception('Could not connect to server');
    }

    return response;
  }

  static Future<http.Response> getFavoriteRecipeByID(int ID) async {
    http.Response response;

    try {
      response = await http.get(Uri.parse('$API_PREFIX$apiRoute/$ID'), headers: accessTokenHeader);
    } catch (e) {
      print(e.toString());
      throw Exception('Could not connect to server');
    }

    return response;
  }

  static Future<http.Response> removeFavoriteRecipe(int ID) async {
    http.Response response;

    try {
      response = await http.delete(Uri.parse('$API_PREFIX$apiRoute/$ID'), headers: accessTokenHeader);
    } catch (e) {
      print(e.toString());
      throw Exception('Could not connect to server');
    }

    return response;
  }
}
