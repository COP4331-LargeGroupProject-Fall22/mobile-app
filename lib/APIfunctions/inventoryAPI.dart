import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:smart_chef/APIfunctions/APIutils.dart';

class Inventory {
  static const String apiRoute = 'user/inventory';

  static Future<http.Response> retrieveUserInventory(Map<String, dynamic> queries) async {
    http.Response response;

    final header = {
      HttpHeaders.contentTypeHeader: 'application/json',
      HttpHeaders.authorizationHeader: user.accessToken
    };

    try {
      response = await http.get(Uri.https(API_PREFIX, apiRoute, queries),
          headers: header);
    } catch (e) {
      print(e.toString());
      throw Exception('Could not connect to server');
    }

    return response;
  }

  static Future<http.Response> addIngredient(Map<String, dynamic> payload) async {
    http.Response response;

    final header = {
      HttpHeaders.contentTypeHeader: 'application/json',
      HttpHeaders.authorizationHeader: user.accessToken
    };

    try {
      response = await http.post(Uri.https(API_PREFIX, apiRoute),
          body: json.encode(payload),
          headers: header);
    } catch (e) {
      print(e.toString());
      throw Exception('Could not connect to server');
    }

    return response;
  }

  static Future<http.Response> retrieveIngredientFromInventory(Map<String, dynamic> queries) async {
    http.Response response;

    final header = {
      HttpHeaders.contentTypeHeader: 'application/json',
      HttpHeaders.authorizationHeader: user.accessToken
    };

    try {
      response = await http.get(Uri.https(API_PREFIX, apiRoute, queries),
          headers: header);
    } catch (e) {
      print(e.toString());
      throw Exception('Could not connect to server');
    }

    return response;
  }

  static Future<http.Response> updateIngredientInInventory(int id, Map<String, dynamic> payload) async {
    http.Response response;

    final header = {
      HttpHeaders.contentTypeHeader: 'application/json',
      HttpHeaders.authorizationHeader: user.accessToken
    };

    try {
      response = await http.put(Uri.https(API_PREFIX, '$apiRoute/$id'),
          body: json.encode(payload),
          headers: header);
    } catch (e) {
      print(e.toString());
      throw Exception('Could not connect to server');
    }

    return response;
  }

  static Future<http.Response> deleteIngredientfromInventory(int id) async {
    http.Response response;

    final header = {
      HttpHeaders.contentTypeHeader: 'application/json',
      HttpHeaders.authorizationHeader: user.accessToken
    };

    try {
      response = await http.delete(Uri.https(API_PREFIX, '$apiRoute/$id'),
          headers: header);
    } catch (e) {
      print(e.toString());
      throw Exception('Could not connect to server');
    }

    return response;
  }
}
