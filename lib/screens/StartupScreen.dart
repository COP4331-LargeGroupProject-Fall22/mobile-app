import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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

  String introMessage = 'Welcome to\nSmartChef!';
  String errorMessage = '';

  int state = 0;
  bool isEmail(email) {
    RegExp emailValidation = RegExp(r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');
    return emailValidation.hasMatch(email);
  }

  Widget detectState() {
    if (state == 1) {
      return buildSignInPage();
    } else if (state == 2) {
      return buildRegisterPage();
    } else if (state == 3) {
      return buildForgotPasswordPage();
    } else if (state == 4) {
      return buildVerificationPage();
    } else {
      return buildStartPage();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: SingleChildScrollView(
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Center(
            child: Column(
              children: <Widget>[
                Row(
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
                          introMessage,
                          style: const TextStyle(
                              fontSize: 48,
                              color: Colors.white,
                              fontFamily: 'EagleLake'),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      padding: const EdgeInsets.all(10),
                      width: MediaQuery.of(context).size.width / 1.6,
                      height: MediaQuery.of(context).size.height / 2.3,
                      decoration: BoxDecoration(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(35)),
                        color: Colors.black.withOpacity(.45),
                      ),
                      child: detectState(),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildStartPage() {
    return Column(
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
                    setState(() {
                      state = 1;
                      introMessage = 'Welcome\nBack!';
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    backgroundColor: const Color(0xff008600),
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
                    setState(() {
                      state = 2;
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    backgroundColor: const Color(0xff008600),
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
    );
  }

  final _email = TextEditingController();
  final emailDecoration = InputDecoration(
      contentPadding: const EdgeInsets.fromLTRB(5, 1, 5, 1),
      filled: true,
      fillColor: const Color(0xffD1D1D1),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Color(0xff47A1E2)),
      ),
      hintText: 'Enter Email',
      );
  bool unfilledEmail = false;

  final _password = TextEditingController();
  final passwordDecoration = InputDecoration(
      contentPadding: const EdgeInsets.fromLTRB(5, 1, 5, 1),
      filled: true,
      fillColor: const Color(0xffD1D1D1),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Color(0xff47A1E2)),
      ),
      hintText: 'Enter Password');
  bool unfilledPassword = false;

  Widget buildSignInPage() {
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
              unfilledPassword = false;
              unfilledEmail = false;
              _email.clear();
              _password.clear();
              errorMessage = '';
              setState(
                () {
                  state = 0;
                  introMessage = 'Welcome To\nSmartChef!';
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
          padding: const EdgeInsets.only(top: 15),
          child: const Text(
            'Email',
            style: TextStyle(
                fontSize: 12, color: Colors.white, fontFamily: 'EagleLake'),
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
                      ? emailDecoration.copyWith(
                          enabledBorder: const OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.red)),
                          suffixIcon:
                              const Icon(Icons.clear, color: Colors.red),
                  )
                      : emailDecoration,
                  onChanged: (email) {
                    setState(() => unfilledEmail = false);
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
                fontSize: 12, color: Colors.white, fontFamily: 'EagleLake'),
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
                        ? passwordDecoration.copyWith(
                            enabledBorder: const OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.red)),
                            suffixIcon:
                                const Icon(Icons.clear, color: Colors.red))
                        : passwordDecoration,
                    onChanged: (password) {
                      setState(() => unfilledPassword = false);
                    },
                    textInputAction: TextInputAction.go,
                  ))
            ],
          ),
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Text(
              errorMessage, style: const TextStyle(fontSize: 14, color: Colors.red),
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
                  onPressed: () {
                    if (_email.value.text.isEmpty |
                        _password.value.text.isEmpty) {
                      if (_email.value.text.isEmpty) {
                        setState(() => unfilledEmail = true);
                      }
                      if (_password.value.text.isEmpty) {
                        setState(() => unfilledPassword = true);
                      }
                    } else {
                      if (!isEmail(_email.value.text)) {
                        errorMessage = 'Email must be in valid form';
                        setState(() => unfilledEmail = true);
                      }
                      else {
                        errorMessage = '';
                        _email.clear();
                        _password.clear();
                        Navigator.pushReplacementNamed(context, '/food');
                      }
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    backgroundColor: const Color(0xff008600),
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
              setState(() {
                unfilledEmail = false;
                unfilledPassword = false;
                _email.clear();
                _password.clear();
                state = 3;
                introMessage = 'Forgot Your\nPassword?';
              });
            },
            child: const Text('Forgot Your Password?'),
          ),
        ),
      ],
    );
  }

  final _firstName = TextEditingController();
  final firstNameDecoration = InputDecoration(
      contentPadding: const EdgeInsets.fromLTRB(5, 1, 5, 1),
      filled: true,
      fillColor: const Color(0xffD1D1D1),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Color(0xff47A1E2)),
      ),
      hintText: 'Enter First Name');
  bool unfilledFirstName = false;

  final _lastName = TextEditingController();
  final lastNameDecoration = InputDecoration(
      contentPadding: const EdgeInsets.fromLTRB(5, 1, 5, 1),
      filled: true,
      fillColor: const Color(0xffD1D1D1),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Color(0xff47A1E2)),
      ),
      hintText: 'Enter Last Name');
  bool unfilledLastName = false;

  Widget buildRegisterPage() {
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
              setState(
                () {
                  unfilledFirstName = false;
                  unfilledLastName = false;
                  unfilledPassword = false;
                  unfilledEmail = false;
                  _firstName.clear();
                  _lastName.clear();
                  _email.clear();
                  _password.clear();
                  state = 0;
                  introMessage = 'Welcome To\nSmartChef!';
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
                fontSize: 12, color: Colors.white, fontFamily: 'EagleLake'),
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
                    controller: _firstName,
                    obscureText: false,
                    decoration: unfilledFirstName
                        ? firstNameDecoration.copyWith(
                            enabledBorder: const OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.red)),
                            suffixIcon:
                                const Icon(Icons.clear, color: Colors.red))
                        : firstNameDecoration,
                    onChanged: (firstName) {
                      setState(() => unfilledFirstName = false);
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
            'Last Name',
            style: TextStyle(
                fontSize: 12, color: Colors.white, fontFamily: 'EagleLake'),
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
                        ? lastNameDecoration.copyWith(
                            enabledBorder: const OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.red)),
                            suffixIcon:
                                const Icon(Icons.clear, color: Colors.red))
                        : lastNameDecoration,
                    onChanged: (lastName) {
                      setState(() => unfilledLastName = false);
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
                fontSize: 12, color: Colors.white, fontFamily: 'EagleLake'),
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
                        ? emailDecoration.copyWith(
                            enabledBorder: const OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.red)),
                            suffixIcon:
                                const Icon(Icons.clear, color: Colors.red))
                        : emailDecoration,
                    onChanged: (email) {
                      setState(() => unfilledEmail = false);
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
            'Password',
            style: TextStyle(
                fontSize: 12, color: Colors.white, fontFamily: 'EagleLake'),
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
                        ? passwordDecoration.copyWith(
                            enabledBorder: const OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.red)),
                            suffixIcon:
                                const Icon(Icons.clear, color: Colors.red))
                        : passwordDecoration,
                    onChanged: (password) {
                      setState(() => unfilledPassword = false);
                    },
                    textInputAction: TextInputAction.next,
                  ))
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.only(top: 5),
          width: MediaQuery.of(context).size.width,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                width: 85,
                height: 36,
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      if (_email.value.text.isEmpty |
                          _password.value.text.isEmpty |
                          _firstName.value.text.isEmpty |
                          _lastName.value.text.isEmpty) {
                        if (_firstName.value.text.isEmpty) {
                          setState(() => unfilledFirstName = true);
                        }
                        if (_lastName.value.text.isEmpty) {
                          setState(() => unfilledLastName = true);
                        }
                        if (_email.value.text.isEmpty) {
                          setState(() => unfilledEmail = true);
                        }
                        if (_password.value.text.isEmpty) {
                          setState(() => unfilledPassword = true);
                        }
                      } else {
                        if (!isEmail(_email.value.text)) {
                          errorMessage = 'Email must be in valid form';
                          setState(() => unfilledEmail = true);
                        }
                        else {
                          setState(() {
                            _firstName.clear();
                            _lastName.clear();
                            _email.clear();
                            _password.clear();
                            state = 4;
                          });
                        }
                      }
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    backgroundColor: const Color(0xff008600),
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
              )
            ],
          ),
        ),
      ],
    );
  }

  Widget buildForgotPasswordPage() {
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
              setState(
                () {
                  state = 1;
                  introMessage = 'Welcome\nBack!';
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
            children: const <Widget>[
              Flexible(
                child: Text(
                  'Please enter your email.\nA reset password link will be sent to it if an account is attached to it',
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
                        ? emailDecoration.copyWith(
                            enabledBorder: const OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.red)),
                            suffixIcon:
                                const Icon(Icons.clear, color: Colors.red))
                        : emailDecoration,
                    onChanged: (email) {
                      setState(() => unfilledEmail = false);
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
                if (_email.value.text.isEmpty) {
                  setState(() => unfilledEmail = true);
                } else {
                  if (!isEmail(_email.value.text)) {
                    errorMessage = 'Email must be in valid form';
                    setState(() => unfilledEmail = true);
                  }
                  else {
                    setState(() {
                      _email.clear();
                    });
                    introMessage = 'Welcome To\nSmartChef!';
                  }
                }
              });
            },
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              backgroundColor: const Color(0xff008600),
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

  final _code = TextEditingController();
  final codeDecoration = InputDecoration(
      contentPadding: const EdgeInsets.fromLTRB(5, 1, 5, 1),
      filled: true,
      fillColor: const Color(0xffD1D1D1),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Color(0xff47A1E2)),
      ),
      hintText: 'Enter Code');
  bool unfilledCode = false;

  Widget buildVerificationPage() {
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
              setState(() => state = 2);
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
                        ? codeDecoration.copyWith(
                            enabledBorder: const OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.red)),
                            suffixIcon:
                                const Icon(Icons.clear, color: Colors.red))
                        : codeDecoration,
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
                  setState(() {
                    _code.clear();
                    state = 0;
                  });
                  introMessage = 'Welcome To\nSmartChef!';
                }
              });
            },
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              backgroundColor: const Color(0xff008600),
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
}
