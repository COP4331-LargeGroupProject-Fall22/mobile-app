import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:smart_chef/APIfunctions/APIutils.dart';

class Authentication {
  static const String apiRoute = 'auth';

  static Future<http.Response> login(Map<String, dynamic> payload) async {
    http.Response response;

    try {
      response = await http.post(Uri.https(API_PREFIX, '${apiRoute}/login'),
          body: json.encode(payload),
          headers: baseHeader);
    } catch (e) {
      print(e.toString());
      throw Exception('Could not connect to server');
    }

    return response;
  }

  static Future<http.Response> refreshToken() async {
    http.Response response;

    try {
      Map<String, dynamic> tokenBody = {'refreshToken': user.refreshToken};
      response = await http.post(Uri.https(API_PREFIX, '${apiRoute}/refreshJWT'),
          body: json.encode(tokenBody),
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
      response = await http.post(Uri.https(API_PREFIX, '${apiRoute}/register'),
          body: json.encode(payload),
          headers: baseHeader);
    } catch (e) {
      print(e.toString());
      throw Exception('Could not connect to server');
    }

    return response;
  }

  static Future<http.Response> logout() async {
    http.Response response;

    final header = {
      HttpHeaders.contentTypeHeader: 'application/json',
      HttpHeaders.authorizationHeader: user.accessToken
    };

    try {
      response = await http.get(Uri.https(API_PREFIX, '${apiRoute}/logout'), headers: header);
    } catch (e) {
      print(e.toString());
      throw Exception('Could not connect to server');
    }

    return response;
  }

  static Future<http.Response> sendCode(Map<String, dynamic> payload) async {
    http.Response response;

    try {
      response = await http.post(Uri.https(API_PREFIX, '${apiRoute}/send-verification-code'),
          body: json.encode(payload),
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
      response = await http.post(Uri.https(API_PREFIX, '${apiRoute}/confirm-verification-code'),
          body: json.encode(payload),
          headers: baseHeader);
    } catch (e) {
      print(e.toString());
      throw Exception('Could not connect to server');
    }

    return response;
  }

  static Future<http.Response> requestResetCode(Map<String, dynamic> payload) async {
    http.Response response;

    try {
      response = await http.post(Uri.https(API_PREFIX, '${apiRoute}/request-password-reset'),
          body: json.encode(payload),
          headers: baseHeader);
    } catch (e) {
      print(e.toString());
      throw Exception('Could not connect to server');
    }

    return response;
  }

  static Future<http.Response> resetPassword(Map<String, dynamic> payload) async {
    http.Response response;

    try {
      response = await http.post(Uri.https(API_PREFIX, '${apiRoute}/perform-password-reset'),
          body: json.encode(payload),
          headers: baseHeader);
    } catch (e) {
      print(e.toString());
      throw Exception('Could not connect to server');
    }

    return response;
  }
}
