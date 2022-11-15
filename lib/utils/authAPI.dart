import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:smart_chef/utils/APIutils.dart';

class Authentication {
  static const String extension = 'auth';

  static Future<http.Response> login(String outgoing) async {
    http.Response response;
    final headers = {HttpHeaders.contentTypeHeader: 'application/json'};
    try {
      String totalurl = '$API_PREFIX$extension/login?includeInfo=true';
      response = await http.post(Uri.parse(totalurl),
          body: utf8.encode(outgoing),
          headers: headers,
          encoding: Encoding.getByName("utf-8"));
      return response;
    } catch (e) {
      print("Could not connect!");
    }
    throw Exception('Could not connect to server');
  }

  static Future<http.Response> refreshToken() async {
    http.Response response;
    final headers = {HttpHeaders.contentTypeHeader: 'application/json'};
    try {
      String totalurl = '$API_PREFIX$extension/refreshJWT';
      response = await http.put(Uri.parse(totalurl),
          body: utf8.encode('{"refreshToken": "${user.refreshToken}"}'),
          headers: headers);
      return response;
    } catch (e) {
      print(e.toString());
    }
    throw Exception('Could not connect to server');
  }

  static Future<http.Response> register(String outgoing) async {
    http.Response response;
    final headers = {HttpHeaders.contentTypeHeader: 'application/json'};
    try {
      String totalurl = '$API_PREFIX$extension/register';
      response = await http.post(Uri.parse(totalurl),
          body: utf8.encode(outgoing),
          headers: headers,
          encoding: Encoding.getByName("utf-8"));
      return response;
    } catch (e) {
      print("Could not connect!");
    }
    throw Exception('Could not connect to server');
  }

  static Future<http.Response> logout() async {
    http.Response response;
    final headers = {
      HttpHeaders.contentTypeHeader: 'application/json',
      HttpHeaders.authorizationHeader: user.accessToken
    };
    try {
      String totalurl = '$API_PREFIX$extension/logout';
      response = await http.get(Uri.parse(totalurl), headers: headers);
      return response;
    } catch (e) {
      print(e.toString());
    }
    throw Exception('Could not connect to server');
  }
}
