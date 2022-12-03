import 'dart:convert';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:smart_chef/utils/APIutils.dart';
import 'package:smart_chef/utils/colors.dart';
import 'package:smart_chef/utils/globals.dart';
import 'package:smart_chef/utils/ingredientAPI.dart';
import 'package:smart_chef/utils/ingredientData.dart';
import 'package:smart_chef/utils/inventoryAPI.dart';
import 'package:smart_chef/utils/recipeAPI.dart';
import 'package:smart_chef/utils/recipeData.dart';
import 'package:smart_chef/utils/recipeUtils.dart';
import 'package:smart_chef/utils/userAPI.dart';

class RecipesScreen extends StatefulWidget {
  @override
  _RecipesState createState() => _RecipesState();
}

class _RecipesState extends State<RecipesScreen> {
  @override
  void initState() {
    super.initState();
    recipeScroll = ScrollController()..addListener(_scrollListener);
  }

  @override
  void dispose() {
    recipeScroll.removeListener(_scrollListener);
    super.dispose();
  }

  late GridView body;
  List<RecipeData> recipes = [];
  List<String> cuisineFilter = [];
  List<String> dietFilter = [];
  late ScrollController recipeScroll;
  String errorMessage = 'No recipes to list!';
  String filters = '';
  int itemsToDisplay = 30;
  int page = 1;
  int totalPages = 0;
  bool sortingDrawer = false;

  Future<void> makeTiles() async {
    recipes = await retrieveRecipes();
    body = BuildTiles();
  }

  void _scrollListener() {
    if (recipeScroll.position.atEdge) {
      bool isTop = recipeScroll.position.pixels == 0;
      if (!isTop) {
        makeTiles();
      }
    }
  }

  Icon leadingIcon = const Icon(Icons.search, color: black);
  Widget searchBar = const Text('SmartChef',
      style: TextStyle(fontSize: 24, color: mainScheme));
  final _search = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double bodyHeight = MediaQuery.of(context).size.height -
        bottomRowHeight -
        MediaQuery.of(context).padding.top -
        AppBar().preferredSize.height;
    return Scaffold(
      appBar: AppBar(
        title: searchBar,
        centerTitle: true,
        backgroundColor: white,
        leading: IconButton(
          onPressed: () {
            if (leadingIcon.icon == Icons.search) {
              leadingIcon = const Icon(Icons.cancel, color: white);
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
                        controller: _search,
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
                        onSubmitted: (query) {
                        },
                      ),
                    ),
                    const Icon(
                      Icons.search,
                      color: black,
                      size: topBarIconSize,
                    ),
                  ],
                ),
              );
            } else {
              leadingIcon = const Icon(Icons.search, color: black);
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
                Icons.filter,
                color: black,
              ),
              iconSize: topBarIconSize + 10,
              onPressed: () => Scaffold.of(context).openEndDrawer(),
            );
          }),
        ],
      ),
      endDrawer: Drawer(
        backgroundColor: white,
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            Container(
              padding: const EdgeInsets.only(top: 15),
              decoration: BoxDecoration(
                  border: Border(
                      bottom:
                          BorderSide(color: black.withOpacity(.2), width: 3))),
              child: const DrawerHeader(
                child: Text(
                  'Filter by...',
                  style: TextStyle(
                    fontSize: 24,
                    color: black,
                  ),
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(5),
              child: RichText(
                text: TextSpan(
                  text: 'Apply filters',
                  style: const TextStyle(
                    color: Colors.blueAccent,
                    decoration: TextDecoration.underline,
                  ),
                  recognizer: TapGestureRecognizer()..onTap= () {
                    setState(() {});
                  }
                )
              )
            ),
            Column(children: <Widget>[
              const Expanded(
                  child: Text(
                'Sort by cuisine',
                style: TextStyle(
                  fontSize: 18,
                  color: black,
                ),
                textAlign: TextAlign.left,
              )),
              ListView.builder(
                itemCount: cuisinesList.length,
                itemBuilder: (context, index) {
                  return CheckboxListTile(
                    title: Text(cuisinesList[index]),
                    dense: true,
                    checkColor: mainScheme,
                    value: false,
                    onChanged: (bool? value) {
                      if (value!) {
                        cuisineFilter.add(cuisinesList[index]);
                      } else {
                        cuisineFilter.remove(cuisinesList[index]);
                      }
                    },
                  );
                },
              ),
              const Expanded(
                  child: Text(
                    'Sort by diet',
                    style: TextStyle(
                      fontSize: 18,
                      color: black,
                    ),
                    textAlign: TextAlign.left,
                  )),
              ListView.builder(
                itemCount: dietsList.length,
                itemBuilder: (context, index) {
                  return CheckboxListTile(
                    title: Text(dietsList[index]),
                    dense: true,
                    checkColor: mainScheme,
                    value: false,
                    onChanged: (bool? value) {
                      if (value!) {
                        dietFilter.add(dietsList[index]);
                      } else {
                        dietFilter.remove(dietsList[index]);
                      }
                    },
                  );
                },
              ),
            ]),
          ],
        ),
      ),
      body: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        child: SingleChildScrollView(
          controller: recipeScroll,
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: bodyHeight,
            decoration: const BoxDecoration(color: white),
            child: Column(
              children: <Widget>[
                Flexible(
                  child: Text(
                    filters,
                    style: const TextStyle(
                      fontSize: ingredientInfoFontSize,
                      color: black,
                    ),
                  ),
                ),
                Expanded(
                  child: FutureBuilder(
                    future: makeTiles(),
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      switch (snapshot.connectionState) {
                        case ConnectionState.active:
                        case ConnectionState.waiting:
                          return const CircularProgressIndicator();
                        case ConnectionState.done:
                          if (snapshot.hasError) {
                            return Text('Error: $snapshot.error}');
                          }
                          if (recipes.length == 0) {
                            return ListTile(
                              contentPadding: const EdgeInsets.all(15),
                              title: Text(
                                errorMessage,
                                style: const TextStyle(
                                  fontSize: addIngredientPageTextSize,
                                  color: searchFieldText,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            );
                          }
                          return body;
                      }
                      return const CircularProgressIndicator();
                    },
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
            border:
                Border(top: BorderSide(color: black.withOpacity(.2), width: 3)),
            color: white,
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
                      onPressed: () {
                        Navigator.restorablePushReplacementNamed(
                            context, '/food');
                      },
                      icon: const Icon(Icons.egg),
                      iconSize: bottomIconSize,
                      color: bottomRowIcon,
                    ),
                    Text(
                      'Ingredients',
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
                      onPressed: () {},
                      icon: const Icon(Icons.restaurant),
                      iconSize: bottomIconSize,
                      color: mainScheme,
                    ),
                    Text(
                      'Recipes',
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

  Future<List<RecipeData>> retrieveRecipes() async {
    String toSortBy = '';
    page = 1;

    List<RecipeData> recipes = [];

    final res = await Recipes.searchRecipes(
        '', resultsPerPage, page, '', '', '', '', '');
    bool success = false;
    do {
      if (res.statusCode == 200) {
        var data = json.decode(res.body);
        totalPages = data.containsKey('numOfPages') ? data['numOfPages'] : 0;
        for (var cats in data['results']) {
          recipes.add(RecipeData.create().putRecipe(cats));
        }
        success = true;
      } else {
        int errorCode = await getDataRetrieveError(res.statusCode);
        if (errorCode == 3) {
          errorDialog(context);
        }
      }
    } while (!success);

    return recipes;
  }

  GridView BuildTiles() {
    GridView toRet = GridView.builder(
      itemCount:
          itemsToDisplay < recipes.length ? itemsToDisplay : recipes.length,
      shrinkWrap: true,
      itemBuilder: (context, index) {
        RecipeData item = recipes[index];

        double tileHeight = MediaQuery.of(context).size.height;

        return GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () {
            Navigator.restorablePushNamed(context, '/recipe/recipe',
                arguments: item.ID);
            setState(() {});
          },
          child: Stack(
            children: <Widget>[
              Container(
                height: tileHeight,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20)),
                ),
                child: Image.network(
                  item.imageUrl,
                  fit: BoxFit.fitWidth,
                ),
              ),
              Container(
                height: tileHeight,
                decoration: BoxDecoration(
                  color: white,
                  borderRadius: const BorderRadius.all(Radius.circular(20)),
                  gradient: LinearGradient(
                    begin: FractionalOffset.topCenter,
                    end: FractionalOffset.bottomCenter,
                    colors: [
                      Colors.grey.withOpacity(0.0),
                      black.withOpacity(0.5),
                    ],
                    stops: const [0.0, 0.75],
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
                            item.name,
                            style: const TextStyle(
                              fontSize: ingredientInfoFontSize,
                              fontWeight: FontWeight.w600,
                              color: white,
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
      },
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 20,
        mainAxisSpacing: 20,
      ),
      physics: const NeverScrollableScrollPhysics(),
    );
    itemsToDisplay += 30;

    return toRet;
  }

  Future<int> getDataRetrieveError(int statusCode) async {
    switch (statusCode) {
      case 400:
        errorMessage = "Unknown error has occured";
        return 1;
      case 503:
        errorMessage = 'Cannot connect to server!';
        return 3;
      default:
        return 3;
    }
  }
}

class RecipePage extends StatefulWidget {
  final int ID;

  const RecipePage(this.ID);

  @override
  _RecipePageState createState() => _RecipePageState(ID);
}

class _RecipePageState extends State<RecipePage> {
  final int ID;

  _RecipePageState(this.ID);

  RecipeData recipeToDisplay = RecipeData.create();

  @override
  void initState() {
    super.initState();
  }

  String errorMessage = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: white,
          actions: [
            IconButton(
              onPressed: () {
                setState(() {});
              },
              icon:
                  const Icon(Icons.favorite_border, color: Colors.transparent),
              iconSize: topBarIconSize,
            ),
          ],
          leading: IconButton(
            icon: const Icon(Icons.navigate_before, color: black),
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
          child: FutureBuilder(
            future: getFullRecipeData(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.active:
                case ConnectionState.waiting:
                  return const CircularProgressIndicator();
                case ConnectionState.done:
                  if (snapshot.hasError) {
                    return Text('Error: $snapshot.error}');
                  }
                  return Column(
                    children: <Widget>[
                      Container(
                        width: MediaQuery.of(context).size.width / 2,
                        height: MediaQuery.of(context).size.width / 2,
                        margin: const EdgeInsets.symmetric(vertical: 20),
                        child: Image.network(
                          recipeToDisplay.imageUrl,
                          fit: BoxFit.contain,
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        margin: const EdgeInsets.symmetric(vertical: 20),
                        child: Text(
                          recipeToDisplay.name,
                          style: const TextStyle(
                            fontSize: 36,
                            color: black,
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
                                'Food Categories',
                                style: TextStyle(
                                  fontSize: ingredientInfoFontSize,
                                  color: black,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 5),
                                child: Text(
                                  'thing',
                                  style: ingredientInfoTextStyle,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Text(
                        errorMessage,
                        style: errorTextStyle,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Column(
                            children: <Widget>[
                              Text(
                                'Expiration Date(s)',
                                style: ingredientInfoTextStyle,
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ],
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height,
                        padding: const EdgeInsets.fromLTRB(5, 20, 5, 0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            SizedBox(
                              width: MediaQuery.of(context).size.width,
                              child: Text(
                                'Ingredients:',
                                style: ingredientInfoTextStyle,
                                textAlign: TextAlign.left,
                              ),
                            ),
                            Expanded(
                              child: BuildIngredientList(),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
              }
              return const CircularProgressIndicator();
            },
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
            border:
                Border(top: BorderSide(color: black.withOpacity(.2), width: 3)),
            color: white,
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
                      onPressed: () {
                        Navigator.restorablePushReplacementNamed(
                            context, '/food');
                      },
                      icon: const Icon(Icons.egg),
                      iconSize: bottomIconSize,
                      color: bottomRowIcon,
                    ),
                    Text(
                      'Ingredients',
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
                      onPressed: () {},
                      icon: const Icon(Icons.restaurant),
                      iconSize: bottomIconSize,
                      color: mainScheme,
                    ),
                    Text(
                      'Recipes',
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

  Future<void> getFullRecipeData() async {
    recipeToDisplay = await fetchRecipeData();
    setState(() {});
  }

  Widget BuildIngredientList() {
    if (recipeToDisplay.ingredients.length == 0) {
      return Container();
    }

    List<IngredientData> ingreds = recipeToDisplay.ingredients;

    ListView toRet = ListView.builder(
      padding: const EdgeInsets.all(10),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: ingreds.length,
      itemBuilder: (BuildContext context, int index) {
        return Row(
          children: <Widget>[
            const Text('\u2022', style: TextStyle(fontSize: 20, color: black)),
            Expanded(
              child: Text(
                ingreds[index].name,
                style: ingredientInfoTextStyle,
              ),
            ),
          ],
        );
      },
    );

    return toRet;
  }

  Future<int> getError(int status) async {
    switch (status) {
      case 400:
        errorMessage = "Incorrect Request Format";
        return 1;
      case 404:
        errorMessage = 'Recipe not found';
        return 3;
      default:
        return 3;
    }
  }

  Future<RecipeData> fetchRecipeData() async {
    RecipeData recipe = RecipeData.create();
    final res = await Recipes.getRecipeByID(ID);
    if (res.statusCode == 200) {
      var data = json.decode(res.body);
      recipe.putRecipe(data);
    }
    return recipe;
  }
}

class RecipeInstructionPage extends StatefulWidget {
  List<Instruction> instructionList;
  int stepNum;

  RecipeInstructionPage(this.instructionList, this.stepNum);

  @override
  _RecipeInstructionPageState createState() =>
      _RecipeInstructionPageState(instructionList, stepNum);
}

class _RecipeInstructionPageState extends State<RecipeInstructionPage> {
  List<Instruction> instructionList;
  int stepNum;

  _RecipeInstructionPageState(this.instructionList, this.stepNum);

  @override
  void initState() {
    super.initState();
  }

  String errorMessage = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: white,
          leading: IconButton(
            icon: const Icon(Icons.navigate_before, color: black),
            iconSize: 35,
            onPressed: () {
              if (stepNum == 1) {
                bool goBack = false;
                showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text('Before you go back...'),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        elevation: 15,
                        actions: <Widget>[
                          TextButton(
                            onPressed: () {
                              goBack = false;
                              Navigator.pop(context, 'Cancel');
                            },
                            child: const Text(
                              'Cancel',
                              style: TextStyle(color: Colors.red, fontSize: 18),
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              goBack = true;
                              Navigator.pop(context, 'Back to recipe page');
                            },
                            child: const Text(
                              'Go back',
                              style: TextStyle(color: Colors.red, fontSize: 18),
                            ),
                          )
                        ],
                        content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: const <Widget>[
                              Flexible(
                                  child: Text(
                                      'Would you like to go back to the recipe page?\nNo items will be removed from your inventory.')),
                            ]),
                      );
                    });
                if (goBack) {
                  Navigator.pop(context);
                }
              } else {
                Navigator.pop(context);
              }
            },
          )),
      body: SingleChildScrollView(
        child: Container(),
      ),
    );
  }
}
