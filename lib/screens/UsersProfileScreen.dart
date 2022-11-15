import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:smart_chef/utils/APIutils.dart';
import 'package:smart_chef/utils/colors.dart';
import 'package:smart_chef/utils/userAPI.dart';
import 'package:smart_chef/utils/authAPI.dart';
import 'package:http/http.dart' as http;

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
          onPressed: () async{
            //TODO Finish registration verification once API is done
            try {
              final response = await Authentication.logout();
              switch (response.statusCode) {
                case 200:
                  setState(() {
                    errorMessage = 'Logout successful!';
                  });
                  await Future.delayed(Duration(seconds: 1));
                  user.clear();

                  Navigator.pushNamedAndRemoveUntil(context,
                      '/startup', ((Route<dynamic> route) => false));
                  break;
                case 400:
                  print("Could not logout");
                  break;
                case 401:
                  print('Access Token missing');
                  break;
                default:
                  print('Something went wrong!');
                  break;
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
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
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
                      children: <Widget>[
                        Flexible(child: const Text('Are you sure you want to delete your account?')),
                      ]
                    ),
                  );
                },
              );

              if (!delete) {
                return;
              }

              user.clear();

              try {
                final response = await User.deleteUser();
                switch (response.statusCode) {
                  case 200:
                    user.accessToken = '';
                    user.refreshToken = '';

                    Navigator.pushNamedAndRemoveUntil(context,
                        '/startup', ((Route<dynamic> route) => false));
                    break;
                  case 400:
                    print("Incorrect request format");
                    break;
                  case 401:
                    print('Access Token missing');
                    break;
                  case 404:
                    errorMessage = "User wasn't found";
                    break;
                  default:
                    print('Something went wrong!');
                    break;
                }

                //jsonObject = json.decode(ret.body);
              }
              catch (e) {
                print('Could not connect to server');
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
                                  user.firstName,
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
                                  user.lastName,
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
                              user.email,
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
                          style: const TextStyle(fontSize: 20, color: Colors.red),
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
                                  Navigator.pushNamed(context, '/user/changePassword');
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
                          style:
                              TextStyle(fontSize: 12, color: bottomRowIcon),
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

  final globalDecoration = InputDecoration(
      contentPadding: const EdgeInsets.fromLTRB(5, 1, 5, 1),
      filled: true,
      fillColor: textFieldBacking,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Color(0xff47A1E2)),
      ));

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
                                  borderRadius: BorderRadius.all(Radius.circular(10)),
                                ),
                                child: TextField(
                                  maxLines: 1,
                                  controller: _firstName,
                                  decoration: unfilledFirstName
                                      ? globalDecoration.copyWith(
                                      enabledBorder: const OutlineInputBorder(
                                          borderSide:
                                          BorderSide(color: Colors.red)),
                                      suffixIcon: const Icon(Icons.clear,
                                          color: Colors.red),
                                      hintText: 'Enter First Name')
                                      : globalDecoration.copyWith(hintText: 'Enter First Name'),
                                  style: const TextStyle(
                                    fontSize: 20,
                                    color: Colors.black,
                                  ),
                                  onChanged: (firstName) {
                                    if (firstName.isEmpty) {
                                      setState(() => unfilledFirstName = true);
                                    }
                                    else {
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
                                  borderRadius: BorderRadius.all(Radius.circular(10)),
                                ),
                                child: TextField(
                                  maxLines: 1,
                                  controller: _lastName,
                                  decoration: unfilledLastName
                                      ? globalDecoration.copyWith(
                                      enabledBorder: const OutlineInputBorder(
                                          borderSide:
                                          BorderSide(color: Colors.red)),
                                      suffixIcon: const Icon(Icons.clear,
                                          color: Colors.red),
                                      hintText: 'Enter Last Name')
                                      : globalDecoration.copyWith(hintText: 'Enter Last Name'),
                                  style: const TextStyle(
                                    fontSize: 20,
                                    color: Colors.black,
                                  ),
                                  textAlign: TextAlign.left,
                                  textInputAction: TextInputAction.next,
                                  onChanged: (lastName) {
                                    if (lastName.isEmpty) {
                                      setState(() => unfilledLastName = true);
                                    }
                                    else {
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
                                  ? globalDecoration.copyWith(
                                  enabledBorder: const OutlineInputBorder(
                                      borderSide:
                                      BorderSide(color: Colors.red)),
                                  suffixIcon: const Icon(Icons.clear,
                                      color: Colors.red),
                                  hintText: 'Enter Email')
                                  : globalDecoration.copyWith(hintText: 'Enter Email'),
                              style: const TextStyle(
                                fontSize: 20,
                                color: Colors.black,
                              ),
                              textAlign: TextAlign.left,
                              onChanged: (email) {
                                if (!isEmail(email)) {
                                  errorMessage = 'Email must be in valid form';
                                  setState(() => unfilledEmail = true);
                                }
                                else {
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
                                  ? globalDecoration.copyWith(
                                  enabledBorder: const OutlineInputBorder(
                                      borderSide:
                                      BorderSide(color: Colors.red)),
                                  suffixIcon: const Icon(Icons.clear,
                                      color: Colors.red),
                                  hintText: 'Enter Password')
                                  : globalDecoration.copyWith(hintText: 'Enter Password'),
                              style: const TextStyle(
                                fontSize: 20,
                                color: Colors.black,
                              ),
                              textAlign: TextAlign.left,
                              textInputAction: TextInputAction.next,
                              onChanged: (password) {
                                if (password.isEmpty) {
                                  setState(() => unfilledPassword = true);
                                }
                                else {
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
                                  ? globalDecoration.copyWith(
                                  enabledBorder: const OutlineInputBorder(
                                      borderSide:
                                      BorderSide(color: Colors.red)),
                                  suffixIcon: const Icon(Icons.clear,
                                      color: Colors.red),
                                  hintText: 'Confirm Password')
                                  : globalDecoration.copyWith(hintText: 'Confirm Password'),
                              style: const TextStyle(
                                fontSize: 20,
                                color: Colors.black,
                              ),
                              textAlign: TextAlign.left,
                              textInputAction: TextInputAction.done,
                              onChanged: (password) {
                                if (password.isEmpty) {
                                  setState(() => unfilledConfirmPassword = true);
                                }
                                else {
                                  if (_password.value.text.isEmpty) {
                                    errorMessage = 'Passwords must match!';
                                  }
                                  else if (passwordsMatch()) {
                                    errorMessage = '';
                                    unfilledConfirmPassword = false;
                                  }
                                  setState(() {});
                                }
                              },
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(bottom: 20),
                            child: Text(
                              errorMessage,
                              style: const TextStyle(fontSize: 14, color: Colors.red),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Container(
                            width: 180,
                            //padding: EdgeInsets.all(15),
                            child: ElevatedButton(
                              onPressed: () async {
                                if (areFieldsValid()) {
                                  if (passwordsMatch()) {
                                    String firstName = _firstName.value.text.trim();
                                    String lastName = _lastName.value.text.trim();
                                    String username = _email.value.text.trim();
                                    String changes = '{"firstname": "$firstName","lastname": "$lastName","lastSeen": ${user
                                        .lastSeen}"username": "$username","password": "${user
                                        .password}"}';
                                    try {
                                      final response = await User.updateUser(changes);
                                      if (await status(response)) {
                                        user.firstName = firstName;
                                        user.email = username;
                                        user.lastName = lastName;
                                        Navigator.pop(context);
                                      }
                                    }
                                    catch(e) {
                                      print('Could not connect to server');
                                    }
                                  }
                                  else {
                                    setState(() {
                                      unfilledConfirmPassword = true;
                                      unfilledPassword = true;
                                    });
                                  }
                                }
                                else {
                                  setState(() {});
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                backgroundColor: mainScheme,
                                //padding: const EdgeInsets.all(2),
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
                          style:
                          TextStyle(fontSize: 12, color: bottomRowIcon),
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

  bool areFieldsValid() {
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
      errorMessage = 'Passwords do not match';
      return false;
    }
    return true;
  }

  void clearFields() {
    unfilledEmail = false;
    unfilledPassword = false;
    _email.clear();
    _password.clear();
  }

  Future<bool> status(http.Response res) async {
    bool accepted = true;
    while (accepted) {
      switch (res.statusCode) {
        case 200:
          return true;
        case 400:
          print("Incorrect formatting!");
          return false;
        case 401:
          errorMessage = 'Access token missing';
          return false;
        case 403:
          final changeToken = await Authentication.refreshToken();
          if (refreshTokenStatus(changeToken)) {
            var tokens = json.decode(changeToken.body);
            user.accessToken = tokens['accessToken'];
            user.refreshToken = tokens['refreshToken'];
          }
          else {
            print('something went wrong!');
            return false;
          }
          break;
        case 404:
          errorMessage = 'User not found';
          return false;
        default:
          print('Something in edit profile went wrong!');
          return false;
      }
    }
  }

  bool refreshTokenStatus(http.Response changeToken) {
    switch (changeToken.statusCode) {
      case 200:
        return true;
      case 400:
        errorMessage = 'Could not refresh tokens';
        return false;
      case 401:
        errorMessage = 'Token missing';
        return false;
      case 404:
        errorMessage = 'User not found';
        return false;
      default:
        print('Something went wrong!');
        return false;
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

  final globalDecoration = InputDecoration(
      contentPadding: const EdgeInsets.fromLTRB(5, 1, 5, 1),
      filled: true,
      fillColor: textFieldBacking,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Color(0xff47A1E2)),
      ));

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
            width: MediaQuery
                .of(context)
                .size
                .width,
            height: MediaQuery
                .of(context)
                .size
                .height,
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
                                  ? globalDecoration.copyWith(
                                  enabledBorder: const OutlineInputBorder(
                                      borderSide:
                                      BorderSide(color: Colors.red)),
                                  suffixIcon: const Icon(Icons.clear,
                                      color: Colors.red),
                                  hintText: 'Enter Old Password')
                                  : globalDecoration.copyWith(
                                  hintText: 'Enter Old Password'),
                              onChanged: (password) {
                                if (_oldPassword.text.isEmpty) {
                                  errorMessage = 'Old password required to change password';
                                  setState(() => unfilledOldPassword = true);
                                }
                                else {
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
                                  ? globalDecoration.copyWith(
                                  enabledBorder: const OutlineInputBorder(
                                      borderSide:
                                      BorderSide(color: Colors.red)),
                                  suffixIcon: const Icon(Icons.clear,
                                      color: Colors.red),
                                  hintText: 'Enter Password')
                                  : globalDecoration.copyWith(
                                  hintText: 'Enter Password'),
                              onChanged: (password) {
                                if (password.isEmpty) {
                                  setState(() => unfilledNewPassword = true);
                                }
                                else {
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
                                  ? globalDecoration.copyWith(
                                  enabledBorder: const OutlineInputBorder(
                                      borderSide:
                                      BorderSide(color: Colors.red)),
                                  suffixIcon: const Icon(Icons.clear,
                                      color: Colors.red),
                                  hintText: 'Confirm Password')
                                  : globalDecoration.copyWith(
                                  hintText: 'Confirm Password'),
                              onChanged: (password) {
                                if (password.isEmpty) {
                                  setState(() =>
                                  unfilledConfirmPassword = true);
                                }
                                else {
                                  if (_newPassword.value.text.isEmpty |
                                  (_newPassword.value.text != password)) {
                                    errorMessage = 'Passwords must match!';
                                  }
                                  else {
                                    errorMessage = '';
                                    setState(() => unfilledConfirmPassword = false);
                                  }
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
                                if (_oldPassword.value.text.isEmpty |
                                _newPassword.value.text.isEmpty |
                                _confirmPassword.value.text.isEmpty) {
                                  if (_oldPassword.value.text.isEmpty) {
                                    setState(() => unfilledOldPassword = true);
                                  }
                                  if (_newPassword.value.text.isEmpty) {
                                    setState(() => unfilledNewPassword = true);
                                  }
                                  if (_confirmPassword.value.text.isEmpty) {
                                    setState(() =>
                                    unfilledConfirmPassword = true);
                                  }
                                } else {
                                  if (_oldPassword.value.text !=
                                      user.password) {
                                    errorMessage = 'Old Password is incorrect';
                                    setState(() {
                                      unfilledConfirmPassword = true;
                                    });
                                  }
                                  else {
                                    String newPassword = _newPassword.value.text.trim();
                                    String changes = '{"firstname": "${user.firstName}","lastname": "${user.lastName}","lastSeen": ${user
                                        .lastSeen}"username": "${user.email}","password": "$newPassword"}';
                                    try {
                                      final response = await User.updateUser(changes);

                                      bool accepted = false;
                                      while (!accepted) {
                                        switch (response.statusCode) {
                                          case 200:
                                            accepted = true;
                                            Navigator.pop(context);
                                            break;
                                          case 400:
                                            print("Incorrect formatting!");
                                            break;
                                          case 401:
                                            errorMessage =
                                            'Access token missing';
                                            break;
                                          case 403:
                                            final changeToken = await Authentication.refreshToken();
                                            switch (changeToken.statusCode) {
                                              case 200:
                                                var tokens = json.decode(
                                                    changeToken.body);
                                                user.accessToken =
                                                tokens['accessToken'];
                                                user.refreshToken =
                                                tokens['refreshToken'];
                                                break;
                                              case 400:
                                                errorMessage =
                                                'Could not refresh tokens';
                                                break;
                                              case 401:
                                                errorMessage = 'Token missing';
                                                break;
                                              case 404:
                                                errorMessage = 'User not found';
                                                break;
                                            }
                                            break;
                                          case 404:
                                            errorMessage = 'User not found';
                                            break;
                                          default:
                                            print(
                                                'Something in edit profile went wrong!');
                                            break;
                                        }
                                      }
                                    }
                                    catch (e) {
                                      print('Could not connect to server');
                                    }
                                  }
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                backgroundColor: mainScheme,
                                //padding: const EdgeInsets.all(2),
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
          width: MediaQuery
              .of(context)
              .size
              .width,
          decoration: BoxDecoration(
            border: Border(
                top: BorderSide(color: Colors.black.withOpacity(.2), width: 3)),
            color: Colors.white,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                  width: MediaQuery
                      .of(context)
                      .size
                      .width / 4,
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
                          style:
                          TextStyle(fontSize: 12, color: bottomRowIcon),
                          textAlign: TextAlign.center,
                        )
                      ])),
              SizedBox(
                width: MediaQuery
                    .of(context)
                    .size
                    .width / 4,
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
                width: MediaQuery
                    .of(context)
                    .size
                    .width / 4,
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
                width: MediaQuery
                    .of(context)
                    .size
                    .width / 4,
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
}
