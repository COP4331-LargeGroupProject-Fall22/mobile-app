import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:smart_chef/utils/APIutils.dart';

class User {

  static const String apiRoute = 'user';

  static Future<http.Response> getUser() async {
    http.Response response;

    try {
      response = await http.get(Uri.parse('$API_PREFIX$apiRoute'), headers: accessTokenHeader);
    } catch (e) {
      print(e.toString());
      throw Exception('Could not connect to server');
    }

    return response;
  }

  static Future<http.Response> updateUser(Map<String, dynamic> changes) async {
    http.Response response;

    try {
      response = await http.put(Uri.parse('$API_PREFIX$apiRoute'),
          body: json.encode(changes),
          headers: accessTokenHeader);
    } catch (e) {
      print(e.toString());
      throw Exception('Could not connect to server');
    }

    return response;
  }

  static Future<http.Response> deleteUser() async {
    http.Response response;

    try {
      response = await http.delete(Uri.parse('$API_PREFIX$apiRoute'), headers: accessTokenHeader);
    } catch (e) {
      print(e.toString());
      throw Exception('Could not connect to server');
    }

    return response;
  }
}
