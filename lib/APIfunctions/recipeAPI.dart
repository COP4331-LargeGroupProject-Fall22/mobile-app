import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:smart_chef/APIfunctions/APIutils.dart';

class Recipes {
  static const String apiRoute = 'recipes';

  static Future<http.Response> searchRecipes(String searchQuery, int resultsPerPage, int page, String intolerance, String hasIngredients, String cuisines, String diets, String mealTypes) async {
    http.Response response;

    String totalUrl = '$API_PREFIX$apiRoute?recipeName=$searchQuery';
    if (resultsPerPage != 0) {
      totalUrl += '&resultsPerPage=$resultsPerPage';
    }
    if (page != 0) {
      totalUrl += '&page=$page';
    }
    if (intolerance.isNotEmpty) {
      totalUrl += '&intolerance=$intolerance';
    }
    if (hasIngredients.isNotEmpty) {
      totalUrl += '&hasIngredients=$hasIngredients';
    }
    if (cuisines.isNotEmpty) {
      totalUrl += '&cuisines=$cuisines';
    }
    if (diets.isNotEmpty) {
      totalUrl += '&diets=$diets';
    }
    if (mealTypes.isNotEmpty) {
      totalUrl += '&mealTypes=$mealTypes';
    }

    try {
      response = await http.get(Uri.parse(totalUrl),
          headers: baseHeader);
    } catch (e) {
      print(e.toString());
      throw Exception('Could not connect to server');
    }

    return response;
  }

  static Future<http.Response> getRecipeByID(int recipeID) async {
    http.Response response;

    String totalUrl = '$API_PREFIX$apiRoute/$recipeID';

    try {
      response = await http.get(Uri.parse(totalUrl),
          headers: baseHeader);
    } catch (e) {
      print(e.toString());
      throw Exception('Could not connect to server');
    }

    return response;
  }

  static Future<http.Response> getFavoriteRecipes() async {
    http.Response response;

    String totalUrl = '$API_PREFIX/user/favorite-recipes';

    try {
      response = await http.get(Uri.parse(totalUrl),
          headers: baseHeader);
    } catch (e) {
      print(e.toString());
      throw Exception('Could not connect to server');
    }

    return response;
  }

  static Future<http.Response> addRecipesToFavorite(Map<String, dynamic> recipe) async {
    http.Response response;

    String totalUrl = '$API_PREFIX/user/favorite-recipes';

    try {
      response = await http.post(Uri.parse(totalUrl),
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

    String totalUrl = '$API_PREFIX/user/favorite-recipes/$ID';

    try {
      response = await http.get(Uri.parse(totalUrl),
          headers: baseHeader);
    } catch (e) {
      print(e.toString());
      throw Exception('Could not connect to server');
    }

    return response;
  }

  static Future<http.Response> removeFavoriteRecipe(int ID) async {
    http.Response response;

    String totalUrl = '$API_PREFIX/user/favorite-recipes/$ID';

    try {
      response = await http.delete(Uri.parse(totalUrl),
          headers: baseHeader);
    } catch (e) {
      print(e.toString());
      throw Exception('Could not connect to server');
    }

    return response;
  }
}
