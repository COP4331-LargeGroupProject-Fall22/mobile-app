import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:smart_chef/utils/APIutils.dart';
import 'package:smart_chef/utils/authAPI.dart';
import 'package:smart_chef/utils/colors.dart';
import 'package:smart_chef/utils/globals.dart';
import 'package:smart_chef/utils/userAPI.dart';

class UserProfileScreen extends StatefulWidget {
  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfileScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return UserProfilePage();
  }
}

class UserProfilePage extends StatefulWidget {
  @override
  _UserProfilePageState createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  @override
  void initState() {
    super.initState();
  }

  String errorMessage = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'SmartChef',
          style: TextStyle(fontSize: 24, color: mainScheme),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () async {
            try {
              final res = await Authentication.logout();

              if (res.statusCode == 200) {
                setState(() {
                  errorMessage = 'Logout successful!';
                });
                await Future.delayed(Duration(seconds: 1));
                user.clear();

                Navigator.pushNamedAndRemoveUntil(
                    context, '/startup', ((Route<dynamic> route) => false));
              } else {
                errorMessage = getLogoutError(res.statusCode);
              }
            } catch (e) {
              print('Could not connect to server');
            }
          },
          icon: Icon(
            Icons.logout,
            color: Colors.black,
          ),
          iconSize: 35,
        ),
        actions: <Widget>[
          IconButton(
            onPressed: () async {
              bool delete = deleteDialog(context);

              if (!delete) {
                return;
              }
              try {
                final res = await User.deleteUser();
                if (res.statusCode == 200) {
                  user.clear();

                  Navigator.pushNamedAndRemoveUntil(
                      context, '/startup', ((Route<dynamic> route) => false));
                } else {
                  errorMessage = getDeleteError(res.statusCode);
                }
              } catch (e) {
                errorDialog(context);
              }
            },
            icon: const Icon(
              Icons.delete,
              color: Colors.red,
            ),
            iconSize: 35,
          ),
        ],
      ),
      body: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: SingleChildScrollView(
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: const BoxDecoration(color: Colors.white),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: 200,
                  height: 200,
                  margin: const EdgeInsets.only(top: 40),
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    border: Border.all(color: Colors.black, width: 2),
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  width: 200,
                  child: const Text(
                    'Your profile image',
                    style: TextStyle(fontSize: 14, color: Colors.black),
                    textAlign: TextAlign.center,
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 60),
                  alignment: Alignment.topCenter,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Expanded(
                            flex: 5,
                            child: Column(
                              children: <Widget>[
                                const Text(
                                  'First Name',
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.black,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                Container(
                                  width: 150,
                                  margin: const EdgeInsets.only(left: 10),
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 7),
                                  decoration: const BoxDecoration(
                                    color: mainScheme,
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(roundedCorner)),
                                  ),
                                  child: Text(
                                    user.firstName.isEmpty
                                        ? ''
                                        : user.firstName,
                                    style: const TextStyle(
                                      fontSize: 20,
                                      color: Colors.white,
                                    ),
                                    textAlign: TextAlign.left,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            flex: 5,
                            child: Column(
                              children: <Widget>[
                                const Text(
                                  'Last Name',
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.black,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                Container(
                                  width: 150,
                                  margin: const EdgeInsets.only(right: 10),
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 5),
                                  decoration: const BoxDecoration(
                                    color: mainScheme,
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(roundedCorner)),
                                  ),
                                  child: Text(
                                    user.lastName.isEmpty ? '' : user.lastName,
                                    style: const TextStyle(
                                      fontSize: 20,
                                      color: Colors.white,
                                    ),
                                    textAlign: TextAlign.left,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Column(
                        children: <Widget>[
                          Container(
                            margin: const EdgeInsets.only(top: 20),
                            child: const Text(
                              'Email',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.black,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width / 1.2,
                            padding: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 5),
                            decoration: const BoxDecoration(
                              color: mainScheme,
                              borderRadius: BorderRadius.all(
                                  Radius.circular(roundedCorner)),
                            ),
                            child: Text(
                              user.email.isEmpty ? '' : user.email,
                              style: const TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                              ),
                              textAlign: TextAlign.left,
                            ),
                          ),
                        ],
                      ),
                      Column(
                        children: <Widget>[
                          Container(
                            margin: const EdgeInsets.only(top: 20),
                            child: const Text(
                              'Username',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.black,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width / 1.2,
                            margin: const EdgeInsets.only(bottom: 20),
                            padding: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 5),
                            decoration: const BoxDecoration(
                              color: mainScheme,
                              borderRadius: BorderRadius.all(
                                  Radius.circular(roundedCorner)),
                            ),
                            child: Text(
                              user.username.isEmpty ? '' : user.username,
                              style: const TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                              ),
                              textAlign: TextAlign.left,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        errorMessage,
                        style: errorTextStyle.copyWith(fontSize: 20),
                        textAlign: TextAlign.center,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Expanded(
                            flex: 5,
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              child: ElevatedButton(
                                onPressed: () {
                                  Navigator.restorablePushNamed(
                                        context, '/user/edit');
                                },
                                style: buttonStyle,
                                child: const Text(
                                  'Edit Information',
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w400,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 5,
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              child: ElevatedButton(
                                onPressed: () {
                                  Navigator.restorablePushNamed(
                                        context, '/user/changePassword');
                                },
                                style: buttonStyle,
                                child: const Text(
                                  'Change Password',
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w400,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Container(
          height: 90,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            border: Border(
                top: BorderSide(color: Colors.black.withOpacity(.2), width: 3)),
            color: Colors.white,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    IconButton(
                      onPressed: () {
                        Navigator.restorablePushReplacementNamed(context, '/food');
                      },
                      icon: const Icon(Icons.egg),
                      iconSize: bottomIconSize,
                      color: bottomRowIcon,
                    ),
                    Text(
                      'Ingredients',
                      style: bottomRowOnScreenTextStyle,
                      textAlign: TextAlign.center,
                    )
                  ],
                ),
              ),
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    IconButton(
                      onPressed: () {
                        Navigator.restorablePushReplacementNamed(context, '/recipe');
                      },
                      icon: const Icon(Icons.restaurant),
                      iconSize: bottomIconSize,
                      color: bottomRowIcon,
                    ),
                    Text(
                      'Recipes',
                      style: bottomRowIconTextStyle,
                      textAlign: TextAlign.center,
                    )
                  ],
                ),
              ),
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    IconButton(
                      onPressed: () {
                        Navigator.restorablePushReplacementNamed(context, '/cart');
                      },
                      icon: const Icon(Icons.shopping_cart),
                      iconSize: bottomIconSize,
                      color: bottomRowIcon,
                    ),
                    Text(
                      'Shopping Cart',
                      style: bottomRowIconTextStyle,
                      textAlign: TextAlign.center,
                    )
                  ],
                ),
              ),
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.person),
                      iconSize: bottomIconSize,
                      color: mainScheme,
                    ),
                    Text(
                      'User Profile',
                      style: bottomRowOnScreenTextStyle,
                      textAlign: TextAlign.center,
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String getLogoutError(int statusCode) {
    switch (statusCode) {
      case 400:
        return "Could not logout";
      case 401:
        return 'Access Token invalid';
      default:
        return 'Something went wrong!';
    }
  }

  String getDeleteError(int statusCode) {
    switch (statusCode) {
      case 400:
        return 'Incorrect request format';
      case 401:
        return 'Token is invalid';
      case 404:
        return 'User not found';
      default:
        return 'Something went wrong!';
    }
  }
}

class EditUserProfilePage extends StatefulWidget {
  @override
  _EditUserProfilePageState createState() => _EditUserProfilePageState();
}

class _EditUserProfilePageState extends State<EditUserProfilePage> {
  @override
  void initState() {
    _firstName.text = user.firstName;
    _lastName.text = user.lastName;
    _username.text = user.username;
    super.initState();
  }

  final _firstName = TextEditingController();
  bool unfilledFirstName = false;

  final _lastName = TextEditingController();
  bool unfilledLastName = false;

  final _username = TextEditingController();
  bool unfilledUsername = false;

  final _password = TextEditingController();
  bool unfilledPassword = false;

  final _confirmPassword = TextEditingController();
  bool unfilledConfirmPassword = false;

  String errorMessage = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'SmartChef',
          style: TextStyle(fontSize: 24, color: mainScheme),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.navigate_before,
            color: Colors.black,
          ),
          iconSize: 35,
        ),
      ),
      body: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: const BoxDecoration(color: Colors.white),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: 200,
                  height: 200,
                  margin: const EdgeInsets.only(top: 20),
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    border: Border.all(color: Colors.black, width: 2),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  width: 200,
                  child: const Text(
                    'Your profile image',
                    style: TextStyle(fontSize: 14, color: Colors.black),
                    textAlign: TextAlign.center,
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 10),
                  alignment: Alignment.topCenter,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Column(
                            children: <Widget>[
                              const Text(
                                'First Name',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.black,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              Container(
                                width: 150,
                                margin: const EdgeInsets.only(right: 10),
                                padding: const EdgeInsets.symmetric(
                                    vertical: 5, horizontal: 5),
                                decoration: const BoxDecoration(
                                  color: mainScheme,
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(roundedCorner)),
                                ),
                                child: TextField(
                                  maxLines: 1,
                                  controller: _firstName,
                                  decoration: unfilledFirstName
                                      ? invalidTextField.copyWith(
                                          hintText: 'Enter First Name')
                                      : globalDecoration.copyWith(
                                          hintText: 'Enter First Name'),
                                  style: textFieldFontStyle,
                                  onChanged: (firstName) {
                                    if (firstName.isEmpty) {
                                      setState(() => unfilledFirstName = true);
                                    } else {
                                      setState(() => unfilledFirstName = false);
                                    }
                                  },
                                  textAlign: TextAlign.left,
                                  textInputAction: TextInputAction.next,
                                ),
                              ),
                            ],
                          ),
                          Column(
                            children: <Widget>[
                              const Text(
                                'Last Name',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.black,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              Container(
                                width: 150,
                                margin: const EdgeInsets.only(left: 10),
                                padding: const EdgeInsets.symmetric(
                                    vertical: 5, horizontal: 5),
                                decoration: const BoxDecoration(
                                  color: mainScheme,
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(roundedCorner)),
                                ),
                                child: TextField(
                                  maxLines: 1,
                                  controller: _lastName,
                                  decoration: unfilledLastName
                                      ? invalidTextField.copyWith(
                                          hintText: 'Enter Last Name')
                                      : globalDecoration.copyWith(
                                          hintText: 'Enter Last Name'),
                                  style: textFieldFontStyle,
                                  textAlign: TextAlign.left,
                                  textInputAction: TextInputAction.next,
                                  onChanged: (lastName) {
                                    if (lastName.isEmpty) {
                                      setState(() => unfilledLastName = true);
                                    } else {
                                      setState(() => unfilledLastName = false);
                                    }
                                  },
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Column(
                        children: <Widget>[
                          Container(
                            margin: const EdgeInsets.only(top: 15),
                            child: const Text(
                              'Username',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.black,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Container(
                            width: 320,
                            padding: const EdgeInsets.symmetric(
                                vertical: 5, horizontal: 5),
                            decoration: const BoxDecoration(
                              color: mainScheme,
                              borderRadius: BorderRadius.all(
                                  Radius.circular(roundedCorner)),
                            ),
                            child: TextField(
                              maxLines: 1,
                              controller: _username,
                              decoration: unfilledUsername
                                  ? invalidTextField.copyWith(
                                  hintText: 'Enter Username')
                                  : globalDecoration.copyWith(
                                  hintText: 'Enter Username'),
                              style: textFieldFontStyle,
                              textAlign: TextAlign.left,
                              onChanged: (username) {
                                if (username.isEmpty) {
                                  setState(() => unfilledUsername = true);
                                } else {
                                  setState(() => unfilledUsername = false);
                                }
                              },
                              textInputAction: TextInputAction.next,
                            ),
                          ),
                        ],
                      ),
                      Column(
                        children: <Widget>[
                          Container(
                            margin: const EdgeInsets.only(top: 15),
                            child: const Text(
                              'Enter Password to confirm changes',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.black,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Container(
                            width: 320,
                            margin: const EdgeInsets.only(bottom: 10),
                            padding: const EdgeInsets.symmetric(
                                vertical: 5, horizontal: 5),
                            decoration: const BoxDecoration(
                              color: mainScheme,
                              borderRadius: BorderRadius.all(
                                  Radius.circular(roundedCorner)),
                            ),
                            child: TextField(
                              maxLines: 1,
                              controller: _password,
                              obscureText: true,
                              decoration: unfilledPassword
                                  ? invalidTextField.copyWith(
                                      hintText: 'Enter Password')
                                  : globalDecoration.copyWith(
                                      hintText: 'Enter Password'),
                              style: textFieldFontStyle,
                              textAlign: TextAlign.left,
                              textInputAction: TextInputAction.next,
                              onChanged: (password) {
                                if (password.isEmpty) {
                                  setState(() => unfilledPassword = true);
                                } else {
                                  setState(() => unfilledPassword = false);
                                }
                              },
                            ),
                          ),
                          Container(
                            width: 320,
                            padding: const EdgeInsets.symmetric(
                                vertical: 5, horizontal: 5),
                            decoration: const BoxDecoration(
                              color: mainScheme,
                              borderRadius: BorderRadius.all(
                                  Radius.circular(roundedCorner)),
                            ),
                            child: TextField(
                              maxLines: 1,
                              controller: _confirmPassword,
                              obscureText: true,
                              decoration: unfilledConfirmPassword
                                  ? invalidTextField.copyWith(
                                      hintText: 'Confirm Password')
                                  : globalDecoration.copyWith(
                                      hintText: 'Confirm Password'),
                              style: textFieldFontStyle,
                              textAlign: TextAlign.left,
                              textInputAction: TextInputAction.done,
                              onChanged: (password) {
                                if (validatePassword(password)) {
                                  errorMessage = '';
                                  setState(() => unfilledConfirmPassword = false);
                                } else {
                                  errorMessage = 'Passwords must match!';
                                  setState(() => unfilledConfirmPassword = true);
                                }
                                setState(() {});
                              },
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(bottom: 15),
                            child: Text(
                              errorMessage,
                              style: errorTextStyle.copyWith(fontSize: 14),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                            child: ElevatedButton(
                              onPressed: () async {
                                if (allEditProfileFieldsValid()) {
                                  if (passwordsMatch()) {
                                    Map<String, dynamic> changes = {
                                      'firstName': _firstName.value.text.trim(),
                                      'lastName': _lastName.value.text.trim(),
                                      'lastSeen' : 1,
                                      'email' : user.email.trim(),
                                      'username': _username.value.text.trim(),
                                      'password': user.password,
                                    };

                                    try {
                                      final res =
                                          await User.updateUser(changes);
                                      if (res.statusCode == 200) {
                                        user.firstName =
                                            _firstName.value.text.trim();
                                        user.lastName =
                                            _lastName.value.text.trim();
                                        user.username = _username.value.text.trim();

                                        errorMessage ==
                                            'Successfully updated your profile!';
                                        await Future.delayed(const Duration(seconds: 1));

                                        clearFields();
                                        Navigator.pop(context);
                                      }
                                      errorMessage = await getUpdateProfileError(res.statusCode);
                                      if (res.statusCode == 403) {
                                        if (errorMessage ==
                                            'Successfully updated your profile!') {
                                          user.firstName =
                                              _firstName.value.text.trim();
                                          user.lastName =
                                              _lastName.value.text.trim();
                                          user.username = _username.value.text.trim();

                                          await Future.delayed(const Duration(seconds: 1));

                                          clearFields();
                                          Navigator.pop(context);
                                        } else {
                                          errorDialog(context);
                                        }
                                      }
                                    } catch (e) {
                                      print('Could not connect to server');
                                    }
                                  }
                                }
                                setState(() {});
                              },
                              style: buttonStyle,
                              child: const Text(
                                'Confirm Changes',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w400,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Container(
          height: 90,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            border: Border(
                top: BorderSide(color: Colors.black.withOpacity(.2), width: 3)),
            color: Colors.white,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    IconButton(
                      onPressed: () {
                        Navigator.restorablePushReplacementNamed(context, '/food');
                      },
                      icon: const Icon(Icons.egg),
                      iconSize: bottomIconSize,
                      color: mainScheme,
                    ),
                    Text(
                      'Ingredients',
                      style: bottomRowOnScreenTextStyle,
                      textAlign: TextAlign.center,
                    )
                  ],
                ),
              ),
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    IconButton(
                      onPressed: () {
                        Navigator.restorablePushReplacementNamed(context, '/recipe');
                      },
                      icon: const Icon(Icons.restaurant),
                      iconSize: bottomIconSize,
                      color: bottomRowIcon,
                    ),
                    Text(
                      'Recipes',
                      style: bottomRowIconTextStyle,
                      textAlign: TextAlign.center,
                    )
                  ],
                ),
              ),
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    IconButton(
                      onPressed: () {
                        Navigator.restorablePushReplacementNamed(context, '/cart');
                      },
                      icon: const Icon(Icons.shopping_cart),
                      iconSize: bottomIconSize,
                      color: bottomRowIcon,
                    ),
                    Text(
                      'Shopping Cart',
                      style: bottomRowIconTextStyle,
                      textAlign: TextAlign.center,
                    )
                  ],
                ),
              ),
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.person),
                      iconSize: bottomIconSize,
                      color: mainScheme,
                    ),
                    Text(
                      'User Profile',
                      style: bottomRowOnScreenTextStyle,
                      textAlign: TextAlign.center,
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool validatePassword(String password) {
    if (password.isEmpty) {
      return false;
    }
    if (_password.value.text.isEmpty) {
      return false;
    }
    if (passwordsMatch()) {
      return true;
    }
    return false;
  }

  bool allEditProfileFieldsValid() {
    bool toReturn = true;
    if (_firstName.value.text.isEmpty) {
      toReturn = false;
      unfilledFirstName = true;
    }
    if (_lastName.value.text.isEmpty) {
      toReturn = false;
      unfilledLastName = true;
    }
    if (_password.value.text.isEmpty) {
      toReturn = false;
      unfilledPassword = true;
      errorMessage = 'Password required to confirm changes';
    }
    if (_confirmPassword.value.text.isEmpty) {
      toReturn = false;
      unfilledConfirmPassword = true;
    }
    return toReturn;
  }

  bool passwordsMatch() {
    if (_password.value.text != user.password) {
      errorMessage = 'Password is incorrect';
      return false;
    }
    if (_password.value.text != _confirmPassword.value.text) {
      errorMessage = 'Passwords must match';
      return false;
    }
    return true;
  }

  void clearFields() {
    unfilledFirstName = false;
    unfilledLastName = false;
    unfilledPassword = false;
    unfilledConfirmPassword = false;
    _firstName.clear();
    _lastName.clear();
    _password.clear();
    _confirmPassword.clear();
  }

  Future<String> getUpdateProfileError(int statusCode) async {
    switch (statusCode) {
      case 400:
        return "Username already taken";
      case 401:
        errorMessage = 'Reconnecting...';
        if (await tryTokenRefresh()) {
          return 'Successfully changed password!';
        } else {
          return 'Cannot connect to server';
        }
      case 404:
        return 'User not found';
      default:
        return 'Something in edit password went wrong!';
    }
  }
}

class EditPasswordPage extends StatefulWidget {
  @override
  _EditPasswordPageState createState() => _EditPasswordPageState();
}

class _EditPasswordPageState extends State<EditPasswordPage> {
  @override
  void initState() {
    super.initState();
  }

  final _oldPassword = TextEditingController();
  bool unfilledOldPassword = false;

  final _newPassword = TextEditingController();
  bool unfilledNewPassword = false;

  final _confirmPassword = TextEditingController();
  bool unfilledConfirmPassword = false;

  String errorMessage = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'SmartChef',
          style: TextStyle(fontSize: 24, color: mainScheme),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.navigate_before,
            color: Colors.black,
          ),
          iconSize: 35,
        ),
      ),
      body: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: SingleChildScrollView(
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: const BoxDecoration(color: Colors.white),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  margin: const EdgeInsets.only(top: 20),
                  alignment: Alignment.topCenter,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Column(
                        children: <Widget>[
                          Container(
                            margin: const EdgeInsets.only(top: 15),
                            child: const Text(
                              'Old Password',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.black,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Container(
                            width: 320,
                            padding: const EdgeInsets.symmetric(
                                vertical: 5, horizontal: 5),
                            decoration: const BoxDecoration(
                              color: mainScheme,
                              borderRadius: BorderRadius.all(
                                  Radius.circular(roundedCorner)),
                            ),
                            child: TextField(
                              maxLines: 1,
                              controller: _oldPassword,
                              decoration: unfilledOldPassword
                                  ? invalidTextField.copyWith(
                                      hintText: 'Enter Old Password')
                                  : globalDecoration.copyWith(
                                      hintText: 'Enter Old Password'),
                              style: textFieldFontStyle,
                              onChanged: (password) {
                                if (_oldPassword.text.isEmpty) {
                                  errorMessage =
                                      'Old password required to change password';
                                  setState(() => unfilledOldPassword = true);
                                } else {
                                  errorMessage = '';
                                  setState(() => unfilledOldPassword = false);
                                }
                              },
                              textInputAction: TextInputAction.next,
                            ),
                          ),
                        ],
                      ),
                      Column(
                        children: <Widget>[
                          Container(
                            margin: const EdgeInsets.only(top: 15),
                            child: const Text(
                              'Enter Password to confirm changes',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.black,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Container(
                            width: 320,
                            margin: const EdgeInsets.only(bottom: 10),
                            padding: const EdgeInsets.symmetric(
                                vertical: 5, horizontal: 5),
                            decoration: const BoxDecoration(
                              color: mainScheme,
                              borderRadius: BorderRadius.all(
                                  Radius.circular(roundedCorner)),
                            ),
                            child: TextField(
                              maxLines: 1,
                              controller: _newPassword,
                              obscureText: true,
                              decoration: unfilledNewPassword
                                  ? invalidTextField.copyWith(
                                      hintText: 'Enter Password')
                                  : globalDecoration.copyWith(
                                      hintText: 'Enter Password'),
                              style: textFieldFontStyle,
                              onChanged: (password) {
                                if (password.isEmpty) {
                                  setState(() => unfilledNewPassword = true);
                                } else {
                                  setState(() => unfilledNewPassword = false);
                                }
                              },
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(top: 5),
                            child: const Text(
                              'Confirm Password',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.black,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Container(
                            width: 320,
                            padding: const EdgeInsets.symmetric(
                                vertical: 5, horizontal: 5),
                            decoration: const BoxDecoration(
                              color: mainScheme,
                              borderRadius: BorderRadius.all(
                                  Radius.circular(roundedCorner)),
                            ),
                            child: TextField(
                              maxLines: 1,
                              controller: _confirmPassword,
                              obscureText: true,
                              decoration: unfilledConfirmPassword
                                  ? invalidTextField.copyWith(
                                      hintText: 'Confirm Password')
                                  : globalDecoration.copyWith(
                                      hintText: 'Confirm Password'),
                              style: textFieldFontStyle,
                              onChanged: (password) {
                                if (validateConfirmPassword()) {
                                  setState(
                                      () => unfilledConfirmPassword = false);
                                }
                              },
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(bottom: 100),
                            child: Text(
                              errorMessage,
                              style: errorTextStyle.copyWith(fontSize: 14),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.all(15),
                            margin: const EdgeInsets.only(top: 170),
                            child: ElevatedButton(
                              onPressed: () async {
                                if (validateConfirmPassword()) {
                                  Map<String, dynamic> changes = {
                                    'email' : user.email,
                                    'firstName': user.firstName.trim(),
                                    'lastName': user.lastName.trim(),
                                    'lastSeen' : -1,
                                    'username': user.email.trim(),
                                    'password': _newPassword.value.text.trim(),
                                  };

                                  try {
                                    final res = await User.updateUser(changes);
                                    if (res.statusCode == 200) {
                                      user.password =
                                          _newPassword.value.text.trim();

                                      errorMessage =
                                          'Successfully updated your password!';
                                      await Future.delayed(
                                          const Duration(seconds: 1));

                                      clearFields();
                                      Navigator.pop(context);
                                    }
                                    errorMessage = await getChangePasswordError(
                                        res.statusCode);
                                    if (errorMessage ==
                                        'Successfully updated your password!') {
                                      user.password =
                                          _newPassword.value.text.trim();
                                      await Future.delayed(
                                          const Duration(seconds: 1));

                                      clearFields();
                                      Navigator.pop(context);
                                    }
                                    errorDialog(context);
                                  } catch (e) {
                                    print('Could not connect to server');
                                  }
                                } else {
                                  setState(() {});
                                }
                              },
                              style: buttonStyle,
                              child: const Text(
                                'Confirm Changes',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w300,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Container(
          height: 90,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            border: Border(
                top: BorderSide(color: Colors.black.withOpacity(.2), width: 3)),
            color: Colors.white,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    IconButton(
                      onPressed: () {
                        Navigator.restorablePushReplacementNamed(context, '/food');
                      },
                      icon: const Icon(Icons.egg),
                      iconSize: bottomIconSize,
                      color: mainScheme,
                    ),
                    Text(
                      'Ingredients',
                      style: bottomRowOnScreenTextStyle,
                      textAlign: TextAlign.center,
                    )
                  ],
                ),
              ),
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    IconButton(
                      onPressed: () {
                        Navigator.restorablePushReplacementNamed(context, '/recipe');
                      },
                      icon: const Icon(Icons.restaurant),
                      iconSize: bottomIconSize,
                      color: bottomRowIcon,
                    ),
                    Text(
                      'Recipes',
                      style: bottomRowIconTextStyle,
                      textAlign: TextAlign.center,
                    )
                  ],
                ),
              ),
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    IconButton(
                      onPressed: () {
                        Navigator.restorablePushReplacementNamed(context, '/cart');
                      },
                      icon: const Icon(Icons.shopping_cart),
                      iconSize: bottomIconSize,
                      color: bottomRowIcon,
                    ),
                    Text(
                      'Shopping Cart',
                      style: bottomRowIconTextStyle,
                      textAlign: TextAlign.center,
                    )
                  ],
                ),
              ),
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.person),
                      iconSize: bottomIconSize,
                      color: mainScheme,
                    ),
                    Text(
                      'User Profile',
                      style: bottomRowOnScreenTextStyle,
                      textAlign: TextAlign.center,
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool validateConfirmPassword() {
    bool toReturn = true;
    if (_oldPassword.value.text.isEmpty) {
      toReturn = false;
      unfilledOldPassword = true;
      errorMessage = 'Old Password required to change passwords';
    }
    if (_newPassword.value.text.isEmpty) {
      toReturn = false;
      unfilledNewPassword = true;
      errorMessage = 'New passwords must match';
    }
    if (_confirmPassword.value.text.isEmpty) {
      toReturn = false;
      unfilledConfirmPassword = true;
      errorMessage = 'New passwords must match';
    }
    if (!oldPasswordMatches()) {
      toReturn = false;
      unfilledOldPassword = true;
      errorMessage = 'Old password incorrect';
    }
    if (!newPasswordsMatches()) {
      toReturn = false;
      unfilledNewPassword = true;
      unfilledConfirmPassword = true;
      errorMessage = 'New passwords must match';
    }
    return toReturn;
  }

  bool oldPasswordMatches() {
    if (_oldPassword.value.text != user.password) {
      errorMessage = 'Passwords do not match';
      return false;
    }
    return true;
  }

  bool newPasswordsMatches() {
    if (_newPassword.value.text != _confirmPassword.value.text) {
      errorMessage = 'Passwords do not match';
      return false;
    }
    return true;
  }

  void clearFields() {
    unfilledOldPassword = false;
    unfilledNewPassword = false;
    unfilledConfirmPassword = false;
    _oldPassword.clear();
    _newPassword.clear();
    _confirmPassword.clear();
  }

  Future<String> getChangePasswordError(int statusCode) async {
    switch (statusCode) {
      case 400:
        return "Incorrect formatting!";
      case 401:
        return 'Access token missing';
      case 403:
        errorMessage = 'Reconnecting...';
        if (await tryTokenRefresh()) {
          return 'Successfully updated your password!';
        } else {
          return 'Cannot connect to server';
        }
      case 404:
        return 'User not found';
      default:
        return 'Something in edit password went wrong!';
    }
  }
}
