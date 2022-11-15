import 'package:smart_chef/utils/userData.dart';

const String API_PREFIX = "https://api-smart-chef.herokuapp.com/";

late UserData user;

RegExp emailValidation = RegExp(
    r'^(([^<>()[\]\\.,;:\s@"]+(\.[^<>()[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');

bool isEmail(email) {
  return emailValidation.hasMatch(email);
}
