class UserData {
  String firstName;
  String lastName;
  String email;
  String password;
  String accessToken;
  String refreshToken;
  int lastSeen;
  //TODO: Add profile image support (issue #37)
  //static late bool hasProfileImage;
  //static late String profileImage;

  UserData({required this.firstName, required this.lastName, required this.email, required this.password, required this.accessToken, required this.refreshToken, required this.lastSeen});

  void clear() {
    firstName = '';
    lastName = '';
    email = '';
    password = '';
    accessToken = '';
    refreshToken = '';
    lastSeen = -1;
  }
}
