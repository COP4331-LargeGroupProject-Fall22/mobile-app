import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:smart_chef/utils/APIutils.dart';

class Authentication {
  static const String apiRoute = 'auth';

  static Future<http.Response> login(Map<String, dynamic> payload) async {
    http.Response response;

    try {
      response = await http.post(Uri.parse('$API_PREFIX$apiRoute/login?includeInfo=true'),
          body: payload,
          headers: baseHeader);
    } catch (e) {
      print("Could not connect!");
      throw Exception('Could not connect to server');
    }

    return response;
  }

  static Future<http.Response> refreshToken() async {
    http.Response response;

    try {
      Map<String, dynamic> tokenBody = {'refreshToken': user.refreshToken};
      response = await http.put(Uri.parse('$API_PREFIX$apiRoute/refreshJWT'),
          body: tokenBody,
          headers: baseHeader);
    } catch (e) {
      print(e.toString());
      throw Exception('Could not connect to server');
    }

    return response;
  }

  static Future<http.Response> register(Map<String, dynamic> payload) async {
    http.Response response;

    try {
      response = await http.post(Uri.parse('$API_PREFIX$apiRoute/register'),
          body: payload,
          headers: baseHeader);
    } catch (e) {
      print(e.toString());
      throw Exception('Could not connect to server');
    }

    return response;
  }

  static Future<http.Response> logout() async {
    http.Response response;

    final headers = {
      HttpHeaders.contentTypeHeader: 'application/json',
      HttpHeaders.authorizationHeader: user.accessToken
    };

    try {
      response = await http.get(Uri.parse('$API_PREFIX$apiRoute/logout'), headers: headers);
    } catch (e) {
      print(e.toString());
      throw Exception('Could not connect to server');
    }

    return response;
  }

  static Future<http.Response> sendCode(Map<String, dynamic> payload) async {
    http.Response response;

    try {
      response = await http.post(Uri.parse('$API_PREFIX$apiRoute/send-verification-code'),
          body: payload,
          headers: baseHeader);
    } catch (e) {
      print(e.toString());
      throw Exception('Could not connect to server');
    }

    return response;
  }

  static Future<http.Response> verifyCode(Map<String, dynamic> payload) async {
    http.Response response;

    try {
      response = await http.post(Uri.parse('$API_PREFIX$apiRoute/confirm-verification-code'),
          body: payload,
          headers: baseHeader);
    } catch (e) {
      print(e.toString());
      throw Exception('Could not connect to server');
    }

    return response;
  }
}
