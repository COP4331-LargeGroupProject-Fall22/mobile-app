import 'package:flutter/material.dart';
import 'package:smart_chef/utils/globals.dart';
import 'package:smart_chef/utils/getAPI.dart';
import 'dart:convert';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'SmartChef',
          style: TextStyle(fontSize: 24, color: Color(0xff008600)),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        actions: <Widget>[
          IconButton(
            onPressed: () {},
            icon: Icon(
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
            decoration: BoxDecoration(color: Colors.white),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: 200,
                  height: 200,
                  margin: EdgeInsets.only(top: 40),
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    border: Border.all(color: Colors.black, width: 2),
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  width: 200,
                  child: Text(
                    'Your profile image',
                    style: TextStyle(fontSize: 14, color: Colors.black),
                    textAlign: TextAlign.center,
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 60),
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
                                margin: EdgeInsets.only(right: 10),
                                padding: EdgeInsets.symmetric(
                                    vertical: 5, horizontal: 5),
                                decoration: BoxDecoration(
                                  color: Color(0xff008600),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                ),
                                child: Text(
                                  LocalData.firstName,
                                  style: TextStyle(
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
                                margin: EdgeInsets.only(left: 10),
                                padding: EdgeInsets.symmetric(
                                    vertical: 5, horizontal: 5),
                                decoration: BoxDecoration(
                                  color: Color(0xff008600),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                ),
                                child: Text(
                                  LocalData.lastName,
                                  style: TextStyle(
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
                            margin: EdgeInsets.only(top: 25),
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
                            margin: EdgeInsets.only(bottom: 120),
                            padding: EdgeInsets.symmetric(
                                vertical: 5, horizontal: 5),
                            decoration: BoxDecoration(
                              color: Color(0xff008600),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                            ),
                            child: Text(
                              'email@email.com',//LocalData.email,
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                              ),
                              textAlign: TextAlign.left,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            width: 180,
                            padding: EdgeInsets.all(15),
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
                                backgroundColor: const Color(0xff008600),
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
                            padding: EdgeInsets.all(15),
                            child: ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                backgroundColor: const Color(0xff008600),
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
                          icon: Icon(Icons.egg),
                          iconSize: 55,
                          color: Color(0xff5E5E5E),
                        ),
                        const Text(
                          'Ingredients',
                          style:
                              TextStyle(fontSize: 12, color: Color(0xff5E5E5E)),
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
                      color: Color(0xff5E5E5E),
                      iconSize: 55,
                    ),
                    const Text(
                      'Recipes',
                      style: TextStyle(fontSize: 12, color: Color(0xff5E5E5E)),
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
                      color: Color(0xff5E5E5E),
                    ),
                    const Text(
                      'Shopping Cart',
                      style: TextStyle(fontSize: 12, color: Color(0xff5E5E5E)),
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
                      color: Color(0xff008600),
                    ),
                    const Text(
                      'User Profile',
                      style: TextStyle(fontSize: 12, color: Color(0xff008600)),
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
    _firstName.text = LocalData.firstName;
    _lastName.text = LocalData.lastName;
    _email.text = LocalData.email;
    super.initState();
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
          style: TextStyle(fontSize: 24, color: Color(0xff008600)),
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
                  width: 200,
                  height: 200,
                  margin: EdgeInsets.only(top: 20),
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    border: Border.all(color: Colors.black, width: 2),
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  width: 200,
                  child: Text(
                    'Your profile image',
                    style: TextStyle(fontSize: 14, color: Colors.black),
                    textAlign: TextAlign.center,
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 10),
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
                                margin: EdgeInsets.only(right: 10),
                                decoration: BoxDecoration(
                                  color: Color(0xff008600),
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                                ),
                                child: TextField(
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
                                  style: TextStyle(
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
                                margin: EdgeInsets.only(left: 10),
                                padding: EdgeInsets.symmetric(
                                    vertical: 5, horizontal: 5),
                                decoration: BoxDecoration(
                                  color: Color(0xff008600),
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                                ),
                                child: TextField(
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
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.black,
                                  ),
                                  textAlign: TextAlign.left,
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
                            margin: EdgeInsets.only(top: 15),
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
                            padding: EdgeInsets.symmetric(
                                vertical: 5, horizontal: 5),
                            decoration: BoxDecoration(
                              color: Color(0xff008600),
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
                              color: Color(0xff008600),
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
                                      color: Colors.red))
                                  : globalDecoration.copyWith(hintText: 'Enter Password'),
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
                            padding: EdgeInsets.symmetric(
                                vertical: 5, horizontal: 5),
                            decoration: BoxDecoration(
                              color: Color(0xff008600),
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
                                      color: Colors.red))
                                  : globalDecoration.copyWith(hintText: 'Confirm Password'),
                              onChanged: (password) {
                                if (password.isEmpty) {
                                  setState(() => unfilledConfirmPassword = true);
                                }
                                else {
                                  if (_password.value.text.isEmpty) {
                                    errorMessage = 'Passwords must match!';
                                  }
                                  else if (_password.value.text != password) {
                                    errorMessage = 'Passwords must match!';
                                  }
                                  else {
                                    errorMessage = '';
                                    setState(() =>unfilledConfirmPassword = false);
                                  }
                                }
                              },
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(bottom: 20),
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
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                backgroundColor: Color(0xff008600),
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
                          color: Color(0xff5E5E5E),
                        ),
                        const Text(
                          'Ingredients',
                          style:
                          TextStyle(fontSize: 12, color: Color(0xff5E5E5E)),
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
                      color: Color(0xff5E5E5E),
                      iconSize: 55,
                    ),
                    const Text(
                      'Recipes',
                      style: TextStyle(fontSize: 12, color: Color(0xff5E5E5E)),
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
                      color: Color(0xff5E5E5E),
                    ),
                    const Text(
                      'Shopping Cart',
                      style: TextStyle(fontSize: 12, color: Color(0xff5E5E5E)),
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
                      color: Color(0xff008600),
                    ),
                    const Text(
                      'User Profile',
                      style: TextStyle(fontSize: 12, color: Color(0xff008600)),
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