import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:smart_chef/utils/APIutils.dart';
import 'package:smart_chef/utils/authAPI.dart';
import 'package:smart_chef/utils/colors.dart';
import 'package:smart_chef/utils/globals.dart';
import 'package:smart_chef/utils/userAPI.dart';

class RecipeScreen extends StatefulWidget {
  @override
  _RecipeState createState() => _RecipeState();
}

class _RecipeState extends State<RecipeScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return RecipePage();
  }
}

class RecipePage extends StatefulWidget {
  @override
  _RecipePageState createState() => _RecipePageState();
}

class _RecipePageState extends State<RecipePage> {
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
            style: TextStyle(fontSize: 24, color: mainScheme),
          ),
          centerTitle: true,
          backgroundColor: Colors.white,
          leading: IconButton(
            // TODO(15): Make search functionality
            onPressed: () {},
            icon: Icon(
              Icons.search,
              color: Colors.black,
            ),
            iconSize: 35,
          ),
          actions: <Widget>[
            IconButton(
              icon: Icon(
                Icons.manage_search,
                color: Colors.black,
              ),
              iconSize: 35,
              // TODO(25): Make sort functionality
              onPressed: () {},
            ),
          ]),
      body: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: SingleChildScrollView(
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(color: Colors.white),
            // TODO(12): Make Recipe Screen UI
            child: Text("To be changed"),
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
                          iconSize: bottomIconSize,
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
                      onPressed: () {},
                      icon: Icon(Icons.restaurant),
                      color: mainScheme,
                      iconSize: bottomIconSize,
                    ),
                    Text(
                      'Recipes',
                      style: bottomRowOnScreenTextStyle,
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
                      iconSize: bottomIconSize,
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
                      onPressed: () {
                        Navigator.pushReplacementNamed(context, '/user');
                      },
                      icon: Icon(Icons.person),
                      iconSize: bottomIconSize,
                      color: bottomRowIcon,
                    ),
                    const Text(
                      'User Profile',
                      style: TextStyle(fontSize: 12, color: bottomRowIcon),
                      textAlign: TextAlign.center,
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.large(
        onPressed: () {},
        backgroundColor: mainScheme,
        foregroundColor: Colors.white,
        child: const Icon(Icons.add, size: 65, color: Colors.white),
        elevation: 25,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
