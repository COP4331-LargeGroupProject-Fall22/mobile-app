class UserData {

  String firstName;
  String lastName;
  String username;
  String email;
  String password;
  String accessToken;
  String refreshToken;
  // TODO(6): Add profile image support
  String profileImage;

  UserData(this.firstName, this.lastName, this.username, this.email, this.password, this.accessToken, this.refreshToken, this.profileImage);

  static final UserData origin = UserData('', '', '', '', '', '', '', '');

  factory UserData.create() {
    return origin;
  }

  void defineUserData(Map<String, dynamic> json) {
    this.firstName = json['firstName'];
    this.lastName = json['lastName'];
    this.username = json['username'];
    this.email = json['email'];
  }

  void defineProfileImage(Map<String, dynamic> json) {
    this.profileImage = json.containsKey('srcUrl') ? json['srcUrl'] : '';
  }

  void defineTokens(Map<String, dynamic> json) {
    this.accessToken = json['accessToken']['token'];
    this.refreshToken = json['refreshToken']['token'];
  }

  void setPassword(String pass) {
    this.password = pass;
  }

  Map<String,dynamic> toJson() => {
    'firstName': this.firstName,
    'lastName': this.lastName,
    'lastSeen': 1,
    'username': this.username,
    'email': this.email,
    'password': this.password,
  };

  void clear() {
    this.firstName = '';
    this.lastName = '';
    this.email = '';
    this.password = '';
    this.accessToken = '';
    this.refreshToken = '';
  }
}
