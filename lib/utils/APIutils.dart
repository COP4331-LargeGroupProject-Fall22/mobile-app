import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:smart_chef/utils/authAPI.dart';
import 'package:smart_chef/utils/userData.dart';

const String API_PREFIX = "https://api-smart-chef.herokuapp.com/";
final baseHeader = {HttpHeaders.contentTypeHeader: 'application/json'};

late UserData user;

RegExp emailValidation = RegExp(
    r'^(([^<>()[\]\\.,;:\s@"]+(\.[^<>()[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');

bool isEmail(email) {
  return emailValidation.hasMatch(email);
}

//Function that will go through the process of attempting to refresh the token
//It will try three times to refresh the token
//If it is unable to refresh the token, it will try to relog the user with the previously provided login information
//If that also fails, then the user is shown an error dialog that will then redirect them to the start screen
Future<bool> tryTokenRefresh() async {
  int tries = 0;
  while (tries < 3) {
    if (await refreshTokenStatus()) {
      return true;
    } else {
      tries++;
    }
  }
  if (await relogUser()) {
    return true;
  }
  return false;
}

Future<bool> refreshTokenStatus() async {
  final changeToken = await Authentication.refreshToken();
  switch (changeToken.statusCode) {
    case 200:
      var tokens = json.decode(changeToken.body);
      user.accessToken = tokens['accessToken'];
      user.refreshToken = tokens['refreshToken'];
      return true;
    case 400:
      return false;
    case 401:
      return false;
    default:
      print('Cannot connect!');
      return false;
  }
}

Future<bool> relogUser() async {

  Map<String, dynamic> payload = {
    'username': user.email,
    'password': user.password
  };

  final response = await Authentication.login(payload);
  switch (response.statusCode) {
    case 200:
      var data = json.decode(response.body);
      user.accessToken = data['accessToken'];
      user.refreshToken = data['refreshToken'];
      return true;
    case 400:
      print('Incorrect request format');
      break;
    case 401:
      print('User credentials incorrect');
      break;
    case 403:
      print('Account not verified');
      break;
    case 404:
      print('User not found');
      break;
  }
  return false;
}
