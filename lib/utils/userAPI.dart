import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:smart_chef/utils/APIutils.dart';

class User {

  static const String apiRoute = 'user';

  static Future<http.Response> getUser() async {
    http.Response response;

    final headers = {
      HttpHeaders.contentTypeHeader: 'application/json',
      HttpHeaders.authorizationHeader: user.accessToken
    };

    try {
      response = await http.get(Uri.parse('$API_PREFIX$apiRoute'), headers: headers);
    } catch (e) {
      print(e.toString());
      throw Exception('Could not connect to server');
    }

    return response;
  }

  static Future<http.Response> updateUser(Map<String, dynamic> changes) async {
    http.Response response;

    final headers = {
      HttpHeaders.contentTypeHeader: 'application/json',
      HttpHeaders.authorizationHeader: user.accessToken
    };

    try {
      response = await http.put(Uri.parse('$API_PREFIX$apiRoute'),
          body: changes,
          headers: headers);
    } catch (e) {
      print(e.toString());
      throw Exception('Could not connect to server');
    }

    return response;
  }

  static Future<http.Response> deleteUser() async {
    http.Response response;

    final headers = {
      HttpHeaders.contentTypeHeader: 'application/json',
      HttpHeaders.authorizationHeader: user.accessToken
    };

    try {
      response = await http.delete(Uri.parse('$API_PREFIX$apiRoute'), headers: headers);
    } catch (e) {
      print(e.toString());
      throw Exception('Could not connect to server');
    }

    return response;
  }
}
