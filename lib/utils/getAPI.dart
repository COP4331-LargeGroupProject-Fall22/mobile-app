import 'dart:io';

import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:smart_chef/utils/globals.dart';

class UserData {
  static Future<http.Response> authUser(String url, String outgoing) async{
    http.Response response;
    final headers = {HttpHeaders.contentTypeHeader: 'application/json'};
    try {
      String totalurl = '$API_PREFIX$url';
      response = await http.post(Uri.parse(totalurl),
          body: utf8.encode(outgoing),
          headers:  headers,
      encoding:Encoding.getByName("utf-8"));
      return response;
    }
    catch(e) {
      print("Could not connect!");
    }
    throw Exception('Could not connect to server');
  }

  static Future<http.Response> getUser(String url, String auth) async{
    http.Response response;
    final headers = {HttpHeaders.contentTypeHeader: 'application/json', HttpHeaders.authorizationHeader: auth};
    try {
      String totalurl = '$API_PREFIX$url';
      response = await http.get(Uri.parse(totalurl), headers: headers);
      return response;
    }
    catch(e) {
      print(e.toString());
    }
    throw Exception('Could not connect to server');
  }

  static Future<http.Response> logoutUser(String url, String auth) async{
    http.Response response;
    final headers = {HttpHeaders.contentTypeHeader: 'application/json', HttpHeaders.authorizationHeader: auth};
    try {
      String totalurl = '$API_PREFIX$url';
      response = await http.get(Uri.parse(totalurl), headers: headers);
      return response;
    }
    catch(e) {
      print(e.toString());
    }
    throw Exception('Could not connect to server');
  }

  static Future<http.Response> updateUser(String url, String changes) async{
    http.Response response;
    final headers = {HttpHeaders.contentTypeHeader: 'application/json', HttpHeaders.authorizationHeader: LocalData.accessToken};
    try {
      String totalurl = '$API_PREFIX$url';
      response = await http.put(Uri.parse(totalurl), body: utf8.encode(changes), headers: headers);
      return response;
    }
    catch(e) {
      print(e.toString());
    }
    throw Exception('Could not connect to server');
  }

  static Future<http.Response> refreshToken(String url) async{
    http.Response response;
    final headers = {HttpHeaders.contentTypeHeader: 'application/json'};
    try {
      String totalurl = '$API_PREFIX$url';
      response = await http.put(Uri.parse(totalurl), body: utf8.encode('{"refreshToken": "${LocalData.refreshToken}"}'), headers: headers);
      return response;
    }
    catch(e) {
      print(e.toString());
    }
    throw Exception('Could not connect to server');
  }

  static Future<http.Response> deleteUser(String url, String auth) async{
    http.Response response;
    final headers = {HttpHeaders.contentTypeHeader: 'application/json', HttpHeaders.authorizationHeader: LocalData.accessToken};
    try {
      String totalurl = '$API_PREFIX$url';
      response = await http.put(Uri.parse(totalurl), headers: headers);
      return response;
    }
    catch(e) {
      print(e.toString());
    }
    throw Exception('Could not connect to server');
  }
}

class LocalData {
  static late String lastName;
  static late String firstName;
  static late String email;
  static late String password;
  static late String accessToken;
  static late String refreshToken;
  static late int lastSeen;
  //static late bool hasProfileImage;
  //static late String profileImage;
}