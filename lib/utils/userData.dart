import 'dart:convert';
import 'dart:io';

class UserData {

  String firstName;
  String lastName;
  String email;
  String password;
  String accessToken;
  String refreshToken;
  // TODO(6): Add profile image support
  //static late bool hasProfileImage;
  //static late String profileImage;

  UserData(this.firstName, this.lastName, this.email, this.password, this.accessToken, this.refreshToken);

  static toNull(_) => null;

  void defineUserData(Map<String, dynamic> json) {
    firstName = json['firstName'];
    lastName = json['lastName'];
    email = json['username'];
    password = json['password'];
  }

  void defineTokens(Map<String, dynamic> json) {
    accessToken = json['accessToken'];
    refreshToken = json['refreshToken'];
  }

  Map<String,dynamic> toJson() => {
    'firstName': firstName,
    'lastName': lastName,
    'lastSeen': -1,
    'username': email,
    'password': password,
  };

  void clear() {
    firstName = '';
    lastName = '';
    email = '';
    password = '';
    accessToken = '';
    refreshToken = '';
  }
}
