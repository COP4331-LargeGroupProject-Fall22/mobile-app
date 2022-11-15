import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:smart_chef/utils/APIutils.dart';

class User {
  static const String extension = 'user';

  static Future<http.Response> getUser() async {
    http.Response response;
    final headers = {
      HttpHeaders.contentTypeHeader: 'application/json',
      HttpHeaders.authorizationHeader: user.refreshToken
    };
    try {
      String totalurl = '$API_PREFIX$extension';
      response = await http.get(Uri.parse(totalurl), headers: headers);
      return response;
    } catch (e) {
      print(e.toString());
    }
    throw Exception('Could not connect to server');
  }

  static Future<http.Response> updateUser(String changes) async {
    http.Response response;
    final headers = {
      HttpHeaders.contentTypeHeader: 'application/json',
      HttpHeaders.authorizationHeader: user.accessToken
    };
    try {
      String totalurl = '$API_PREFIX$extension';
      response = await http.put(Uri.parse(totalurl),
          body: utf8.encode(changes), headers: headers);
      return response;
    } catch (e) {
      print(e.toString());
    }
    throw Exception('Could not connect to server');
  }

  static Future<http.Response> deleteUser() async {
    http.Response response;
    final headers = {
      HttpHeaders.contentTypeHeader: 'application/json',
      HttpHeaders.authorizationHeader: user.accessToken
    };
    try {
      String totalurl = '$API_PREFIX$extension';
      response = await http.delete(Uri.parse(totalurl), headers: headers);
      return response;
    } catch (e) {
      print(e.toString());
    }
    throw Exception('Could not connect to server');
  }
}
