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
              bool delete = false;
              showDialog(
                context: context,
                barrierDismissible: true,
                builder: (context) {
                  return AlertDialog(
                    title: const Text('Deleting your account?'),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    elevation: 15,
                    actions: <Widget>[
                      TextButton(
                        onPressed: () {
                          delete = true;
                          Navigator.pop(context, 'Cancel');
                        },
                        child: const Text(
                          'Cancel',
                          style: TextStyle(color: Colors.red, fontSize: 18),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          delete = true;
                          Navigator.pop(context, 'delete');
                        },
                        child: const Text(
                          'Delete my account',
                          style: TextStyle(color: Colors.red, fontSize: 18),
                        ),
                      )
                    ],
                    content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: const <Widget>[
                          Flexible(
                              child: Text(
                                  'Are you sure you want to delete your account?')),
                        ]),
                  );
                },
              );

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
                          Column(
                            children: <Widget>[
                              Container(
                                child: const Text(
                                  'First Name',
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.black,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              Container(
                                width: 150,
                                margin: const EdgeInsets.only(right: 10),
                                padding: const EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 5),
                                decoration: const BoxDecoration(
                                  color: mainScheme,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                ),
                                child: Text(
                                  user.firstName.isEmpty ? '' : user.firstName,
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
                                child: const Text(
                                  'Last Name',
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.black,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              Container(
                                width: 150,
                                margin: const EdgeInsets.only(left: 10),
                                padding: const EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 5),
                                decoration: const BoxDecoration(
                                  color: mainScheme,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
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
                            width: 320,
                            margin: const EdgeInsets.only(bottom: 100),
                            padding: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 5),
                            decoration: const BoxDecoration(
                              color: mainScheme,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
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
                      Container(
                        child: Text(
                          errorMessage,
                          style:
                              const TextStyle(fontSize: 20, color: Colors.red),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            width: 180,
                            padding: const EdgeInsets.all(15),
                            child: ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  Navigator.pushNamed(context, '/user/edit');
                                });
                              },
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                backgroundColor: mainScheme,
                                padding: const EdgeInsets.all(2),
                                shadowColor: Colors.black,
                              ),
                              child: const Text(
                                'Edit Information',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w300,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                          Container(
                            width: 180,
                            padding: const EdgeInsets.all(15),
                            child: ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  Navigator.pushNamed(
                                      context, '/user/changePassword');
                                });
                              },
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                backgroundColor: mainScheme,
                                padding: const EdgeInsets.all(2),
                                shadowColor: Colors.black,
                              ),
                              child: const Text(
                                'Change Password',
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
              SizedBox(
                  width: MediaQuery.of(context).size.width / 4,
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        IconButton(
                          onPressed: () {
                            Navigator.pushReplacementNamed(context, '/food');
                          },
                          icon: const Icon(Icons.egg),
                          iconSize: 55,
                          color: bottomRowIcon,
                        ),
                        const Text(
                          'Ingredients',
                          style: TextStyle(fontSize: 12, color: bottomRowIcon),
                          textAlign: TextAlign.center,
                        )
                      ])),
              SizedBox(
                width: MediaQuery.of(context).size.width / 4,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    IconButton(
                      onPressed: () {
                        Navigator.pushReplacementNamed(context, '/recipe');
                      },
                      icon: const Icon(Icons.restaurant),
                      color: bottomRowIcon,
                      iconSize: 55,
                    ),
                    const Text(
                      'Recipes',
                      style: TextStyle(fontSize: 12, color: bottomRowIcon),
                      textAlign: TextAlign.right,
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width / 4,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    IconButton(
                      onPressed: () {
                        Navigator.pushReplacementNamed(context, '/cart');
                      },
                      icon: const Icon(Icons.shopping_cart),
                      iconSize: 55,
                      color: bottomRowIcon,
                    ),
                    const Text(
                      'Shopping Cart',
                      style: TextStyle(fontSize: 12, color: bottomRowIcon),
                      textAlign: TextAlign.center,
                    )
                  ],
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width / 4,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.person),
                      iconSize: 55,
                      color: mainScheme,
                    ),
                    const Text(
                      'User Profile',
                      style: TextStyle(fontSize: 12, color: mainScheme),
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
    _email.text = user.email;
    super.initState();
  }

  final _email = TextEditingController();
  bool unfilledEmail = false;

  final _password = TextEditingController();
  bool unfilledPassword = false;

  final _confirmPassword = TextEditingController();
  bool unfilledConfirmPassword = false;

  final _firstName = TextEditingController();
  bool unfilledFirstName = false;

  final _lastName = TextEditingController();
  bool unfilledLastName = false;

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
                              Container(
                                child: const Text(
                                  'First Name',
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.black,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              Container(
                                width: 150,
                                margin: const EdgeInsets.only(right: 10),
                                padding: const EdgeInsets.symmetric(
                                    vertical: 5, horizontal: 5),
                                decoration: const BoxDecoration(
                                  color: mainScheme,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                ),
                                child: TextField(
                                  maxLines: 1,
                                  controller: _firstName,
                                  decoration: unfilledFirstName
                                      ? invalidTextField.copyWith(
                                          hintText: 'Enter First Name')
                                      : globalDecoration.copyWith(
                                          hintText: 'Enter First Name'),
                                  style: const TextStyle(
                                    fontSize: 20,
                                    color: Colors.black,
                                  ),
                                  onChanged: (firstName) {
                                    if (firstName.isEmpty) {
                                      setState(() => unfilledFirstName = true);
                                    } else {
                                      unfilledFirstName = false;
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
                              Container(
                                child: const Text(
                                  'Last Name',
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.black,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              Container(
                                width: 150,
                                margin: const EdgeInsets.only(left: 10),
                                padding: const EdgeInsets.symmetric(
                                    vertical: 5, horizontal: 5),
                                decoration: const BoxDecoration(
                                  color: mainScheme,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                ),
                                child: TextField(
                                  maxLines: 1,
                                  controller: _lastName,
                                  decoration: unfilledLastName
                                      ? invalidTextField.copyWith(
                                          hintText: 'Enter Last Name')
                                      : globalDecoration.copyWith(
                                          hintText: 'Enter Last Name'),
                                  style: const TextStyle(
                                    fontSize: 20,
                                    color: Colors.black,
                                  ),
                                  textAlign: TextAlign.left,
                                  textInputAction: TextInputAction.next,
                                  onChanged: (lastName) {
                                    if (lastName.isEmpty) {
                                      setState(() => unfilledLastName = true);
                                    } else {
                                      unfilledLastName = false;
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
                              'Email',
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
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                            ),
                            child: TextField(
                              maxLines: 1,
                              controller: _email,
                              decoration: unfilledEmail
                                  ? invalidTextField.copyWith(
                                  hintText: 'Enter Email')
                                  : globalDecoration.copyWith(
                                      hintText: 'Enter Email'),
                              style: const TextStyle(
                                fontSize: 20,
                                color: Colors.black,
                              ),
                              textAlign: TextAlign.left,
                              onChanged: (email) {
                                if (!isEmail(email)) {
                                  errorMessage = 'Email must be in valid form';
                                  setState(() => unfilledEmail = true);
                                } else {
                                  errorMessage = '';
                                  setState(() => unfilledEmail = false);
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
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
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
                              style: const TextStyle(
                                fontSize: 20,
                                color: Colors.black,
                              ),
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
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
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
                              style: const TextStyle(
                                fontSize: 20,
                                color: Colors.black,
                              ),
                              textAlign: TextAlign.left,
                              textInputAction: TextInputAction.done,
                              onChanged: (password) {
                                if (validatePassword(password)) {
                                  unfilledConfirmPassword = false;
                                } else {
                                  errorMessage = 'Passwords must match!';
                                  unfilledConfirmPassword = true;
                                }
                                setState(() {});
                              },
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(bottom: 20),
                            child: Text(
                              errorMessage,
                              style: const TextStyle(
                                  fontSize: 14, color: Colors.red),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Container(
                            width: 180,
                            child: ElevatedButton(
                              onPressed: () async {
                                if (allEditProfileFieldsValid()) {
                                  if (passwordsMatch()) {

                                    Map<String, dynamic> changes = {
                                      'firstName': _firstName.value.text.trim(),
                                      'lastName': _lastName.value.text.trim(),
                                      'username': _email.value.text.trim(),
                                      'password': user.password,
                                    };

                                    try {
                                      final res =
                                          await User.updateUser(changes);
                                      if (res.statusCode == 200) {
                                        user.firstName = _firstName.value.text.trim();
                                        user.lastName = _lastName.value.text.trim();
                                        user.email = _email.value.text.trim();

                                        errorMessage ==
                                            'Successfully updated your profile!';
                                        await Future.delayed(Duration(seconds: 1));

                                        clearFields();
                                        Navigator.pop(context);
                                      } else {
                                        errorMessage = await getUpdateProfileError(res.statusCode);
                                        if (errorMessage ==
                                            'Successfully updated your profile!') {
                                          user.firstName = _firstName.value.text.trim();
                                          user.lastName = _lastName.value.text.trim();
                                          user.email = _email.value.text.trim();

                                          await Future.delayed(Duration(seconds: 1));

                                          clearFields();
                                          Navigator.pop(context);
                                        } else {
                                          errorDialog(context);
                                        }
                                      }
                                    } catch (e) {
                                      print('Could not connect to server');
                                    }
                                  } else {
                                    setState(() {});
                                  }
                                } else {
                                  setState(() {});
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                backgroundColor: mainScheme,
                                shadowColor: Colors.black,
                              ),
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
              SizedBox(
                  width: MediaQuery.of(context).size.width / 4,
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        IconButton(
                          onPressed: () {
                            Navigator.pushReplacementNamed(context, '/food');
                          },
                          icon: Icon(Icons.egg),
                          iconSize: 55,
                          color: bottomRowIcon,
                        ),
                        const Text(
                          'Ingredients',
                          style: TextStyle(fontSize: 12, color: bottomRowIcon),
                          textAlign: TextAlign.center,
                        )
                      ])),
              SizedBox(
                width: MediaQuery.of(context).size.width / 4,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    IconButton(
                      onPressed: () {
                        Navigator.pushReplacementNamed(context, '/recipe');
                      },
                      icon: Icon(Icons.restaurant),
                      color: bottomRowIcon,
                      iconSize: 55,
                    ),
                    const Text(
                      'Recipes',
                      style: TextStyle(fontSize: 12, color: bottomRowIcon),
                      textAlign: TextAlign.right,
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width / 4,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    IconButton(
                      onPressed: () {
                        Navigator.pushReplacementNamed(context, '/cart');
                      },
                      icon: Icon(Icons.shopping_cart),
                      iconSize: 55,
                      color: bottomRowIcon,
                    ),
                    const Text(
                      'Shopping Cart',
                      style: TextStyle(fontSize: 12, color: bottomRowIcon),
                      textAlign: TextAlign.center,
                    )
                  ],
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width / 4,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    IconButton(
                      onPressed: () {},
                      icon: Icon(Icons.person),
                      iconSize: 55,
                      color: mainScheme,
                    ),
                    const Text(
                      'User Profile',
                      style: TextStyle(fontSize: 12, color: mainScheme),
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
    if (_email.value.text.isEmpty) {
      toReturn = false;
      unfilledEmail = true;
    }
    if (_password.value.text.isEmpty) {
      toReturn = false;
      unfilledPassword = true;
    }
    if (_confirmPassword.value.text.isEmpty) {
      toReturn = false;
      unfilledConfirmPassword = true;
    }
    if (!isEmail(_email.value.text)) {
      toReturn = false;
      errorMessage = 'Email must be in valid form';
      unfilledEmail = true;
    }
    return toReturn;
  }

  bool passwordsMatch() {
    if (_password.value.text != user.password) {
      errorMessage = 'Password is incorrect';
      return false;
    }
    return true;
  }

  void clearFields() {
    unfilledFirstName = false;
    unfilledLastName = false;
    unfilledEmail = false;
    unfilledPassword = false;
    unfilledConfirmPassword = false;
    _firstName.clear();
    _lastName.clear();
    _email.clear();
    _password.clear();
    _confirmPassword.clear();
  }

  Future<String> getUpdateProfileError(int statusCode) async {
    switch (statusCode) {
      case 400:
        return "Incorrect formatting!";
      case 401:
        return 'Access token missing';
      case 403:
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
          icon: Icon(
            Icons.navigate_before,
            color: Colors.black,
          ),
          iconSize: 35,
        ),
      ),
      body: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: SingleChildScrollView(
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(color: Colors.white),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(top: 20),
                  alignment: Alignment.topCenter,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Column(
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.only(top: 15),
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
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                            ),
                            child: TextField(
                              maxLines: 1,
                              controller: _oldPassword,
                              decoration: unfilledOldPassword
                                  ? invalidTextField.copyWith(
                                      hintText: 'Enter Old Password')
                                  : globalDecoration.copyWith(
                                      hintText: 'Enter Old Password'),
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
                            margin: EdgeInsets.only(top: 15),
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
                            margin: EdgeInsets.only(bottom: 10),
                            padding: EdgeInsets.symmetric(
                                vertical: 5, horizontal: 5),
                            decoration: BoxDecoration(
                              color: mainScheme,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
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
                            margin: EdgeInsets.only(top: 5),
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
                            padding: EdgeInsets.symmetric(
                                vertical: 5, horizontal: 5),
                            decoration: BoxDecoration(
                              color: mainScheme,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
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
                              onChanged: (password) {
                                if (validateConfirmPassword()) {
                                  setState(
                                      () => unfilledConfirmPassword = false);
                                }
                              },
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(bottom: 100),
                            child: Text(
                              errorMessage,
                              style: const TextStyle(
                                  fontSize: 14, color: Colors.red),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.all(15),
                            margin: EdgeInsets.only(top: 170),
                            child: ElevatedButton(
                              onPressed: () async {
                                if (validateConfirmPassword()) {

                                  Map<String, dynamic> changes = {
                                    'firstName': user.firstName.trim(),
                                    'lastName': user.lastName.trim(),
                                    'username': user.email.trim(),
                                    'password': _newPassword.value.text.trim(),
                                  };

                                  try {
                                    final res =
                                        await User.updateUser(changes);
                                    if (res.statusCode == 200) {
                                      user.password = _newPassword.value.text.trim();

                                      errorMessage ==
                                          'Successfully updated your password!';
                                      await Future.delayed(Duration(seconds: 1));

                                      clearFields();
                                      Navigator.pop(context);
                                    } else {
                                      errorMessage =
                                          await getChangePasswordError(
                                              res.statusCode);
                                      if (errorMessage ==
                                          'Successfully changed password!') {
                                        user.password = _newPassword.value.text.trim();
                                        await Future.delayed(Duration(seconds: 1));

                                        clearFields();
                                        Navigator.pop(context);
                                      } else {
                                        errorDialog(context);
                                      }
                                    }
                                  } catch (e) {
                                    print('Could not connect to server');
                                  }
                                } else {
                                  setState(() {});
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                backgroundColor: mainScheme,
                                shadowColor: Colors.black,
                              ),
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
              SizedBox(
                  width: MediaQuery.of(context).size.width / 4,
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        IconButton(
                          onPressed: () {
                            Navigator.pushReplacementNamed(context, '/food');
                          },
                          icon: Icon(Icons.egg),
                          iconSize: 55,
                          color: bottomRowIcon,
                        ),
                        const Text(
                          'Ingredients',
                          style: TextStyle(fontSize: 12, color: bottomRowIcon),
                          textAlign: TextAlign.center,
                        )
                      ])),
              SizedBox(
                width: MediaQuery.of(context).size.width / 4,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    IconButton(
                      onPressed: () {
                        Navigator.pushReplacementNamed(context, '/recipe');
                      },
                      icon: Icon(Icons.restaurant),
                      color: bottomRowIcon,
                      iconSize: 55,
                    ),
                    const Text(
                      'Recipes',
                      style: TextStyle(fontSize: 12, color: bottomRowIcon),
                      textAlign: TextAlign.right,
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width / 4,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    IconButton(
                      onPressed: () {
                        Navigator.pushReplacementNamed(context, '/cart');
                      },
                      icon: Icon(Icons.shopping_cart),
                      iconSize: 55,
                      color: bottomRowIcon,
                    ),
                    const Text(
                      'Shopping Cart',
                      style: TextStyle(fontSize: 12, color: bottomRowIcon),
                      textAlign: TextAlign.center,
                    )
                  ],
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width / 4,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    IconButton(
                      onPressed: () {},
                      icon: Icon(Icons.person),
                      iconSize: 55,
                      color: mainScheme,
                    ),
                    const Text(
                      'User Profile',
                      style: TextStyle(fontSize: 12, color: mainScheme),
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
