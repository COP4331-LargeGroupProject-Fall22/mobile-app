import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:smart_chef/APIfunctions/APIutils.dart';

class Ingredients {
  static const String apiRoute = 'ingredients';

  static Future<http.Response> searchIngredients(Map<String, dynamic> queries) async {
    http.Response response;

    Uri totalUrl = Uri.https(API_PREFIX, apiRoute, queries);

    try {
      response = await http.get(totalUrl,
          headers: baseHeader);
    } catch (e) {
      print(e.toString());
      throw Exception('Could not connect to server');
    }

    return response;
  }

  static Future<http.Response> getIngredientByID(int ID) async {
    http.Response response;

    try {
      response = await http.get(Uri.https(API_PREFIX, '${apiRoute}/${ID}'),
          headers: baseHeader);
    } catch (e) {
      print(e.toString());
      throw Exception('Could not connect to server');
    }

    return response;
  }
}
