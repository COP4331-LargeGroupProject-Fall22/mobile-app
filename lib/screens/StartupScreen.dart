import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:smart_chef/utils/APIutils.dart';
import 'package:smart_chef/utils/authAPI.dart';
import 'package:smart_chef/utils/colors.dart';
import 'package:smart_chef/utils/globals.dart';
import 'package:smart_chef/utils/userAPI.dart';
import 'package:smart_chef/utils/userData.dart';

class StartupScreen extends StatefulWidget {
  @override
  _StartupState createState() => _StartupState();
}

class _StartupState extends State<StartupScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/Background.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Scaffold(
          backgroundColor: Colors.black.withOpacity(.35),
          body: StartPage(),
        ));
  }
}

class StartPage extends StatefulWidget {
  @override
  _StartPageState createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: SingleChildScrollView(
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(
                    top: (MediaQuery.of(context).size.height / 7), bottom: 50),
                padding: const EdgeInsets.all(8),
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(35)),
                    color: Colors.black.withOpacity(.45)),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Text(
                    'Welcome to\nSmartChef!',
                    style: const TextStyle(
                        fontSize: 48,
                        color: Colors.white,
                        fontFamily: 'EagleLake'),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    padding: const EdgeInsets.all(10),
                    width: MediaQuery.of(context).size.width / 1.6,
                    height: MediaQuery.of(context).size.height / 2.3,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(35)),
                      color: Colors.black.withOpacity(.45),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          padding: const EdgeInsets.only(top: 75),
                          width: MediaQuery.of(context).size.width,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              SizedBox(
                                width: MediaQuery.of(context).size.width / 2,
                                child: ElevatedButton(
                                  onPressed: () {
                                    Navigator.pushNamed(context, '/login');
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
                                    'Sign in',
                                    style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.white,
                                        fontFamily: 'EagleLake'),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.only(top: 25),
                          width: MediaQuery.of(context).size.width,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              SizedBox(
                                width: MediaQuery.of(context).size.width / 2,
                                child: ElevatedButton(
                                  onPressed: () {
                                    Navigator.pushNamed(context, '/register');
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
                                    'Register',
                                    style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.white,
                                        fontFamily: 'EagleLake'),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class LogInPage extends StatefulWidget {
  @override
  _LogInPageState createState() => _LogInPageState();
}

class _LogInPageState extends State<LogInPage> {
  @override
  void initState() {
    super.initState();
  }

  int state = 0;
  Widget detectState() {
    if (state == 1) {
      return buildForgot();
    } else {
      return buildLogIn();
    }
  }

  final _email = TextEditingController();
  bool unfilledEmail = false;

  final _password = TextEditingController();
  bool unfilledPassword = false;

  String errorMessage = '';
  String topMessage = 'Welcome\nBack!';

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/Background.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.black.withOpacity(.35),
        body: GestureDetector(
          onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
          child: SingleChildScrollView(
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(
                        top: (MediaQuery.of(context).size.height / 7),
                        bottom: 50),
                    padding: const EdgeInsets.all(8),
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(35)),
                        color: Colors.black.withOpacity(.45)),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: Text(
                        topMessage,
                        style: const TextStyle(
                            fontSize: 48,
                            color: Colors.white,
                            fontFamily: 'EagleLake'),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  detectState(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildLogIn() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              padding: const EdgeInsets.all(10),
              width: MediaQuery.of(context).size.width / 1.6,
              height: MediaQuery.of(context).size.height / 2.3,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(35)),
                color: Colors.black.withOpacity(.45),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: TextButton(
                      style: TextButton.styleFrom(
                        textStyle: const TextStyle(
                          fontSize: 18,
                          color: startScreenTextBacking,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                      onPressed: () {
                        clearFields();
                        setState(() {
                          Navigator.pop(context);
                        });
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const <Widget>[
                          Icon(
                            Icons.navigate_before,
                          ),
                          Text('Go Back'),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    width: 210,
                    padding: const EdgeInsets.only(top: 15),
                    child: const Text(
                      'Email',
                      style: TextStyle(
                          fontSize: 12,
                          color: Colors.white,
                          fontFamily: 'EagleLake'),
                      textAlign: TextAlign.left,
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        SizedBox(
                          width: 210,
                          height: 40,
                          child: TextField(
                            maxLines: 1,
                            controller: _email,
                            decoration: unfilledEmail
                                ? invalidTextField.copyWith(
                                hintText: 'Enter Email')
                                : globalDecoration.copyWith(
                                    hintText: 'Enter Email'),
                            onChanged: (email) {
                              if (!isEmail(email)) {
                                errorMessage = 'Email must be in valid form';
                                setState(() => unfilledEmail = true);
                              } else {
                                if (email.isEmpty) {
                                  setState(() => unfilledEmail = true);
                                } else {
                                  errorMessage = '';
                                  setState(() => unfilledEmail = false);
                                }
                              }
                            },
                            textInputAction: TextInputAction.next,
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(
                    width: 210,
                    padding: const EdgeInsets.only(top: 10),
                    child: const Text(
                      'Password',
                      style: TextStyle(
                          fontSize: 12,
                          color: Colors.white,
                          fontFamily: 'EagleLake'),
                      textAlign: TextAlign.left,
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        SizedBox(
                          width: 210,
                          height: 40,
                          child: TextField(
                            maxLines: 1,
                            controller: _password,
                            obscureText: true,
                            decoration: unfilledPassword
                                ? invalidTextField.copyWith(
                                hintText: 'Enter Password')
                                : globalDecoration.copyWith(
                                    hintText: 'Enter Password'),
                            onChanged: (password) {
                              if (password.isEmpty) {
                                setState(() => unfilledPassword = true);
                              } else {
                                errorMessage = '';
                                setState(() => unfilledPassword = false);
                              }
                            },
                            textInputAction: TextInputAction.done,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: Text(
                      errorMessage,
                      style: const TextStyle(fontSize: 14, color: Colors.red),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.only(top: 10, bottom: 10),
                    width: MediaQuery.of(context).size.width,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        SizedBox(
                          width: 85,
                          child: ElevatedButton(
                            onPressed: () async {
                              /*if (allLoginFieldsValid(true)) {
                                String username = _email.value.text.trim();
                                String password = _password.value.text.trim();

                                try {
                                  String payload = '{"username": "$username","password": "$password"}';
                                  final ret = await Authentication.login(payload);
                                  if (ret.statusCode == 200) {
                                    setState(() => clearFields());
                                    var tokens = json.decode(ret.body);
                                    user = UserData.defineTokens(tokens);

                                    final res = await User.getUser();
                                    if (res.statusCode == 200) {
                                      var data = json.decode(res.body);
                                      user.defineUserData(data);
                                      Navigator.pushNamedAndRemoveUntil(context,
                                        '/food', ((Route<dynamic> route) => false));
                                    } else {
                                      errorMessage = getDataRetrieveError(res.statusCode);
                                    }
                                  } else {
                                    errorMessage = getLogInError(ret.statusCode);
                                  }
                                }
                                catch(e) {
                                  errorMessage = 'Could not connect to server';
                                  print('Could not connect to /auth/user');
                                }
                              }
                              else {
                                setState(() {});
                              }*/
                              Navigator.pushNamedAndRemoveUntil(context,
                                  '/food', ((Route<dynamic> route) => false));
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
                              'Sign In',
                              style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.white,
                                  fontFamily: 'EagleLake'),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: TextButton(
                      style: TextButton.styleFrom(
                        textStyle: const TextStyle(
                          fontSize: 14,
                          color: startScreenTextBacking,
                          fontStyle: FontStyle.italic,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                      onPressed: () {
                        clearFields();
                        topMessage = 'Forgot Your\nPassword?';
                        setState(() {
                          state = 1;
                        });
                      },
                      child: const Text('Forgot Your Password?'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget buildForgot() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        SizedBox(
          width: MediaQuery.of(context).size.width,
          child: TextButton(
            style: TextButton.styleFrom(
              textStyle: const TextStyle(
                fontSize: 18,
                color: startScreenTextBacking,
                decoration: TextDecoration.underline,
              ),
            ),
            onPressed: () {
              topMessage = "Welcome\nBack!";
              setState(
                () {
                  state = 0;
                },
              );
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const <Widget>[
                Icon(
                  Icons.navigate_before,
                ),
                Text('Go Back'),
              ],
            ),
          ),
        ),
        Container(
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.only(top: 15),
          child: Row(
            children: <Widget>[
              Flexible(
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(35)),
                    color: Colors.black.withOpacity(.45),
                  ),
                  child: const Text(
                    'Please enter your email.\nA reset password link will be sent to it if an account is attached to it',
                    style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontFamily: 'EagleLake'),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
        ),
        Container(
          width: 210,
          padding: const EdgeInsets.only(top: 15),
          child: const Text(
            'Email',
            style: TextStyle(
                fontSize: 12, color: Colors.white, fontFamily: 'EagleLake'),
            textAlign: TextAlign.left,
          ),
        ),
        Container(
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.only(bottom: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                  width: 210,
                  height: 40,
                  child: TextField(
                    controller: _email,
                    maxLines: 1,
                    obscureText: false,
                    decoration: unfilledEmail
                        ? invalidTextField.copyWith(
                        hintText: 'Enter Email')
                        : globalDecoration.copyWith(
                        hintText: 'Enter Email'),
                    onChanged: (email) {
                      if (email.isEmpty) {
                        setState(() => unfilledEmail = true);
                      } else {
                        if (!isEmail(email)) {
                          errorMessage = 'Email must be in valid form!';
                          setState(() => unfilledEmail = true);
                        } else {
                          errorMessage = '';
                          setState(() => unfilledEmail = false);
                        }
                      }
                    },
                  ))
            ],
          ),
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Text(
            errorMessage,
            style: const TextStyle(fontSize: 14, color: Colors.red),
            textAlign: TextAlign.center,
          ),
        ),
        SizedBox(
          width: 100,
          height: 36,
          child: ElevatedButton(
            onPressed: () {
              setState(() {
                if (allLoginFieldsValid(false)) {
                  //TODO Add support for reseting password
                  setState(() {
                    _email.clear();
                  });
                }
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
              'Send Code',
              style: TextStyle(
                  fontSize: 14, color: Colors.white, fontFamily: 'EagleLake'),
              textAlign: TextAlign.center,
            ),
          ),
        )
      ],
    );
  }

  bool allLoginFieldsValid(bool hasPassword) {
    bool toReturn = true;
    if (_email.value.text.isEmpty) {
      toReturn = false;
      setState(() => unfilledEmail = true);
    }
    if (hasPassword & _password.value.text.isEmpty) {
      toReturn = false;
      setState(() => unfilledPassword = true);
    }
    if (!isEmail(_email.value.text)) {
      toReturn = false;
      errorMessage = 'Email must be in valid form';
      setState(() => unfilledEmail = true);
    }
    return toReturn;
  }

  void clearFields() {
    unfilledEmail = false;
    unfilledPassword = false;
    _email.clear();
    _password.clear();
  }

  String getLogInError(int statusCode) {
    switch (statusCode) {
      case 400:
        return "Incorrect formatting!";
      case 401:
        return 'Account not verified';
      case 403:
        setState(() {
          unfilledPassword = true;
          unfilledEmail = true;
        });
        return 'Email/password incorrect';
      default:
        return 'Something in auth went wrong!';
    }
  }

  String getDataRetrieveError(int statusCode) {
    switch (statusCode) {
      case 400:
        return "Incorrect formatting!";
      case 401:
        return 'Token is invalid';
      case 404:
        return 'User Not Found';
      default:
        return 'Something in auth went wrong!';
    }
  }
}

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  @override
  void initState() {
    super.initState();
  }

  int state = 0;
  Widget detectState() {
    if (state == 1) {
      return buildVerification();
    } else {
      return buildRegister();
    }
  }

  final _email = TextEditingController();
  bool unfilledEmail = false;

  final _password = TextEditingController();
  bool unfilledPassword = false;

  final _firstName = TextEditingController();
  bool unfilledFirstName = false;

  final _lastName = TextEditingController();
  bool unfilledLastName = false;

  String errorMessage = '';
  String topMessage = 'Welcome\nTo SmartChef!';

  final _code = TextEditingController();
  bool unfilledCode = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/Background.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.black.withOpacity(.35),
        body: GestureDetector(
          onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
          child: SingleChildScrollView(
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: detectState(),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildRegister() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(top: 5, bottom: 50),
          padding: const EdgeInsets.all(8),
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(35)),
              color: Colors.black.withOpacity(.45)),
          child: Text(
            topMessage,
            style: const TextStyle(
                fontSize: 48, color: Colors.white, fontFamily: 'EagleLake'),
            textAlign: TextAlign.center,
          ),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              padding: const EdgeInsets.all(10),
              width: MediaQuery.of(context).size.width / 1.6,
              height: MediaQuery.of(context).size.height / 1.95,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(35)),
                color: Colors.black.withOpacity(.45),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: TextButton(
                      style: TextButton.styleFrom(
                        textStyle: const TextStyle(
                          fontSize: 18,
                          color: startScreenTextBacking,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                      onPressed: () {
                        clearFields();
                        setState(
                          () {
                            Navigator.pop(context);
                          },
                        );
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const <Widget>[
                          Icon(
                            Icons.navigate_before,
                          ),
                          Text('Go Back'),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    width: 210,
                    padding: const EdgeInsets.only(top: 5),
                    child: const Text(
                      'First Name',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white,
                        fontFamily: 'EagleLake',
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(
                        width: 210,
                        height: 40,
                        child: TextField(
                          maxLines: 1,
                          controller: _firstName,
                          obscureText: false,
                          decoration: unfilledFirstName
                              ? invalidTextField.copyWith(
                                  hintText: 'Enter First Name')
                              : globalDecoration.copyWith(
                                  hintText: 'Enter First Name'),
                          onChanged: (firstName) {
                            if (firstName.isEmpty) {
                              setState(() => unfilledFirstName = true);
                            } else {
                              unfilledFirstName = false;
                            }
                          },
                          textInputAction: TextInputAction.next,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    width: 210,
                    padding: const EdgeInsets.only(top: 5),
                    child: const Text(
                      'Last Name',
                      style: TextStyle(
                          fontSize: 12,
                          color: Colors.white,
                          fontFamily: 'EagleLake'),
                      textAlign: TextAlign.left,
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        SizedBox(
                            width: 210,
                            height: 40,
                            child: TextField(
                              maxLines: 1,
                              controller: _lastName,
                              obscureText: false,
                              decoration: unfilledLastName
                                  ? invalidTextField.copyWith(
                                      hintText: 'Enter Last Name')
                                  : globalDecoration.copyWith(
                                      hintText: 'Enter Last Name'),
                              onChanged: (lastName) {
                                if (lastName.isEmpty) {
                                  setState(() => unfilledLastName = true);
                                } else {
                                  unfilledLastName = false;
                                }
                              },
                              textInputAction: TextInputAction.next,
                            ))
                      ],
                    ),
                  ),
                  Container(
                    width: 210,
                    padding: const EdgeInsets.only(top: 5),
                    child: const Text(
                      'Email',
                      style: TextStyle(
                          fontSize: 12,
                          color: Colors.white,
                          fontFamily: 'EagleLake'),
                      textAlign: TextAlign.left,
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        SizedBox(
                          width: 210,
                          height: 40,
                          child: TextField(
                            controller: _email,
                            maxLines: 1,
                            obscureText: false,
                            decoration: unfilledEmail
                                ? invalidTextField.copyWith(
                                    hintText: 'Enter Email')
                                : globalDecoration.copyWith(
                                    hintText: 'Enter Email'),
                            onChanged: (email) {
                              if (!isEmail(email)) {
                                errorMessage = 'Email must be in valid form';
                                setState(() => unfilledEmail = true);
                              } else {
                                setState(() => unfilledEmail = false);
                                errorMessage = '';
                              }
                            },
                            textInputAction: TextInputAction.next,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 210,
                    padding: const EdgeInsets.only(top: 5),
                    child: const Text(
                      'Password',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white,
                        fontFamily: 'EagleLake',
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        SizedBox(
                          width: 210,
                          height: 40,
                          child: TextField(
                            controller: _password,
                            maxLines: 1,
                            obscureText: true,
                            decoration: unfilledPassword
                                ? invalidTextField.copyWith(
                                    hintText: 'Enter Password')
                                : globalDecoration.copyWith(
                                    hintText: 'Enter Password'),
                            onChanged: (password) {
                              setState(() => unfilledPassword = false);
                            },
                            textInputAction: TextInputAction.done,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: Text(
                      errorMessage,
                      style: const TextStyle(fontSize: 14, color: Colors.red),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.only(top: 10, bottom: 5),
                    width: MediaQuery.of(context).size.width,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        SizedBox(
                          width: 85,
                          height: 36,
                          child: ElevatedButton(
                            onPressed: () async {
                              if (allRegisterFieldsValid()) {
                                try {
                                  Map<String, dynamic> payload = {
                                    'firstName': _firstName.value.text.trim(),
                                    'lastName': _lastName.value.text.trim(),
                                    'username': _email.value.text.trim(),
                                    'password': _password.value.text.trim(),
                                  };

                                  final ret =
                                      await Authentication.register(payload);
                                  if (ret.statusCode == 200) {
                                    errorMessage = '';
                                    Map<String, dynamic> package = {
                                      'username': _email.value.text.trim(),
                                    };
                                    final res =
                                        await Authentication.sendCode(package);
                                    if (res.statusCode == 200) {
                                      errorMessage = '';
                                      _code.clear();
                                      setState(() {
                                        state = 1;
                                      });
                                    }
                                  } else {
                                    errorMessage =
                                        getErrorString(ret.statusCode);
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
                              padding: const EdgeInsets.all(2),
                              shadowColor: Colors.black,
                            ),
                            child: const Text(
                              'Register',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.white,
                                fontFamily: 'EagleLake',
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: TextButton(
                      style: TextButton.styleFrom(
                        textStyle: const TextStyle(
                          fontSize: 14,
                          color: startScreenTextBacking,
                          fontStyle: FontStyle.italic,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                      onPressed: () {
                        clearFields();
                        setState(() {
                          Navigator.pushReplacementNamed(context, '/signin');
                        });
                      },
                      child: Row(
                        children: <Widget>[
                          Flexible(
                            child: Text(
                                'Already have an account? Click here to sign in instead'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget buildVerification() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        SizedBox(
          width: MediaQuery.of(context).size.width,
          child: TextButton(
            style: TextButton.styleFrom(
              textStyle: const TextStyle(
                fontSize: 18,
                color: startScreenTextBacking,
                decoration: TextDecoration.underline,
              ),
            ),
            onPressed: () {
              setState(() => state = 0);
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const <Widget>[
                Icon(
                  Icons.navigate_before,
                ),
                Text('Go Back'),
              ],
            ),
          ),
        ),
        Container(
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.only(top: 15),
          child: Row(
            children: const <Widget>[
              Flexible(
                child: Text(
                  'Please check your email for the validation code and enter that code below:',
                  style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontFamily: 'EagleLake'),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
        Container(
          width: 210,
          padding: const EdgeInsets.only(top: 15),
          child: const Text(
            'Code',
            style: TextStyle(
                fontSize: 12, color: Colors.white, fontFamily: 'EagleLake'),
            textAlign: TextAlign.left,
          ),
        ),
        Container(
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.only(bottom: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                  width: 210,
                  height: 40,
                  child: TextField(
                    controller: _code,
                    maxLines: 1,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r''))
                    ],
                    decoration: unfilledCode
                        ? globalDecoration.copyWith(
                            enabledBorder: const OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.red)),
                            suffixIcon:
                                const Icon(Icons.clear, color: Colors.red),
                            hintText: 'Enter Code')
                        : globalDecoration.copyWith(hintText: 'Enter Code'),
                    onChanged: (code) {
                      setState(() => unfilledCode = false);
                    },
                  ))
            ],
          ),
        ),
        SizedBox(
          width: 100,
          height: 36,
          child: ElevatedButton(
            onPressed: () async {
              if (_code.value.text.isEmpty) {
                errorMessage = 'Code cannot be left blank!';
                setState(() => unfilledCode = true);
              } else {
                Map<String, dynamic> payload = {
                  'username': _email.value.text.trim(),
                  'code': _code.value.text.trim()
                };

                try {
                  final res = await Authentication.verifyCode(payload);

                  if (res.statusCode == 200) {
                    var data = json.decode(res.body);
                    user.defineUserData(data);
                    clearFields();

                    Navigator.pushNamedAndRemoveUntil(
                        context, '/food', (Route<dynamic> route) => false);
                  } else {
                    errorMessage = verifyCodeErrorString(res.statusCode);
                  }
                } catch (e) {
                  print('Could not connect to server');
                }
              }
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
              'Send Code',
              style: TextStyle(
                  fontSize: 14, color: Colors.white, fontFamily: 'EagleLake'),
              textAlign: TextAlign.center,
            ),
          ),
        )
      ],
    );
  }

  bool allRegisterFieldsValid() {
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
    if (!isEmail(_email.value.text)) {
      toReturn = false;
      errorMessage = 'Email must be in valid form';
      unfilledEmail = true;
    }
    return toReturn;
  }

  void clearFields() {
    unfilledEmail = false;
    unfilledPassword = false;
    unfilledFirstName = false;
    unfilledLastName = false;
    _email.clear();
    _password.clear();
    _firstName.clear();
    _lastName.clear();
  }

  String getErrorString(int statusCode) {
    switch (statusCode) {
      case 400:
        return "Email already exists!";
      default:
        return 'Something went wrong!';
    }
  }

  String verifyCodeErrorString(int statusCode) {
    switch (statusCode) {
      case 400:
        return "Verification code is invalid!";
      default:
        return 'Something went wrong!';
    }
  }
}
