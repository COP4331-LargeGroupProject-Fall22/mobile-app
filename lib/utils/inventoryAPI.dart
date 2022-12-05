import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:smart_chef/utils/APIutils.dart';

class Inventory {
  static const String apiRoute = 'user/inventory';

  static Future<http.Response> retrieveUserInventory(bool isReverse, bool sortByExpirationDate, bool sortByCategory, bool sortByLexicographicalOrder) async {
    http.Response response;

    String totalUrl = '$API_PREFIX$apiRoute?';
    if (isReverse) {
      totalUrl += 'isReverse=true';
    } else {
      totalUrl += 'isReverse=false';
    }
    if (sortByExpirationDate) {
      totalUrl += '&sortByExpirationDate=true';
    } else {
      if (sortByCategory) {
        totalUrl += '&sortByCategory=true';
      } else {
        if (sortByLexicographicalOrder) {
          totalUrl += '&sortByLexicographicalOrder=true';
        }
      }
    }

    try {
      response = await http.get(Uri.parse(totalUrl),
          headers: accessTokenHeader);
    } catch (e) {
      print(e.toString());
      throw Exception('Could not connect to server');
    }

    return response;
  }

  static Future<http.Response> addIngredient(Map<String, dynamic> payload) async {
    http.Response response;

    String totalUrl = '$API_PREFIX$apiRoute';

    try {
      response = await http.post(Uri.parse(totalUrl),
          body: json.encode(payload),
          headers: accessTokenHeader);
    } catch (e) {
      print(e.toString());
      throw Exception('Could not connect to server');
    }

    return response;
  }

  static Future<http.Response> retrieveIngredientFromInventory(int id) async {
    http.Response response;

    try {
      response = await http.get(Uri.parse('$API_PREFIX$apiRoute/$id'),
          headers: accessTokenHeader);
    } catch (e) {
      print(e.toString());
      throw Exception('Could not connect to server');
    }

    return response;
  }

  static Future<http.Response> updateIngredientInInventory(int id, Map<String, dynamic> payload) async {
    http.Response response;

    try {
      response = await http.put(Uri.parse('$API_PREFIX$apiRoute/$id'),
          body: json.encode(payload),
          headers: accessTokenHeader);
    } catch (e) {
      print(e.toString());
      throw Exception('Could not connect to server');
    }

    return response;
  }

  static Future<http.Response> deleteIngredientfromInventory(int id) async {
    http.Response response;

    try {
      response = await http.delete(Uri.parse('$API_PREFIX$apiRoute/$id'),
          headers: accessTokenHeader);
    } catch (e) {
      print(e.toString());
      throw Exception('Could not connect to server');
    }

    return response;
  }
}
