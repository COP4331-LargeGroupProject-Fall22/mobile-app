import 'dart:convert';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:smart_chef/utils/APIutils.dart';
import 'package:smart_chef/utils/authAPI.dart';
import 'package:smart_chef/utils/colors.dart';
import 'package:smart_chef/utils/globals.dart';
import 'package:smart_chef/utils/ingredientAPI.dart';
import 'package:smart_chef/utils/inventoryAPI.dart';
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
                padding: const EdgeInsets.all(5),
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
                            color: searchFieldText,
                            fontSize: 18,
                          ),
                        ),
                        style: const TextStyle(
                          color: searchFieldText,
                          fontSize: 18,
                        ),
                        textInputAction: TextInputAction.done,
                        onChanged: (query) {
                          // TODO(15): Dynamic search
                        },
                      ),
                    ),
                    const Icon(
                      Icons.search,
                      color: Colors.black,
                      size: topBarIconSize,
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
          iconSize: topBarIconSize + 5,
        ),
        actions: <Widget>[
          Builder(builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(
                Icons.manage_search,
                color: Colors.black,
              ),
              iconSize: topBarIconSize + 10,
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
              padding: const EdgeInsets.only(top: 15),
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
      body: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        child: BuildTiles(),
      ),
      extendBody: false,
      extendBodyBehindAppBar: false,
      bottomNavigationBar: BottomAppBar(
        child: Container(
          height: bottomRowHeight,
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
                      onPressed: () {},
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
                        Navigator.restorablePushReplacementNamed(
                            context, '/recipe');
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
                        Navigator.restorablePushReplacementNamed(
                            context, '/cart');
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
                      onPressed: () {
                        Navigator.restorablePushReplacementNamed(
                            context, '/user');
                      },
                      icon: const Icon(Icons.person),
                      iconSize: bottomIconSize,
                      color: bottomRowIcon,
                    ),
                    Text(
                      'User Profile',
                      style: bottomRowIconTextStyle,
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
        onPressed: () {
          Navigator.restorablePushNamed(context, '/food/add');
        },
        backgroundColor: mainScheme,
        foregroundColor: Colors.white,
        elevation: 25,
        child: const Icon(Icons.add, size: 65, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  //TODO(17): function to get ingredients from api. Will also handle sorting
  /*Future<List> GrabIngredients(int sortBy) {
    return;
  }*/

  Widget BuildTiles() {
    int numIngreds = 12;
    List<Widget> ingredients = [];

    if (numIngreds == 0) {
      return Container(
        margin: const EdgeInsets.only(top:20),
        child: Column(
            children: <Widget>[
              Flexible(
                  child: Text(
                    'You have no items in your inventory!\nPress the add button on the bottom right to start adding ingredients',
                    style: TextStyle(
                        fontSize: 24, color: Colors.grey[600], fontWeight: FontWeight.w600),
                    textAlign: TextAlign.center,
                  )
              )
            ]
        )
      );
    }

    double bodyHeight = MediaQuery.of(context).size.height -
        bottomRowHeight -
        MediaQuery.of(context).padding.top -
        AppBar().preferredSize.height;

    double itemWidth = MediaQuery.of(context).size.width / 2 - 20;
    double itemHeight = MediaQuery.of(context).size.height / 4 - 20;

    for (int i = 0; i < numIngreds; i++) {
      ingredients.add(
        GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () {
            Navigator.restorablePushNamed(context, '/food/food');
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
    return SingleChildScrollView(
        child: Container(
            width: MediaQuery.of(context).size.width,
            height: bodyHeight,
            decoration: const BoxDecoration(color: Colors.white),
            child: Column(children: <Widget>[
              Container(
                  margin: const EdgeInsets.all(10),
                  width: MediaQuery.of(context).size.width,
                  decoration: const BoxDecoration(
                    color: Colors.transparent,
                  ),
                  child: Text(sorted,
                      style: const TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                      ))),
              Expanded(child: ingreds)
            ])));
  }

  //TODO(18): integrate API into making ingredients
  Widget IngredientTile() {
    double tileHeight = 200;

    bool expiresSoon = false;
    bool expired = true;

    Container expires = Container(
      height: tileHeight,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(20)),
        color: expiresSoon
            ? Colors.red[200]
            : (expired ? const Color(0xffFF0000) : Colors.white),
      ),
      child: Align(
        alignment: FractionalOffset.bottomLeft,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            children: <Widget>[
              Expanded(
                child: Text(
                  expiresSoon ? 'Expires Soon!' : (expired ? 'Expired!' : ''),
                  style: const TextStyle(
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
            decoration: const BoxDecoration(
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
              borderRadius: const BorderRadius.all(Radius.circular(20)),
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
                padding: const EdgeInsets.all(10),
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
              onPressed: () {
                Navigator.restorablePushNamed(context, '/food/edit');
              },
              icon: const Icon(Icons.edit, color: Colors.black),
              iconSize: topBarIconSize,
            ),
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.delete, color: Colors.red),
              iconSize: topBarIconSize,
            ),
          ],
          leading: IconButton(
            icon: const Icon(Icons.navigate_before, color: Colors.black),
            iconSize: 35,
            onPressed: () {
              Navigator.pop(context);
            },
          )),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        margin: const EdgeInsets.fromLTRB(5, 10, 5, 0),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width / 2,
                height: MediaQuery.of(context).size.width / 2,
                margin: const EdgeInsets.symmetric(vertical: 20),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black, width: 3),
                  color: Colors.grey,
                ),
                child: const Text('Ingredient image'),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                margin: const EdgeInsets.symmetric(vertical: 20),
                child: const Text(
                  'Food Item',
                  style: TextStyle(
                    fontSize: 36,
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      const Text(
                        'Quantity',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.black,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width / 2.2,
                        margin: const EdgeInsets.only(right: 10),
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 5),
                        child: Text(
                          '{amount}',
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.black,
                          ),
                          textAlign: TextAlign.left,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: <Widget>[
                      const Text(
                        'Food Group',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.black,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width / 2.2,
                        margin: const EdgeInsets.only(right: 10),
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 5),
                        child: Text(
                          '{group}',
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.black,
                          ),
                          textAlign: TextAlign.left,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      const Text(
                        'Location',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.black,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width / 2.2,
                        margin: const EdgeInsets.only(right: 10),
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 5),
                        child: Text(
                          '{maybe}',
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.black,
                          ),
                          textAlign: TextAlign.left,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: <Widget>[
                      const Text(
                        'Expiration Date(s)',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.black,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width / 2.2,
                        margin: const EdgeInsets.only(right: 10),
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 5),
                        child: Text(
                          '{dates}',
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.black,
                          ),
                          textAlign: TextAlign.left,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.fromLTRB(5, 20, 5, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: Text(
                        'Nutrition Values: {amount}',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.black,
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: Text(
                        '\nBrands: {group}',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.black,
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: Text(
                        '\nTags: {maybe}',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.black,
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: Text(
                        '\nAllergens: {dates}',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.black,
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      extendBody: false,
      extendBodyBehindAppBar: false,
      bottomNavigationBar: BottomAppBar(
        child: Container(
          height: bottomRowHeight,
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
                      onPressed: () {},
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
                        Navigator.restorablePushReplacementNamed(
                            context, '/recipe');
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
                        Navigator.restorablePushReplacementNamed(
                            context, '/cart');
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
                      onPressed: () {
                        Navigator.restorablePushReplacementNamed(
                            context, '/user');
                      },
                      icon: const Icon(Icons.person),
                      iconSize: bottomIconSize,
                      color: bottomRowIcon,
                    ),
                    Text(
                      'User Profile',
                      style: bottomRowIconTextStyle,
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

  //TODO(17): Attach API to get specified ingredient information
  //
  // List fetchIngredient(int ID) {
  //   ingredientInfo = a json of some sort;
  // }
  //
}

class EditIngredientPage extends StatefulWidget {
  @override
  _EditIngredientPageState createState() => _EditIngredientPageState();
}

class _EditIngredientPageState extends State<EditIngredientPage> {
  @override
  void initState() {
    super.initState();
  }

  final _quantity = TextEditingController();
  bool unfilledQuantity = false;

  final _location = TextEditingController();
  bool unfilledLocation = false;

  final _expirationDate = TextEditingController();
  bool unfilledExpirationDate = false;

  final _brands = TextEditingController();
  bool unfilledBrands = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.white,
          actions: [
            IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.check, color: Colors.red),
              iconSize: topBarIconSize,
            ),
          ],
          leading: IconButton(
            icon: const Icon(Icons.navigate_before, color: Colors.black),
            iconSize: 35,
            onPressed: () {
              Navigator.pop(context);
            },
          )),
      body: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height - bottomRowHeight,
          margin: const EdgeInsets.fromLTRB(5, 10, 5, 0),
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width / 2,
                  height: MediaQuery.of(context).size.width / 2,
                  margin: const EdgeInsets.symmetric(vertical: 20),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black, width: 3),
                    color: Colors.grey,
                  ),
                  child: const Text('Ingredient image'),
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  margin: const EdgeInsets.symmetric(vertical: 20),
                  child: const Text(
                    'Food Item',
                    style: TextStyle(
                      fontSize: 36,
                      color: Colors.black,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      flex: 5,
                      child: Column(
                        children: <Widget>[
                          const Text(
                            'Quantity',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.black,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          Container(
                            margin: const EdgeInsets.symmetric(horizontal: 10),
                            padding: const EdgeInsets.symmetric(
                                vertical: 5, horizontal: 5),
                            decoration: const BoxDecoration(
                              color: mainScheme,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                            ),
                            child: TextField(
                              maxLines: 1,
                              controller: _quantity,
                              decoration: unfilledQuantity
                                  ? invalidTextField.copyWith(
                                      hintText: 'Enter Quantity')
                                  : globalDecoration.copyWith(
                                      hintText: 'Enter Quantity'),
                              style: const TextStyle(
                                fontSize: 20,
                                color: Colors.black,
                              ),
                              onChanged: (quantity) {
                                if (quantity.isEmpty) {
                                  setState(() => unfilledQuantity = true);
                                } else {
                                  unfilledQuantity = false;
                                }
                              },
                              textAlign: TextAlign.left,
                              textInputAction: TextInputAction.next,
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
                            'Food Group',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.black,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width,
                            margin: const EdgeInsets.symmetric(horizontal: 5),
                            padding: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 5),
                            child: Text(
                              '{group}',
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.black,
                              ),
                              textAlign: TextAlign.left,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      flex: 5,
                      child: Column(
                        children: <Widget>[
                          const Text(
                            'Location',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.black,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          Container(
                            margin: const EdgeInsets.symmetric(horizontal: 5),
                            padding: const EdgeInsets.symmetric(
                                vertical: 5, horizontal: 5),
                            decoration: const BoxDecoration(
                              color: mainScheme,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                            ),
                            child: TextField(
                              maxLines: 1,
                              controller: _location,
                              decoration: globalDecoration.copyWith(
                                  hintText: 'Enter Location'),
                              style: const TextStyle(
                                fontSize: 20,
                                color: Colors.black,
                              ),
                              onChanged: (location) {},
                              textAlign: TextAlign.left,
                              textInputAction: TextInputAction.next,
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
                            'Expiration Date(s)',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.black,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          Container(
                            margin: const EdgeInsets.symmetric(horizontal: 5),
                            padding: const EdgeInsets.symmetric(
                                vertical: 5, horizontal: 5),
                            decoration: const BoxDecoration(
                              color: mainScheme,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                            ),
                            child: TextField(
                              maxLines: 1,
                              controller: _expirationDate,
                              decoration: unfilledExpirationDate
                                  ? invalidTextField.copyWith(
                                      hintText: 'Enter Expiration Date')
                                  : globalDecoration.copyWith(
                                      hintText: 'Enter Expiration Date'),
                              style: const TextStyle(
                                fontSize: 20,
                                color: Colors.black,
                              ),
                              onChanged: (location) {},
                              textAlign: TextAlign.left,
                              textInputAction: TextInputAction.next,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  padding: const EdgeInsets.fromLTRB(5, 20, 5, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: Text(
                          'Nutrition Values: {amount}',
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.black,
                          ),
                          textAlign: TextAlign.left,
                        ),
                      ),
                      Row(children: <Widget>[
                        Text(
                          '\nBrands: ',
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.black,
                          ),
                          textAlign: TextAlign.left,
                        ),
                        Expanded(
                          child: Container(
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
                              controller: _brands,
                              decoration: unfilledBrands
                                  ? invalidTextField.copyWith(
                                      hintText: 'Enter Brands')
                                  : globalDecoration.copyWith(
                                      hintText: 'Enter Brands'),
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.black,
                              ),
                              onChanged: (location) {},
                              textAlign: TextAlign.left,
                              textInputAction: TextInputAction.next,
                            ),
                          ),
                        ),
                      ]),
                      SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: Text(
                          '\nTags: {maybe}',
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.black,
                          ),
                          textAlign: TextAlign.left,
                        ),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: Text(
                          '\nAllergens: {dates}',
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.black,
                          ),
                          textAlign: TextAlign.left,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      extendBody: false,
      extendBodyBehindAppBar: false,
      bottomNavigationBar: BottomAppBar(
        child: Container(
          height: bottomRowHeight,
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
                      onPressed: () {},
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
                        Navigator.restorablePushReplacementNamed(
                            context, '/recipe');
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
                        Navigator.restorablePushReplacementNamed(
                            context, '/cart');
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
                      onPressed: () {
                        Navigator.restorablePushReplacementNamed(
                            context, '/user');
                      },
                      icon: const Icon(Icons.person),
                      iconSize: bottomIconSize,
                      color: bottomRowIcon,
                    ),
                    Text(
                      'User Profile',
                      style: bottomRowIconTextStyle,
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

//TODO(17): Attach API to get specified ingredient information
//
// List fetchIngredient(int ID) {
//   ingredientInfo = a json of some sort;
// }
//
}

class AddIngredientPage extends StatefulWidget {
  @override
  _AddIngredientPageState createState() => _AddIngredientPageState();
}

class _AddIngredientPageState extends State<AddIngredientPage> {
  ScrollController loading = ScrollController();
  final searchController = TextEditingController();
  List<DropdownMenuItem<String>> searches = [];

  @override
  void initState() {
    super.initState();
    loading = ScrollController()..addListener(_scrollListener);
    searches = [];
  }

  @override
  void dispose() {
    loading.removeListener(_scrollListener);
    super.dispose();
  }

  int pageCount = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.white,
          leading: IconButton(
            icon: const Icon(Icons.navigate_before, color: Colors.black),
            iconSize: 35,
            onPressed: () {
              Navigator.pop(context);
            },
          )),
      body:Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          margin: const EdgeInsets.fromLTRB(5, 10, 5, 0),
          child: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () {
              FocusManager.instance.primaryFocus?.unfocus();
            },
            child: Column(
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width,
                margin:
                    const EdgeInsets.symmetric(vertical: 50, horizontal: 15),
                child: Row(
                  children: const <Widget>[
                    Flexible(
                      child: Text(
                        'Search for an ingredient to get started',
                        style: TextStyle(
                          fontSize: 32,
                          color: Colors.black,
                          fontWeight: FontWeight.w400,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width / 1.5,
                padding: const EdgeInsets.all(5),
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  color: textFieldBacking,
                ),
                child: LayoutBuilder(builder:
                    (BuildContext context, BoxConstraints constraints) {
                  return DropdownButtonFormField2<String>(
                          decoration: const InputDecoration.collapsed(
                            hintText: 'Search...',
                            hintStyle: TextStyle(
                              color: searchFieldText,
                              fontSize: 18,
                            ),
                          ),
                          icon: const Icon(
                            Icons.search,
                            color: Colors.black,
                            size: topBarIconSize,
                          ),
                          items: searches,
                          onChanged: (String? newVal) {

                          },
                        );
                        // child: TextField(
                        //   maxLines: 1,
                        //   decoration:
                        //   style: const TextStyle(
                        //     color: searchFieldText,
                        //     fontSize: 18,
                        //   ),
                        //   textInputAction: TextInputAction.done,
                        //   onChanged: (query) {
                        //     pageCount = 0;
                        //     // TODO(15): Dynamic search
                        //   },
                        // ),
                }),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.only(
                    top: 150, left: 15, right: 15, bottom: 50),
                child: Row(
                  children: const <Widget>[
                    Flexible(
                      child: Text(
                        'Or scan a barcode to automatically add it to your inventory',
                        style: TextStyle(
                          fontSize: 32,
                          color: Colors.black,
                          fontWeight: FontWeight.w400,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  //TODO(31): Add ability to scan barcodes
                },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  backgroundColor: mainScheme,
                  padding:
                      const EdgeInsets.symmetric(vertical: 15, horizontal: 25),
                  shadowColor: Colors.black,
                ),
                child: const Text(
                  'Scan!',
                  style: TextStyle(
                    fontSize: 50,
                    color: Colors.white,
                    fontWeight: FontWeight.w400,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
      extendBody: false,
      extendBodyBehindAppBar: false,
      bottomNavigationBar: BottomAppBar(
        child: Container(
          height: bottomRowHeight,
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
                      onPressed: () {},
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
                        Navigator.restorablePushReplacementNamed(
                            context, '/recipe');
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
                        Navigator.restorablePushReplacementNamed(
                            context, '/cart');
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
                      onPressed: () {
                        Navigator.restorablePushReplacementNamed(
                            context, '/user');
                      },
                      icon: const Icon(Icons.person),
                      iconSize: bottomIconSize,
                      color: bottomRowIcon,
                    ),
                    Text(
                      'User Profile',
                      style: bottomRowIconTextStyle,
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

  void _scrollListener() {
    if (loading.position.extentAfter < 500) {
      setState(() {
        updateSearchList(searchController.text);
      });
    }
  }

  //TODO(26): Allow searching of ingredients to add predefined things
  void updateSearchList(String searchQuery) async {

    int resultsPerPage = 20;

    final res = await Ingredients.searchIngredients(searchQuery, resultsPerPage, pageCount++, '');
    if (res.statusCode != 200) {
      return null;
    }

    var data = json.decode(res.body);
    for (var value in data) {
      DropdownMenuItem<String> searchToAdd = DropdownMenuItem(
        child: Text(
            value['name'],
          style: const TextStyle(
            color: searchFieldText,
            fontSize: 18,
          ),
        )
      );
      searches.add(searchToAdd);
    }

  }
}
