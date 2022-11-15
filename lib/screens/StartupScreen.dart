import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'package:smart_chef/utils/APIutils.dart';
import 'package:smart_chef/utils/colors.dart';
import 'package:smart_chef/utils/userData.dart';
import 'package:smart_chef/utils/authAPI.dart';
import 'package:http/http.dart' as http;

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
                                    Navigator.pushNamed(context, '/signin');
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

class SignInPage extends StatefulWidget {
  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  @override
  void initState() {
    super.initState();
  }

  int state = 0;
  Widget detectState() {
    if (state == 1) {
      return buildForgot();
    } else {
      return buildSignIn();
    }
  }

  final generalDecoration = InputDecoration(
    contentPadding: const EdgeInsets.fromLTRB(5, 1, 5, 1),
    filled: true,
    fillColor: const Color(0xffD1D1D1),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(color: Color(0xff47A1E2)),
    ),
  );

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

  Widget buildSignIn() {
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
                          color: Color(0xff47A1E2),
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
                                ? generalDecoration.copyWith(
                                    enabledBorder: const OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.red)),
                                    suffixIcon: const Icon(Icons.clear,
                                        color: Colors.red),
                                    hintText: 'Enter Email',
                                  )
                                : generalDecoration.copyWith(hintText: 'Enter Email'),
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
                                ? generalDecoration.copyWith(
                                    enabledBorder: const OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.red)),
                                    suffixIcon: const Icon(Icons.clear,
                                        color: Colors.red),
                                      hintText: 'Enter Email')
                                : generalDecoration.copyWith(hintText: 'Enter Email'),
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
                    padding: const EdgeInsets.only(top: 10, bottom: 10),
                    width: MediaQuery.of(context).size.width,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        SizedBox(
                          width: 85,
                          child: ElevatedButton(
                            onPressed: () async {
                              if (areFieldsValid(true)) {
                                String username = _email.value.text.trim();
                                String password = _password.value.text.trim();
                                setState(() => clearFields());

                                try {
                                  String payload = '{"username": "$username","password": "$password"}';
                                  final ret = await Authentication.login(payload);
                                  if (status(ret)) {
                                    var data = json.decode(ret.body);
                                    user = UserData(
                                      firstName: data['userInfo']['firstName'],
                                      lastName: data['userInfo']['lastName'],
                                      email: data['userInfo']['username'],
                                      lastSeen: data['userInfo']['lastSeen'],
                                      accessToken: data["accessToken"],
                                      refreshToken: data["refreshToken"],
                                      password: password,
                                    );

                                    Navigator.pushNamedAndRemoveUntil(context,
                                        '/food', ((Route<dynamic> route) => false));
                                  }
                                }
                                catch(e) {
                                  errorMessage = 'Could not connect to server';
                                  print('Could not connect to /auth/user');
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
                          color: Color(0xff47A1E2),
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
                color: Color(0xff47A1E2),
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
                        ? generalDecoration.copyWith(
                            enabledBorder: const OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.red)),
                            suffixIcon:
                                const Icon(Icons.clear, color: Colors.red))
                        : generalDecoration,
                    onChanged: (email) {
                      setState(() => unfilledEmail = false);
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
                if (areFieldsValid(false)) {
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

  bool areFieldsValid(bool hasPassword) {
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

  bool status(http.Response res) {
    switch (res.statusCode) {
      case 200:
        return true;
      case 400:
        print("Incorrect formatting!");
        return false;
      case 401:
        errorMessage = 'Account not verified';
        return false;
      case 403:
        errorMessage = 'Email/password incorrect';
        setState(() {
          unfilledPassword = true;
          unfilledEmail = true;
        });
        return false;
      default:
        print('Something in auth went wrong!');
        return false;
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

  final globalDecoration = InputDecoration(
      contentPadding: const EdgeInsets.fromLTRB(5, 1, 5, 1),
      filled: true,
      fillColor: const Color(0xffD1D1D1),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Color(0xff47A1E2)),
      ));

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
          margin: EdgeInsets.only(
              top: 5, bottom: 50),
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
                          color: Color(0xff47A1E2),
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
                              ? globalDecoration.copyWith(
                              enabledBorder: const OutlineInputBorder(
                                  borderSide:
                                  BorderSide(color: Colors.red)),
                              suffixIcon: const Icon(Icons.clear,
                                  color: Colors.red),
                              hintText: 'Enter First Name')
                              : globalDecoration.copyWith(hintText: 'Enter First Name'),
                          onChanged: (firstName) {
                            if (firstName.isEmpty) {
                              setState(() => unfilledFirstName = true);
                            }
                            else {
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
                                  ? globalDecoration.copyWith(
                                  enabledBorder: const OutlineInputBorder(
                                      borderSide:
                                      BorderSide(color: Colors.red)),
                                  suffixIcon: const Icon(Icons.clear,
                                      color: Colors.red),
                                  hintText: 'Enter Last Name')
                                  : globalDecoration.copyWith(hintText: 'Enter Last Name'),
                              onChanged: (lastName) {
                                if (lastName.isEmpty) {
                                  setState(() => unfilledLastName = true);
                                }
                                else {
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
                                ? globalDecoration.copyWith(
                                enabledBorder: const OutlineInputBorder(
                                    borderSide:
                                    BorderSide(color: Colors.red)),
                                suffixIcon: const Icon(Icons.clear,
                                    color: Colors.red),
                                hintText: 'Enter Email')
                                : globalDecoration.copyWith(hintText: 'Enter Email'),
                            onChanged: (email) {
                              if (!isEmail(email)) {
                                errorMessage = 'Email must be in valid form';
                                setState(() => unfilledEmail = true);
                              }
                              else {
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
                                ? globalDecoration.copyWith(
                                enabledBorder: const OutlineInputBorder(
                                    borderSide:
                                    BorderSide(color: Colors.red)),
                                suffixIcon: const Icon(Icons.clear,
                                    color: Colors.red),
                                hintText: 'Enter Password')
                                : globalDecoration.copyWith(hintText: 'Enter Password'),
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
                              if (areFieldsValid()) {
                                String username = _email.value.text.trim();
                                String password = _password.value.text.trim();
                                String firstName = _firstName.value.text.trim();
                                String lastName = _lastName.value.text.trim();

                                try {

                                  String payload = '{"firstName": "$firstName","lastName": "$lastName","username": "$username","password": "$password"}';
                                  final ret = await Authentication.register(payload);
                                  if (status(ret)) {
                                    var data = json.decode(ret.body);
                                    user = UserData(
                                      firstName: data['userInfo']['firstName'],
                                      lastName: data['userInfo']['lastName'],
                                      email: data['userInfo']['username'],
                                      lastSeen: data['userInfo']['lastSeen'],
                                      accessToken: data["accessToken"],
                                      refreshToken: data["refreshToken"],
                                      password: password,
                                    );

                                      errorMessage = '';
                                      clearFields();
                                      //TODO Add support for verifying registered email
                                      /*setState(() {
                                        state = 1;
                                      });*/
                                      Navigator.pushNamedAndRemoveUntil(context,
                                          '/food', ((Route<dynamic> route) => false));
                                  }
                                }
                                catch (e) {
                                  print('Could not connect to server');
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
                          color: Color(0xff47A1E2),
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
                                'Already a user? Click here to sign in instead'),
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
                color: Color(0xff47A1E2),
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
                            borderSide:
                            BorderSide(color: Colors.red)),
                        suffixIcon: const Icon(Icons.clear,
                            color: Colors.red),
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
            onPressed: () {
              setState(() {
                if (_code.value.text.isEmpty) {
                  setState(() => unfilledCode = true);
                } else {
                  _code.clear();
                  setState(() {
                    Navigator.pushNamedAndRemoveUntil(
                        context, '/food', (Route<dynamic> route) => false);
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

  bool status(http.Response res) {
    switch (res.statusCode) {
      case 200:
        return true;
      case 400:
        print("Incorrect formatting!");
        return false;
      case 401:
        errorMessage = 'Access token is missing or invalid';
        return false;
      case 404:
        errorMessage = 'Email/password incorrect';
        return false;
      default:
        errorMessage = 'Something went wrong!';
        return false;
    }
  }
}
