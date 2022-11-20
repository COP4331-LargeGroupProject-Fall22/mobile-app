import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:smart_chef/utils/APIutils.dart';
import 'package:smart_chef/utils/authAPI.dart';
import 'package:smart_chef/utils/colors.dart';
import 'package:smart_chef/utils/globals.dart';
import 'package:smart_chef/utils/userAPI.dart';

class IngredientsScreen extends StatefulWidget {
  @override
  _IngredientsState createState() => _IngredientsState();
}

class _IngredientsState extends State<IngredientsScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return IngredientsPage();
  }
}

class IngredientsPage extends StatefulWidget {
  @override
  _IngredientsPageState createState() => _IngredientsPageState();
}

class _IngredientsPageState extends State<IngredientsPage> {
  @override
  void initState() {
    super.initState();
  }

  Icon leadingIcon = const Icon(Icons.search, color: Colors.black);
  Widget searchBar = const Text('SmartChef',
      style: TextStyle(fontSize: 24, color: mainScheme));
  final _search = TextEditingController();

  int _groupValue = 0;

  String sorted = 'Sorted by Expiration Date(Oldest First)';
  List checkListItems = [
    {
      "id": 0,
      "value": true,
      "title": "Expiration Date(Oldest First)",
    },
    {
      "id": 1,
      "value": false,
      "title": "Expiration Date(Newest First)",
    },
    {
      "id": 2,
      "value": false,
      "title": "Name (A-Z)",
    },
    {
      "id": 3,
      "value": false,
      "title": "Name (Z-A)",
    },
    {
      "id": 4,
      "value": false,
      "title": "Category",
    },
    {
      "id": 5,
      "value": false,
      "title": "Category (Reverse)",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: searchBar,
        centerTitle: true,
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            if (leadingIcon.icon == Icons.search) {
              leadingIcon = const Icon(Icons.cancel, color: Colors.white);
              searchBar = Container(
                width: 300,
                height: 35,
                padding: EdgeInsets.all(5),
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  color: textFieldBacking,
                ),
                child: Row(
                  children: <Widget>[
                    SizedBox(
                      width: 230,
                      height: MediaQuery.of(context).size.height,
                      child: TextField(
                        maxLines: 1,
                        decoration: const InputDecoration.collapsed(
                          hintText: 'Search...',
                          hintStyle: TextStyle(
                            color: Color(0xff7D7D7D),
                            fontSize: 18,
                          ),
                        ),
                        style: const TextStyle(
                          color: Color(0xff7D7D7D),
                        ),
                        textInputAction: TextInputAction.done,
                        onChanged: (query) {
                          // TODO(): Dynamic search
                        },
                      ),
                    ),
                    Icon(
                      Icons.search,
                      color: Colors.black,
                      size: 28,
                    ),
                  ],
                ),
              );
            } else {
              leadingIcon = const Icon(Icons.search, color: Colors.black);
              searchBar = const Text('SmartChef',
                  style: TextStyle(fontSize: 24, color: mainScheme));
            }
            setState(() {});
          },
          icon: leadingIcon,
          iconSize: 35,
        ),
        actions: <Widget>[
          Builder(builder: (BuildContext context) {
            return IconButton(
              icon: Icon(
                Icons.manage_search,
                color: Colors.black,
              ),
              iconSize: 35,
              onPressed: () => Scaffold.of(context).openEndDrawer(),
            );
          }),
        ],
      ),
      endDrawer: Drawer(
        backgroundColor: Colors.white,
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(top: 15),
              decoration: BoxDecoration(
                  border: Border(
                      bottom: BorderSide(
                          color: Colors.black.withOpacity(.2), width: 3))),
              child: const DrawerHeader(
                child: Text(
                  'Sort by...',
                  style: TextStyle(
                    fontSize: 24,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            Column(
              children: List.generate(
                checkListItems.length,
                (index) => RadioListTile(
                  controlAffinity: ListTileControlAffinity.leading,
                  title: Text(
                    checkListItems[index]["title"],
                    style: const TextStyle(
                      fontSize: 18,
                      color: Colors.black,
                    ),
                  ),
                  activeColor: mainScheme,
                  value: checkListItems[index]["id"],
                  groupValue: _groupValue,
                  autofocus: checkListItems[index]["value"] ? false : true,
                  onChanged: (value) {
                    sorted = 'Sorting By ${checkListItems[index]["title"]}';
                    setState(() => _groupValue = value);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: GestureDetector(
          onTap: () {
            FocusManager.instance.primaryFocus?.unfocus();
            /*if (_search.value.text.isEmpty) {
              leadingIcon = const Icon(Icons.search, color: Colors.black);
              searchBar = const Text('SmartChef', style: TextStyle(fontSize: 24, color: mainScheme));
            }*/
          },
          child: SingleChildScrollView(
            child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height - 175,
                decoration: const BoxDecoration(color: Colors.white),
                child: Column(
                  children: <Widget>[
                    Container(
                        margin: EdgeInsets.all(10),
                        width: MediaQuery.of(context).size.width,
                        decoration: const BoxDecoration(
                          color: Colors.transparent,
                        ),
                        child: Text(sorted,
                            style: const TextStyle(
                              fontSize: 18,
                              color: Colors.black,
                            ))),
                    Expanded(
                      child: BuildTiles(),
                    ),
                  ],
                )),
          ),
        ),
      ),
      extendBody: false,
      extendBodyBehindAppBar: false,
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
                          onPressed: () {},
                          icon: Icon(Icons.egg),
                          iconSize: bottomIconSize,
                          color: mainScheme,
                        ),
                        const Text(
                          'Ingredients',
                          style: TextStyle(fontSize: 12, color: mainScheme),
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
                      iconSize: bottomIconSize,
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

  //todo function to get ingredients from api. Will also handle sorting
  /*Future<List> GrabIngredients(int sortBy) {
    return;
  }*/

  GridView BuildTiles() {
    int numIngreds = 10;
    List<Widget> ingredients = [];

    double itemWidth = MediaQuery.of(context).size.width / 2 - 20;
    double itemHeight = MediaQuery.of(context).size.height / 4 - 20;

    for (int i = 0; i < numIngreds; i++) {
      ingredients.add(
        GestureDetector(
          onTap: () {
            Navigator.pushNamed(context, '/food/food');
          },
          child: IngredientTile(),
        ),
      );
    }

    GridView ingreds = GridView.count(
        shrinkWrap: true,
        childAspectRatio: itemWidth / itemHeight,
        crossAxisCount: 2,
        padding: const EdgeInsets.all(15),
        scrollDirection: Axis.vertical,
        crossAxisSpacing: 20,
        mainAxisSpacing: 15,
        children: ingredients);
    return ingreds;
  }

  //TODO integrate API into making ingredients
  Widget IngredientTile() {
    double tileHeight = 200;

    bool expiresSoon = false;
    bool expired = true;

    Container expires = Container(
      height: tileHeight,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(20)),
        color: expiresSoon
            ? Colors.red[200]
            : (expired ? Color(0xffFF0000) : Colors.white),
      ),
      child: Align(
        alignment: FractionalOffset.bottomLeft,
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Row(
            children: <Widget>[
              Expanded(
                child: Text(
                  expiresSoon ? 'Expires Soon!' : (expired ? 'Expired!' : ''),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );

    return SizedBox(
      child: Stack(
        children: <Widget>[
          expires,
          Container(
            height: tileHeight - 40,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(20)),
              image: DecorationImage(
                image: AssetImage('assets/images/Background.png'),
                fit: BoxFit.fitWidth,
              ),
            ),
          ),
          Container(
            height: tileHeight - 40,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(20)),
              gradient: LinearGradient(
                begin: FractionalOffset.topCenter,
                end: FractionalOffset.bottomCenter,
                colors: [
                  Colors.grey.withOpacity(0.0),
                  Colors.black.withOpacity(0.5),
                ],
                stops: [0.0, 0.75],
              ),
            ),
            child: Align(
              alignment: FractionalOffset.bottomLeft,
              child: Padding(
                padding: EdgeInsets.all(10),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        'To Be Changed',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class IngredientPage extends StatefulWidget {
  @override
  _IngredientPageState createState() => _IngredientPageState();
}

class _IngredientPageState extends State<IngredientPage> {
  @override
  void initState() {
    super.initState();
  }

  List ingredientInfo = []; //fetchIngredients(int ID);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.white,
          actions: [
            IconButton(
              onPressed: () {},
              icon: Icon(Icons.edit, color: Colors.black),
              iconSize: 28,
            ),
            IconButton(
              onPressed: () {},
              icon: Icon(Icons.delete, color: Colors.red),
              iconSize: 28,
            ),
          ],
          leading: IconButton(
            icon: const Icon(Icons.navigate_before, color: Colors.black),
            iconSize: 35,
            onPressed: () {
              Navigator.pop(context);
            },
          )),
      body: SingleChildScrollView(
        child: Text('To be changed'),
      ),
      extendBody: false,
      extendBodyBehindAppBar: false,
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
                          onPressed: () {},
                          icon: Icon(Icons.egg),
                          iconSize: bottomIconSize,
                          color: mainScheme,
                        ),
                        const Text(
                          'Ingredients',
                          style: TextStyle(fontSize: 12, color: mainScheme),
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
                      iconSize: bottomIconSize,
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
    );
  }

  //TODO Attach API to get specified ingredient information
  //
  // List fetchIngredient(int ID) {
  //   ingredientInfo = a json of some sort;
  // }
  //
}
