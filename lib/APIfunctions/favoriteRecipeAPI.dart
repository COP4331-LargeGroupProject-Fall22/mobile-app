import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:smart_chef/APIfunctions/APIutils.dart';

class FavRecipe {

  static const String apiRoute = 'user/favorite-recipes';

  static Future<http.Response> getFavoriteRecipes() async {
    http.Response response;

    final header = {
      HttpHeaders.contentTypeHeader: 'application/json',
      HttpHeaders.authorizationHeader: user.accessToken
    };

    try {
      response = await http.get(Uri.parse('$API_PREFIX$apiRoute'), headers: header);
    } catch (e) {
      print(e.toString());
      throw Exception('Could not connect to server');
    }

    return response;
  }

  static Future<http.Response> addFavoriteRecipe(Map<String, dynamic> recipe) async {
    http.Response response;

    final header = {
      HttpHeaders.contentTypeHeader: 'application/json',
      HttpHeaders.authorizationHeader: user.accessToken
    };

    try {
      response = await http.post(Uri.parse('$API_PREFIX$apiRoute'),
          body: json.encode(recipe),
          headers: header);
    } catch (e) {
      print(e.toString());
      throw Exception('Could not connect to server');
    }

    return response;
  }

  static Future<http.Response> getFavoriteRecipeByID(int ID) async {
    http.Response response;

    final header = {
      HttpHeaders.contentTypeHeader: 'application/json',
      HttpHeaders.authorizationHeader: user.accessToken
    };

    try {
      response = await http.get(Uri.parse('$API_PREFIX$apiRoute/$ID'), headers: header);
    } catch (e) {
      print(e.toString());
      throw Exception('Could not connect to server');
    }

    return response;
  }

  static Future<http.Response> removeFavoriteRecipe(int ID) async {
    http.Response response;

    final header = {
      HttpHeaders.contentTypeHeader: 'application/json',
      HttpHeaders.authorizationHeader: user.accessToken
    };

    try {
      response = await http.delete(Uri.parse('$API_PREFIX$apiRoute/$ID'), headers: header);
    } catch (e) {
      print(e.toString());
      throw Exception('Could not connect to server');
    }

    return response;
  }
}
