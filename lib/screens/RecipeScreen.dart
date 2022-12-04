import 'dart:convert';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:smart_chef/APIfunctions/APIutils.dart';
import 'package:smart_chef/APIfunctions/ingredientAPI.dart';
import 'package:smart_chef/APIfunctions/inventoryAPI.dart';
import 'package:smart_chef/APIfunctions/recipeAPI.dart';
import 'package:smart_chef/APIfunctions/userAPI.dart';
import 'package:smart_chef/utils/colors.dart';
import 'package:smart_chef/utils/globals.dart';
import 'package:smart_chef/utils/ingredientData.dart';
import 'package:smart_chef/utils/recipeData.dart';
import 'package:smart_chef/utils/recipeUtils.dart';

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
  List<String> mealTypeFilter = [];
  late ScrollController recipeScroll;
  String errorMessage = 'No recipes to list!';
  String filters = '';
  int itemsToDisplay = 30;
  int page = 1;
  int totalPages = 0;
  bool noMoreItems = false;
  bool sortingDrawer = false;

  Future<void> makeTiles() async {
    recipes.addAll(await retrieveRecipes());
    body = BuildTiles();
  }

  void _scrollListener() {
    if (recipeScroll.position.atEdge) {
      bool isTop = recipeScroll.position.pixels == 0;
      if (!isTop) {
        page++;
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
                        onSubmitted: (query) {},
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
            Row(children: <Widget>[
              Container(
                  padding: const EdgeInsets.all(5),
                  child: RichText(
                      text: TextSpan(
                          text: 'Apply filters',
                          style: const TextStyle(
                            color: Colors.blueAccent,
                            decoration: TextDecoration.underline,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              page = 1;
                              itemsToDisplay = 30;
                              noMoreItems = false;
                              setState(() {});
                            }))),
              Container(
                  padding: const EdgeInsets.all(5),
                  child: RichText(
                      text: TextSpan(
                          text: 'Remove all filters',
                          style: const TextStyle(
                            color: Colors.redAccent,
                            decoration: TextDecoration.underline,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              cuisineFilter = [];
                              dietFilter = [];
                              mealTypeFilter = [];
                              noMoreItems = false;
                              page = 1;
                              itemsToDisplay = 30;
                              setState(() {});
                            }))),
            ]),
            Column(children: <Widget>[
              const Expanded(
                  child: Text(
                'Filter by cuisine',
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
                'Filter by diet',
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
              const Expanded(
                  child: Text(
                'Filter by meal type',
                style: TextStyle(
                  fontSize: 18,
                  color: black,
                ),
                textAlign: TextAlign.left,
              )),
              ListView.builder(
                itemCount: mealTypesList.length,
                itemBuilder: (context, index) {
                  return CheckboxListTile(
                    title: Text(mealTypesList[index]),
                    dense: true,
                    checkColor: mainScheme,
                    value: false,
                    onChanged: (bool? value) {
                      if (value!) {
                        mealTypeFilter.add(mealTypesList[index]);
                      } else {
                        mealTypeFilter.remove(mealTypesList[index]);
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
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Column(
              children: <Widget>[
                Expanded(
                  child: Text(
                    filters,
                    style: ingredientInfoTextStyle,
                  ),
                ),
                Expanded(
                  flex: 9,
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
                                style: noMoreTextStyle,
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
                if (noMoreItems)
                  Text(
                    'Sorry, there are no more recipes to show!',
                    style: noMoreTextStyle,
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
    List<RecipeData> recipes = [];

    final res = await Recipes.searchRecipes(
        _search.value.text,
        resultsPerPage,
        page,
        '',
        '',
        cuisineFilter.join(','),
        dietFilter.join(','),
        mealTypeFilter.join(','));
    bool success = false;
    do {
      if (res.statusCode == 200) {
        var data = json.decode(res.body);
        totalPages = data.containsKey('numOfPages') ? data['numOfPages'] : 0;

        int currentPage = data.containsKey('currentPage')
            ? int.parse(data['currentPage'])
            : page;
        if (currentPage == totalPages) {
          noMoreItems = true;
        }
        for (var cats in data['results']) {
          recipes.add(await RecipeData.create().putRecipe(cats));
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
  @override
  _RecipePageState createState() => _RecipePageState();
}

class _RecipePageState extends State<RecipePage> {
  RecipeData recipeToDisplay = RecipeData.create();

  @override
  void initState() {
    super.initState();
  }

  String errorMessage = '';
  int numServings = 0;
  List<int> servingNums = [1, 2, 3, 4, 5, 6];
  bool missingIngredients = false;
  Widget ingredientList = Container();
  Widget instructionsList = Container();

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
            initialData: false,
            future: getFullRecipeData(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.none:
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
                          Text(
                            'Servings:',
                            style: ingredientInfoTextStyle,
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            decoration: const BoxDecoration(
                              borderRadius: BorderRadius.all(
                                  Radius.circular(roundedCorner)),
                              color: mainScheme,
                            ),
                            child: recipeToDisplay.servings != 0
                                ? DropdownButton<int>(
                                    value: recipeToDisplay.servings,
                                    icon: const Icon(Icons.arrow_drop_down,
                                        color: white),
                                    onChanged: (int? value) {
                                      setState(() => numServings = value!);
                                    },
                                    items: servingNums
                                        .map<DropdownMenuItem<int>>(
                                            (int value) {
                                      return DropdownMenuItem<int>(
                                        value: value,
                                        child: Text(value.toString()),
                                      );
                                    }).toList())
                                : Text(
                                    'No servings listed',
                                    style: ingredientInfoTextStyle,
                                  ),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.all(5),
                        child: Row(children: <Widget>[
                          Text(
                            'Time to cook: ',
                            style: ingredientInfoTextStyle,
                            textAlign: TextAlign.left,
                          ),
                          Text(
                            '${recipeToDisplay.timeToCook.toString()} minutes',
                            style: ingredientInfoTextStyle,
                            textAlign: TextAlign.left,
                          )
                        ]),
                      ),
                      Container(
                        padding: const EdgeInsets.all(5),
                        child: Row(children: <Widget>[
                          Text(
                            'Time to Prepare: ',
                            style: ingredientInfoTextStyle,
                            textAlign: TextAlign.left,
                          ),
                          Flexible(
                            child: Text(
                              '${recipeToDisplay.timeToPrepare.toString()} minutes',
                              style: ingredientInfoTextStyle,
                              textAlign: TextAlign.left,
                            ),
                          ),
                        ]),
                      ),
                      Container(
                        padding: const EdgeInsets.all(5),
                        child: Row(children: <Widget>[
                          Text(
                            'Cuisine types:',
                            style: ingredientInfoTextStyle,
                            textAlign: TextAlign.left,
                          ),
                          Flexible(
                            child: Text(
                              recipeToDisplay.cuisines.join(','),
                              style: ingredientInfoTextStyle,
                              textAlign: TextAlign.left,
                            ),
                          ),
                        ]),
                      ),
                      Container(
                        padding: const EdgeInsets.all(5),
                        child: Row(children: <Widget>[
                          Text(
                            'Diet fulfilments:',
                            style: ingredientInfoTextStyle,
                            textAlign: TextAlign.left,
                          ),
                          Flexible(
                              child: Text(
                            recipeToDisplay.diets.join(', '),
                            style: ingredientInfoTextStyle,
                            textAlign: TextAlign.left,
                          )),
                        ]),
                      ),
                      Container(
                        padding: const EdgeInsets.all(5),
                        child: Row(children: <Widget>[
                          Text(
                            'Meal type:',
                            style: ingredientInfoTextStyle,
                            textAlign: TextAlign.left,
                          ),
                          Text(
                            recipeToDisplay.type.toString(),
                            style: ingredientInfoTextStyle,
                            textAlign: TextAlign.left,
                          )
                        ]),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 5, vertical: 10),
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
                              child: ingredientList,
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 5, vertical: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            SizedBox(
                              width: MediaQuery.of(context).size.width,
                              child: Text(
                                'Instructions:',
                                style: ingredientInfoTextStyle,
                                textAlign: TextAlign.left,
                              ),
                            ),
                            Expanded(
                              child: instructionsList,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width / 1.2,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Expanded(
                              flex: 5,
                              child: Container(
                                padding: const EdgeInsets.all(5),
                                child: ElevatedButton(
                                  onPressed: () async {
                                    await addMissingIngredients();
                                  },
                                  style: buttonStyle,
                                  child: const Text(
                                    'Add missing Ingredients To Shopping Cart',
                                    style: TextStyle(
                                        fontSize: 14,
                                        color: white,
                                        fontFamily: 'EagleLake'),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 5,
                              child: Container(
                                padding: const EdgeInsets.all(5),
                                child: ElevatedButton(
                                  onPressed: () async {
                                    if (missingIngredients) {
                                      bool addSome = await holdOnDialog();
                                      if (addSome) {
                                        bool success =
                                            await addMissingIngredients();
                                      }
                                    } else {
                                      String finished =
                                          Navigator.restorablePushNamed(
                                              context, '/recipe/recipe/steps',
                                              arguments: 1);
                                      if (finished.isEmpty) {
                                        List<int>
                                            ingredientsToRemoveFromInventoryIDs =
                                            await finishedDialog();
                                        bool success =
                                            await removeIngredientsFromInventory(
                                                ingredientsToRemoveFromInventoryIDs);
                                      }
                                    }
                                  },
                                  style: buttonStyle,
                                  child: const Text(
                                    'Make!',
                                    style: TextStyle(
                                        fontSize: 20,
                                        color: white,
                                        fontFamily: 'EagleLake'),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  );
              }
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

  Future<bool> getFullRecipeData() async {
    recipeToDisplay = await fetchRecipeData();
    ingredientList = await buildIngredientList();
    instructionsList = await buildInstructionList();
    return true;
  }

  Future<Widget> buildIngredientList() async {
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
            Text('\u2022', style: ingredientInfoTextStyle),
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

  Future<Widget> buildInstructionList() async {
    if (recipeToDisplay.instructions.length == 0) {
      return Container();
    }

    List<Instruction> instructs = recipeToDisplay.instructions;

    ListView toRet = ListView.builder(
      padding: const EdgeInsets.all(10),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: instructs.length,
      itemBuilder: (BuildContext context, int index) {
        return Row(
          children: <Widget>[
            Expanded(
              child: Text(
                'Step $index: ${instructs[index].instruction}',
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
    RecipeData toRet = RecipeData.create();
    final res = await Recipes.getRecipeByID(recipeId);
    if (res.statusCode == 200) {
      var data = json.decode(res.body);
      await toRet.putRecipe(data);
    }
    return toRet;
  }

  Future<bool> holdOnDialog() async {
    bool adding = false;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Container();
      },
    );
    return adding;
  }

  Future<bool> addMissingIngredients() async {
    bool success = false;
    return success;
  }

  Future<List<int>> finishedDialog() async {
    List<int> ingredsID = [];
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container();
      },
    );
    return ingredsID;
  }

  Future<bool> removeIngredientsFromInventory(List<int> IDS) async {
    bool success = false;
    return success;
  }
}

class RecipeInstructionPage extends StatefulWidget {
  int stepNum;

  RecipeInstructionPage(this.stepNum);

  @override
  _RecipeInstructionPageState createState() =>
      _RecipeInstructionPageState(stepNum);
}

class _RecipeInstructionPageState extends State<RecipeInstructionPage> {
  int stepNum;

  _RecipeInstructionPageState(this.stepNum);

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
        child: Center(
          child: Column(
            children: <Widget>[
              Text(
                'Step $stepNum:',
                style: const TextStyle(
                  fontSize: 32,
                  color: black,
                ),
                textAlign: TextAlign.center,
              ),
              Text(
                instructionList[stepNum].instruction,
                style: const TextStyle(
                  fontSize: 32,
                  color: black,
                ),
                textAlign: TextAlign.center,
              ),
              const Text(
                'Ingredients for this step:',
                style: TextStyle(
                  fontSize: 24,
                  color: black,
                ),
              ),
              instructionIngredients(
                  instructionList[stepNum].ingredientsInStep),
              ElevatedButton(
                onPressed: () {
                  if (stepNum + 1 == instructionList.length) {
                    Navigator.popUntil(
                        context, ModalRoute.withName('/recipe/recipe'));
                  } else {
                    Navigator.restorablePushNamed(
                        context, '/recipe/recipe/steps',
                        arguments: stepNum + 1);
                  }
                },
                style: buttonStyle,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    const Text(
                      'Next Step',
                      style: TextStyle(
                          fontSize: 14,
                          color: Colors.white,
                          fontFamily: 'EagleLake'),
                      textAlign: TextAlign.center,
                    ),
                    Icon(
                      Icons.arrow_forward,
                      size: topBarIconSize,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  ListView instructionIngredients(List<IngredientData> ingreds) {
    return ListView.builder(
        itemCount: ingreds.length,
        itemBuilder: (context, index) {
          return Row(children: <Widget>[
            const Text('\u2022', style: TextStyle(fontSize: 24, color: black)),
            Expanded(
              child: Text(
                ingreds[index].name,
                style: const TextStyle(fontSize: 24, color: black),
              ),
            ),
          ]);
        });
  }
}
