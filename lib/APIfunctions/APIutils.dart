import 'dart:convert';
import 'dart:io';

import 'package:smart_chef/APIfunctions/authAPI.dart';
import 'package:smart_chef/utils/recipeData.dart';
import 'package:smart_chef/utils/userData.dart';

const String API_PREFIX = "https://api-smart-chef.herokuapp.com/";
final baseHeader = {HttpHeaders.contentTypeHeader: 'application/json'};
final accessTokenHeader = {
  HttpHeaders.contentTypeHeader: 'application/json',
  HttpHeaders.authorizationHeader: user.accessToken
};
const int resultsPerPage = 30;
List<Instruction> instructionList = [];
int recipeId = 0;

UserData user = UserData.create();
final messageDelay = Future.delayed(Duration(seconds: 1));

RegExp emailValidation = RegExp(
    r'^(([^<>()[\]\\.,;:\s@"]+(\.[^<>()[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');

bool isEmail(email) {
  return emailValidation.hasMatch(email);
}

// Function that will go through the process of attempting to refresh the token
// It will try three times to refresh the token
// If it is unable to refresh the token, it will try to relog the user with the previously provided login information
// If that also fails, then the user is shown an error dialog that will then redirect them to the start screen
Future<bool> tryTokenRefresh() async {
  int tries = 0;
  while (tries < 3) {
    if (await refreshTokenStatus()) {
      return true;
    } else {
      tries++;
    }
  }
  if (await reauthenticateUser()) {
    return true;
  }
  return false;
}

// Function that refreshes the token
// It will either return true if it was able to refresh or false if it was unable to
Future<bool> refreshTokenStatus() async {
  final changeToken = await Authentication.refreshToken();
  switch (changeToken.statusCode) {
    case 200:
      var tokens = json.decode(changeToken.body);
      user.defineTokens(tokens);
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

Future<bool> reauthenticateUser() async {

  Map<String, dynamic> payload = {
    'username': user.username,
    'password': user.password
  };

  final response = await Authentication.login(payload);
  switch (response.statusCode) {
    case 200:
      var data = json.decode(response.body);
      user.defineTokens(data);
      print('Successful relog');
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
    default:
      print('Cannot connect!');
  }
  return false;
}
