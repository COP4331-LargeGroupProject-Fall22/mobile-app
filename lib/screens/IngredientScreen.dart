import 'package:flutter/material.dart';
import 'package:smart_chef/utils/APIutils.dart';
import 'package:smart_chef/utils/colors.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(
            'SmartChef',
            style: TextStyle(fontSize: 24, color: mainScheme),
          ),
          centerTitle: true,
          backgroundColor: Colors.white,
          leading: IconButton(
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
              onPressed: () {},
            ),
          ]),
      body: SafeArea(
        child: GestureDetector(
          onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
          child: SingleChildScrollView(
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              padding: EdgeInsets.only(bottom: kBottomNavigationBarHeight),
              decoration: BoxDecoration(color: Colors.white),
              child: BuildTiles(),
            ),
          ),
        ),
      ),
      extendBody: false,
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
                          iconSize: 55,
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
                      onPressed: () {
                        Navigator.pushReplacementNamed(context, '/user');
                      },
                      icon: Icon(Icons.person),
                      iconSize: 55,
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

  GridView BuildTiles() {
    int numIngreds = 10;
    List<Widget> ingredients = [];

    for (int i = 0; i < numIngreds; i++) {
      ingredients.add(
        GestureDetector(
          onTap: () {},
          child: IngredientTile(),
        ),
      );
    }

    GridView ingreds = GridView.count(
        crossAxisCount: 2,
        padding: const EdgeInsets.all(15),
        scrollDirection: Axis.vertical,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        children: ingredients);
    return ingreds;
  }

  //TODO Make the individual ingredient tiles
  Widget IngredientTile() {
    return SizedBox(
      child: Stack(
        children: <Widget>[
          Container(
            margin: EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(20)),
              image: DecorationImage(
                image: AssetImage('assets/images/Background.png'),
                fit: BoxFit.fitWidth,
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.all(10),
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
                stops: [0.0, 1.0],
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
