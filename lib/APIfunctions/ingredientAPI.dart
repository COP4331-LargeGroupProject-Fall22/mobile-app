import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:smart_chef/APIfunctions/APIutils.dart';

class Ingredients {
  static const String apiRoute = 'ingredients';

  static Future<http.Response> searchIngredients(String searchQuery, int resultsPerPage, int page, String intolerance) async {
    http.Response response;

    String totalUrl = '$API_PREFIX$apiRoute?ingredientName=$searchQuery';
    if (resultsPerPage != 0) {
      totalUrl += '&resultsPerPage=$resultsPerPage';
    }
    if (page != 0) {
      totalUrl += '&page=$page';
    }
    if (intolerance.isNotEmpty) {
      totalUrl += '&intolerance=$intolerance';
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

  static Future<http.Response> getIngredientByID(int ingredientID, int quantity, String unit) async {
    http.Response response;

    String totalUrl = '$API_PREFIX$apiRoute/$ingredientID';
    if (quantity != 0) {
      totalUrl += '&quantity=$quantity';
    }
    if (unit.isNotEmpty) {
      totalUrl += '&unit=$unit';
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
}
