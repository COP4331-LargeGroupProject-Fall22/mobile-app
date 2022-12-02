import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:smart_chef/screens/LoadingOverlay.dart';
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
      behavior: HitTestBehavior.translucent,
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
                                    Navigator.restorablePushNamed(
                                        context, '/login');
                                  },
                                  style: buttonStyle,
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
                                    Navigator.restorablePushNamed(
                                        context, '/register');
                                  },
                                  style: buttonStyle,
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

  //TODO(30): Reset Password Functionality
  int state = 0;
  Widget detectState() {
    if (state == 1) {
      return buildForgot();
    } else {
      return buildLogIn();
    }
  }

  final _username = TextEditingController();
  bool unfilledUsername = false;

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
            behavior: HitTestBehavior.translucent,
            onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
            child: SingleChildScrollView(
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
                          color: textFieldBorder,
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
                      'Username',
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
                            controller: _username,
                            decoration: unfilledUsername
                                ? invalidTextField.copyWith(
                                    hintText: 'Enter Username')
                                : globalDecoration.copyWith(
                                    hintText: 'Enter Username'),
                            style: textFieldFontStyle,
                            onChanged: (username) {
                              if (username.isEmpty) {
                                setState(() => unfilledUsername = true);
                              } else {
                                setState(() => unfilledUsername = false);
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
                            style: textFieldFontStyle,
                            onChanged: (password) {
                              if (password.isEmpty) {
                                setState(() => unfilledPassword = true);
                              } else {
                                errorMessage = '';
                                setState(() => unfilledPassword = false);
                              }
                            },
                            onSubmitted: (sub) async {
                              bool logged = await runLogin();
                              if (logged) {
                                setState(() => clearFields());
                                Navigator.restorablePushNamedAndRemoveUntil(
                                    context, '/food', ((Route<dynamic> route) => false));
                              } else {
                                setState(() {
                                  unfilledUsername = true;
                                  unfilledPassword = true;
                                });
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
                        ElevatedButton(
                          onPressed: () async {
                            bool logged = await runLogin();
                            if (logged) {
                              setState(() => clearFields());
                              Navigator.restorablePushNamedAndRemoveUntil(
                                  context, '/food', ((Route<dynamic> route) => false));
                            } else {
                              setState(() {
                                unfilledUsername = true;
                                unfilledPassword = true;
                              });
                            }
                          },
                          style: buttonStyle,
                          child: const Text(
                            'Sign In',
                            style: TextStyle(
                                fontSize: 14,
                                color: Colors.white,
                                fontFamily: 'EagleLake'),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: TextButton(
                      style: TextButton.styleFrom(
                        textStyle: const TextStyle(
                          fontSize: 14,
                          color: textFieldBorder,
                          fontStyle: FontStyle.italic,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                      onPressed: () {
                        clearFields();
                        topMessage = 'Forgot Your\nPassword?';
                        errorMessage = '';
                        setState(() => state = 1);
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

  bool allLoginFieldsValid() {
    bool toReturn = true;
    if (_username.value.text.isEmpty) {
      toReturn = false;
      setState(() => unfilledUsername = true);
    }
    if (_password.value.text.isEmpty) {
      toReturn = false;
      setState(() => unfilledPassword = true);
    }
    return toReturn;
  }

  void clearFields() {
    unfilledUsername = false;
    unfilledPassword = false;
    unfilledCode = false;
    _username.clear();
    _password.clear();
    _code.clear();
  }

  Future<bool> runLogin() async {
    if (allLoginFieldsValid()) {
      Map<String, dynamic> payload = {
        'username': _username.value.text.trim(),
        'password': _password.value.text.trim()
      };

      try {
        final ret = await Authentication.login(payload);
        if (ret.statusCode == 200) {
          var tokens = json.decode(ret.body);
          user.defineTokens(tokens);

          return await retrieveUserData();
        } else {
          int errorCode = getLogInError(ret.statusCode);
          if (errorCode == 3) {
            user.username = _username.value.text.trim();
            showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: const Text('Account not verified'),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    elevation: 15,
                    actions: <Widget>[
                      TextButton(
                        onPressed: () {
                          user.username = _username.value.text;
                          Navigator.restorablePushReplacementNamed(
                              context, '/verification');
                        },
                        child: const Text(
                          'OK',
                          style: TextStyle(color: Colors.red, fontSize: 18),
                        ),
                      ),
                    ],
                    content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: const <Widget>[
                          Flexible(
                              child: Text(
                                  'Your account is not verified!\nPress OK to be taken to the verification page')),
                        ]),
                  );
                });
            return false;
          }
        }
      } catch (e) {
        errorMessage = 'Could not connect to server';
        print('Could not connect to /auth/user');
        return false;
      }
    }
    return false;
  }

  Future<bool> retrieveUserData() async {
    bool success = false;
    do {
      final res = await User.getUser();
      if (res.statusCode == 200) {
        var data = json.decode(res.body);
        user.defineUserData(data);
        user.setPassword(_password.value.text.trim());
        return true;
      } else {
        int errorCode = await getDataRetrieveError(res.statusCode);
        if (errorCode == 3) {
          errorDialog(context);
          return false;
        }
      }
    } while(!success);
  }

  int getLogInError(int statusCode) {
    switch (statusCode) {
      case 400:
        errorMessage = "Incorrect formatting!";
        return 1;
      case 401:
        errorMessage = 'Password is incorrect';
        return 2;
      case 403:
        errorMessage = 'Account not verified';
        return 3;
      case 404:
        errorMessage = 'User not found';
        return 4;
      default:
        return 5;
    }
  }

  Future<int> getDataRetrieveError(int statusCode) async {
    switch (statusCode) {
      case 400:
        errorMessage = "Incorrect formatting!";
        return 1;
      case 401:
        errorMessage = 'Reconnecting...';
        setState(() {});
        if (await tryTokenRefresh()) {
          errorMessage = 'Reconnected';
          return 2;
        } else {
          errorMessage = 'Could not connect to server!';

          return 3;
        }
      case 404:
        errorMessage = 'User not found';
        return 4;
      default:
        return 5;
    }
  }

  final _email = TextEditingController();
  bool unfilledEmail = false;
  bool codeSent = false;

  final _code = TextEditingController();
  bool unfilledCode = false;

  Widget buildForgot() {
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
                          color: textFieldBorder,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                      onPressed: () {
                        clearFields();
                        errorMessage = '';
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
                            readOnly: codeSent,
                            controller: _email,
                            decoration: unfilledEmail
                                ? invalidTextField.copyWith(
                                hintText: 'Enter Email')
                                : globalDecoration.copyWith(
                                hintText: 'Enter Email'),
                            style: textFieldFontStyle,
                            onChanged: (email) {
                              if (email.isEmpty) {
                                setState(() => unfilledUsername = true);
                              } else {
                                if (isEmail(email)) {
                                  errorMessage = '';
                                  setState(() => unfilledUsername = false);
                                } else {
                                  errorMessage =
                                  'Email must be in proper format';
                                  setState(() => unfilledUsername = true);
                                }
                              }
                            },
                            onSubmitted: (reset) async {
                              bool done = await sendResetCode();
                              if (done) {
                                setState(() => codeSent = true);
                              }
                            },
                            textInputAction: codeSent ? TextInputAction.next : TextInputAction.done,
                          ),
                        )
                      ],
                    ),
                  ),
                  if (codeSent)
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
                  if (codeSent)
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
                              style: textFieldFontStyle,
                              onChanged: (password) {
                                if (password.isEmpty) {
                                  setState(() => unfilledPassword = true);
                                } else {
                                  errorMessage = '';
                                  setState(() => unfilledPassword = false);
                                }
                              },
                              textInputAction: TextInputAction.next,
                            ),
                          ),
                        ],
                      ),
                    ),
                  if (codeSent)
                    Container(
                      width: 210,
                      padding: const EdgeInsets.only(top: 10),
                      child: const Text(
                        'Code',
                        style: TextStyle(
                            fontSize: 12,
                            color: Colors.white,
                            fontFamily: 'EagleLake'),
                        textAlign: TextAlign.left,
                      ),
                    ),
                  if (codeSent)
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
                              controller: _code,
                              obscureText: true,
                              decoration: unfilledCode
                                  ? invalidTextField.copyWith(
                                  hintText: 'Enter Code')
                                  : globalDecoration.copyWith(
                                  hintText: 'Enter Code'),
                              style: textFieldFontStyle,
                              onChanged: (code) {
                                if (code.isEmpty) {
                                  setState(() => unfilledCode = true);
                                } else {
                                  errorMessage = '';
                                  setState(() => unfilledCode = false);
                                }
                              },
                              onSubmitted: (sub) async {
                                bool logged = await resetPassword();
                                if (logged) {
                                  errorMessage = 'Password reset Successful!';
                                  await messageDelay;
                                  setState(() => clearFields());
                                  Navigator.pop(context);
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
                        ElevatedButton(
                          onPressed: () async {
                            if (codeSent) {
                              bool logged = await resetPassword();
                              if (logged) {
                                errorMessage = 'Password reset Successful!';
                                await messageDelay;
                                setState(() => clearFields());
                                Navigator.pop(context);
                              }
                            } else {
                              bool done = await sendResetCode();
                              if (done) {
                                setState(() => codeSent = true);
                              }
                            }

                          },
                          style: buttonStyle,
                          child: Text(
                            codeSent ? 'Reset Password' : 'Send Code',
                            style: const TextStyle(
                                fontSize: 14,
                                color: Colors.white,
                                fontFamily: 'EagleLake'),
                            textAlign: TextAlign.center,
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
    );
  }

  Future<bool> sendResetCode() async {
    if (validateEmail()) {
      Map<String, dynamic> payload = {
        'email': _email.value.text.trim(),
      };
      final ret = await Authentication.requestResetCode(payload);
      if (ret.statusCode == 200) {
        errorMessage = 'Code sent!';
        return true;
      } else {
        errorMessage = 'Account not found';
      }
    }
    return false;
  }

  bool validateEmail() {
    bool toRet = true;
    if (_email.value.text.isEmpty) {
      errorMessage = 'Email cannot be left blank';
      toRet = false;
    }
    if (!isEmail(_email.value.text)) {
      errorMessage = 'Email must be in valid form';
      toRet = false;
    }
    return toRet;
  }

  Future<bool> resetPassword() async {
    if (validateForgotFields()) {
      Map<String, dynamic> payload = {
        'email': _email.value.text.trim(),
        'password': _password.value.text.trim(),
        'code': int.parse(_code.value.text.trim()),
      };
      try {
        final ret = await Authentication.resetPassword(payload);
        if (ret.statusCode == 200) {
          return true;
        } else {
          return false;
        }
      } catch(e) {
        print(e.toString());
        throw Exception('Something went wrong');
      }
    } else return false;
  }

  bool validateForgotFields() {
    bool toRet = true;
    if (_code.text.isEmpty) {
      errorMessage = 'Code cannot be left blank';
      toRet = false;
    }
    if (_password.text.isEmpty) {
      errorMessage = 'Password cannot be left blank';
      toRet = false;
    }
    return toRet;
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

  final _firstName = TextEditingController();
  bool unfilledFirstName = false;

  final _lastName = TextEditingController();
  bool unfilledLastName = false;

  final _username = TextEditingController();
  bool unfilledUsername = false;

  final _email = TextEditingController();
  bool unfilledEmail = false;

  final _password = TextEditingController();
  bool unfilledPassword = false;

  String emailError = '';
  String errorMessage = '';
  String topMessage = 'Welcome\nTo SmartChef!';

  XFile? image;

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
          behavior: HitTestBehavior.translucent,
          onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
          child: SingleChildScrollView(
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 25),
                    padding: const EdgeInsets.all(8),
                    width: MediaQuery.of(context).size.width / 2,
                    height: MediaQuery.of(context).size.width / 2,
                    color: Colors.grey,
                    child: OutlinedButton(
                      onPressed: () async {
                        XFile? imageSrc = await _getImageFromGallery();
                        if (imageSrc != null) {
                          image = imageSrc;
                        }
                      },
                      child: image == null ? Center(
                        child: Column(
                          children: const <Widget>[
                            Icon(
                              Icons.upload,
                              size: bottomIconSize,
                              color: black,
                            ),
                            Flexible(
                              child: Text(
                                'Click to upload a profile image',
                                style: TextStyle(
                                  fontSize: 20,
                                  color: white,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                      ),
                      ) : Image.file(
                        File(image!.path),
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        padding: const EdgeInsets.all(10),
                        width: MediaQuery.of(context).size.width / 1.6,
                        height: MediaQuery.of(context).size.height / 1.5,
                        decoration: BoxDecoration(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(35)),
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
                                    color: textFieldBorder,
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
                                    style: textFieldFontStyle,
                                    onChanged: (firstName) {
                                      if (firstName.isEmpty) {
                                        setState(
                                            () => unfilledFirstName = true);
                                      } else {
                                        setState(
                                            () => unfilledFirstName = false);
                                      }
                                    },
                                    textInputAction: TextInputAction.next,
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              width: 210,
                              padding: const EdgeInsets.only(top: 2),
                              child: Text(
                                unfilledFirstName
                                    ? 'First Name cannot be left blank'
                                    : '',
                                style: errorTextStyle,
                                textAlign: TextAlign.left,
                              ),
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
                                        style: textFieldFontStyle,
                                        onChanged: (lastName) {
                                          if (lastName.isEmpty) {
                                            setState(
                                                () => unfilledLastName = true);
                                          } else {
                                            setState(
                                                () => unfilledLastName = false);
                                          }
                                        },
                                        textInputAction: TextInputAction.next,
                                      ))
                                ],
                              ),
                            ),
                            Container(
                              width: 210,
                              padding: const EdgeInsets.only(top: 2),
                              child: Text(
                                unfilledLastName
                                    ? 'Last Name cannot be left blank'
                                    : '',
                                style: errorTextStyle,
                                textAlign: TextAlign.left,
                              ),
                            ),
                            Container(
                              width: 210,
                              padding: const EdgeInsets.only(top: 5),
                              child: const Text(
                                'Username',
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
                                      maxLines: 1,
                                      controller: _username,
                                      obscureText: false,
                                      decoration: unfilledUsername
                                          ? invalidTextField.copyWith(
                                              hintText: 'Enter username')
                                          : globalDecoration.copyWith(
                                              hintText: 'Enter username'),
                                      style: textFieldFontStyle,
                                      onChanged: (username) {
                                        if (username.isEmpty) {
                                          setState(
                                              () => unfilledUsername = true);
                                        } else {
                                          setState(
                                              () => unfilledUsername = false);
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
                              padding: const EdgeInsets.only(top: 2),
                              child: Text(
                                unfilledUsername
                                    ? 'Username cannot be left blank'
                                    : '',
                                style: errorTextStyle,
                                textAlign: TextAlign.left,
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
                            Row(
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
                                    style: textFieldFontStyle,
                                    onChanged: (email) {
                                      if (!isEmail(email)) {
                                        emailError =
                                            'Email must be in valid form';
                                        setState(() => unfilledEmail = true);
                                      } else {
                                        setState(() => unfilledEmail = false);
                                        emailError = '';
                                      }
                                    },
                                    textInputAction: TextInputAction.next,
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              width: 210,
                              padding: const EdgeInsets.only(top: 2),
                              child: Text(
                                unfilledEmail ? emailError : '',
                                style: errorTextStyle,
                                textAlign: TextAlign.left,
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
                            Row(
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
                                    style: textFieldFontStyle,
                                    onChanged: (password) {
                                      setState(() => unfilledPassword = false);
                                    },
                                    textInputAction: TextInputAction.done,
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              width: 210,
                              padding: const EdgeInsets.only(top: 2),
                              child: Text(
                                unfilledPassword
                                    ? 'Password cannot be left blank'
                                    : '',
                                style: errorTextStyle,
                                textAlign: TextAlign.left,
                              ),
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width,
                              child: Text(
                                errorMessage,
                                style: const TextStyle(
                                    fontSize: 14, color: Colors.red),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.only(top: 5, bottom: 5),
                              width: MediaQuery.of(context).size.width,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  SizedBox(
                                    height: 36,
                                    child: ElevatedButton(
                                      onPressed: () async {
                                        if (allRegisterFieldsValid()) {
                                          try {
                                            Map<String, dynamic> payload = {
                                              'firstName':
                                                  _firstName.value.text.trim(),
                                              'lastName':
                                                  _lastName.value.text.trim(),
                                              'username':
                                                  _username.value.text.trim(),
                                              'password':
                                                  _password.value.text.trim(),
                                              'email': _email.value.text.trim(),
                                            };

                                            final ret =
                                                await Authentication.register(
                                                    payload);
                                            if (ret.statusCode == 200) {
                                              errorMessage = '';
                                              Map<String, dynamic> package = {
                                                'username':
                                                    _email.value.text.trim(),
                                              };
                                              final res =
                                                  await Authentication.sendCode(
                                                      package);
                                              if (res.statusCode == 200) {
                                                errorMessage = '';
                                                user.username =
                                                    _email.value.text;
                                                Navigator.restorablePushNamed(
                                                    context, '/verification');
                                              }
                                            } else {
                                              errorMessage = getErrorString(
                                                  ret.statusCode);
                                            }
                                          } catch (e) {
                                            print(
                                                'Could not connect to server');
                                          }
                                        }
                                        setState(() {});
                                      },
                                      style: buttonStyle,
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
                                    color: textFieldBorder,
                                    fontStyle: FontStyle.italic,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                                onPressed: () {
                                  clearFields();
                                  setState(() {
                                    Navigator.restorablePushReplacementNamed(
                                        context, '/login');
                                  });
                                },
                                child: Row(
                                  children: const <Widget>[
                                    Flexible(
                                      child: Text(
                                          'Have an account? Click to sign in'),
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
              ),
            ),
          ),
        ),
      ),
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
    if (_username.value.text.isEmpty) {
      toReturn = false;
      unfilledUsername = true;
    }
    if (_email.value.text.isEmpty) {
      toReturn = false;
      emailError = 'Email cannot be left blank';
      unfilledEmail = true;
    }
    if (_password.value.text.isEmpty) {
      toReturn = false;
      unfilledPassword = true;
    }
    if (!isEmail(_email.value.text)) {
      toReturn = false;
      emailError = 'Email must be in valid form';
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
        return 'Username already in use';
      default:
        return 'Something went wrong!';
    }
  }

  Future<XFile?> _getImageFromGallery() async {
    XFile? pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      return pickedFile;
    }
  }
}

class VerificationPage extends StatefulWidget {
  @override
  _VerificationPageState createState() => _VerificationPageState();
}

class _VerificationPageState extends State<VerificationPage> {
  @override
  void initState() {
    super.initState();
  }

  String errorMessage = '';

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
          behavior: HitTestBehavior.translucent,
          onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
          child: SingleChildScrollView(
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: TextButton(
                      style: TextButton.styleFrom(
                        textStyle: const TextStyle(
                          fontSize: 18,
                          color: textFieldBorder,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
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
                            'Please check your email for your validation code and enter that code below:',
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
                          fontSize: 12,
                          color: Colors.white,
                          fontFamily: 'EagleLake'),
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
                            maxLines: 1,
                            controller: _code,
                            obscureText: false,
                            decoration: unfilledCode
                                ? invalidTextField.copyWith(
                                    hintText: 'Enter Code')
                                : globalDecoration.copyWith(
                                    hintText: 'Enter Code'),
                            onChanged: (code) {
                              if (code.isEmpty) {
                                setState(() => unfilledCode = true);
                              } else {
                                setState(() => unfilledCode = false);
                              }
                            },
                            textInputAction: TextInputAction.next,
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
                  SizedBox(
                    height: 36,
                    child: ElevatedButton(
                      onPressed: () async {
                        if (_code.value.text.isEmpty) {
                          errorMessage = 'Code cannot be left blank!';
                          setState(() => unfilledCode = true);
                        } else {
                          Map<String, dynamic> payload = {
                            'username': user.username.trim(),
                            'code':
                                int.parse(_code.value.text.trim())
                          };

                          try {
                            final res =
                                await Authentication.verifyCode(payload);

                            if (res.statusCode == 200) {
                              errorMessage = 'Account successfully created!';
                              await Future.delayed(const Duration(seconds: 1));
                              clearFields();

                              Navigator.restorablePushReplacementNamed(
                                  context, '/login');
                            } else {
                              String message = json.decode(res.body);
                              if (message == "Verification code is either expired or not issued.") {
                                print('res.body');
                                Map<String, dynamic> name = {
                                  'username': user.username,
                                };
                                final ret = await Authentication.sendCode(name);
                              }
                              errorMessage =
                                  verifyCodeErrorString(res.statusCode);
                            }
                          } catch (e) {
                            print('Could not connect to server');
                          }
                        }
                        setState(() {});
                      },
                      style: buttonStyle,
                      child: const Text(
                        'Send Code',
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
          ),
        ),
      ),
    );
  }

  bool codeFieldsValid() {
    if (_code.value.text.isEmpty) {
      errorMessage = 'Code cannot be left blank';
      unfilledCode = true;
      return false;
    }
    return true;
  }

  void clearFields() {
    unfilledCode = false;
    _code.clear();
  }

  String verifyCodeErrorString(int statusCode) {
    switch (statusCode) {
      case 400:
        return "Verification code is invalid!";
      case 401:
        return "Verification code expired! Sending new one!";
      default:
        return 'Could not send code.';
    }
  }
}
