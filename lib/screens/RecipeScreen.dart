import 'dart:convert';
import 'package:flutter/material.dart';
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
  Future<bool>? done;

  @override
  void initState() {
    super.initState();
    recipeScroll = ScrollController()..addListener(_scrollListener);
    done = getRecipes();
  }

  @override
  void dispose() {
    recipeScroll.removeListener(_scrollListener);
    super.dispose();
  }

  Map<String, List<RecipeData>> recipes = {};
  List<String> cuisineFilter = [];
  List<String> dietFilter = [];
  List<String> mealTypeFilter = [];
  late ScrollController recipeScroll;
  String errorMessage = 'No recipes to list!';
  int itemsToDisplay = 30;
  int page = 1;
  int totalPages = 0;
  bool noMoreItems = false;
  bool sortingDrawer = false;

  Future<bool> getRecipes() async {
    await retrieveRecipes();
    return true;
  }

  void _scrollListener() {
    if (recipeScroll.position.atEdge) {
      bool isTop = recipeScroll.position.pixels == 0;
      if (!isTop) {
        page++;
        done = getRecipes();
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
          shrinkWrap: true,
          children: <Widget>[
            Container(
              height: 120,
              padding: const EdgeInsets.only(top: 5),
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
                child: TextButton(
                  onPressed: () {
                    page = 1;
                    itemsToDisplay = 30;
                    noMoreItems = false;
                    done = getRecipes();
                    setState(() {});
                    Navigator.pop(context);
                  },
                  child: const Text(
                    'Apply filters',
                    style: TextStyle(
                      color: Colors.blueAccent,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(5),
                child: TextButton(
                  child: const Text(
                    'Remove all filters',
                    style: TextStyle(
                      color: Colors.redAccent,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                  onPressed: () {
                    cuisineFilter = [];
                    dietFilter = [];
                    mealTypeFilter = [];
                    noMoreItems = false;
                    page = 1;
                    itemsToDisplay = 30;
                    done = getRecipes();
                    setState(() {});
                    Navigator.pop(context);
                  },
                ),
              ),
            ]),
            Column(children: <Widget>[
              const Text(
                'Filter by cuisine',
                style: TextStyle(
                  fontSize: 18,
                  color: black,
                ),
                textAlign: TextAlign.left,
              ),
              ListView.builder(
                itemCount: cuisinesList.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return CheckboxListTile(
                    title: Text(cuisinesList[index]),
                    dense: true,
                    checkColor: mainScheme,
                    value: cuisineFilter.contains(cuisinesList[index]),
                    onChanged: (bool? value) {
                      if (value!) {
                        cuisineFilter.add(cuisinesList[index]);
                      } else {
                        cuisineFilter.remove(cuisinesList[index]);
                      }
                      setState(() {});
                    },
                  );
                },
              ),
              const Text(
                'Filter by diet',
                style: TextStyle(
                  fontSize: 18,
                  color: black,
                ),
                textAlign: TextAlign.left,
              ),
              ListView.builder(
                itemCount: dietsList.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return CheckboxListTile(
                    title: Text(dietsList[index]),
                    dense: true,
                    checkColor: mainScheme,
                    value: dietFilter.contains(dietsList[index]),
                    onChanged: (bool? value) {
                      if (value!) {
                        dietFilter.add(dietsList[index]);
                      } else {
                        dietFilter.remove(dietsList[index]);
                      }
                      setState(() {});
                    },
                  );
                },
              ),
              const Text(
                'Filter by meal type',
                style: TextStyle(
                  fontSize: 18,
                  color: black,
                ),
                textAlign: TextAlign.left,
              ),
              ListView.builder(
                itemCount: mealTypesList.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return CheckboxListTile(
                    title: Text(mealTypesList[index]),
                    dense: true,
                    checkColor: mainScheme,
                    value: mealTypeFilter.contains(mealTypesList[index]),
                    onChanged: (bool? value) {
                      if (value!) {
                        mealTypeFilter.add(mealTypesList[index]);
                      } else {
                        mealTypeFilter.remove(mealTypesList[index]);
                      }
                      setState(() {});
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
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            height: bodyHeight,
            child: Column(
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: ListView.builder(
                    itemCount: cuisineFilter.length,
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      return Container(
                        width: MediaQuery.of(context).size.width,
                        height: 20,
                        padding: const EdgeInsets.all(5),
                        child: Text(
                          cuisineFilter[index],
                          style: ingredientInfoTextStyle,
                        ),
                      );
                    },
                  ),
                ),
                Expanded(
                  flex: 9,
                  child: FutureBuilder(
                    future: done,
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      switch (snapshot.connectionState) {
                        case ConnectionState.none:
                        case ConnectionState.active:
                        case ConnectionState.waiting:
                          return const Center(child: CircularProgressIndicator());
                        case ConnectionState.done:
                          if (snapshot.hasError) {
                            return Text('Error: $snapshot.error}');
                          }
                          List<Widget> body = buildTiles();
                          if (body.length == 0) {
                            return ListTile(
                              contentPadding: const EdgeInsets.all(15),
                              title: Text(
                                errorMessage,
                                style: noMoreTextStyle,
                                textAlign: TextAlign.center,
                              ),
                            );
                          }
                          return ListView.builder(
                            itemCount: body.length,
                            shrinkWrap: true,
                            controller: recipeScroll,
                            itemBuilder: (context, index) {
                              return body[index];
                            },
                          );
                      }
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

  Future<void> retrieveRecipes() async {
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
          if (cats[1].isEmpty) continue;
          List<RecipeData> rec = [];
          for (var reci in cats[1]) {
            rec.add(RecipeData.create().putRecipe(reci));
          }
          recipes[cats[0]] = rec;
        }
        success = true;
      } else {
        int errorCode = await getDataRetrieveError(res.statusCode);
        if (errorCode == 3) {
          errorDialog(context);
        }
      }
    } while (!success);
  }

  List<Widget> buildTiles() {
    int itemsDisplayed = 0;
    List<Widget> toRet = [];
    for (var cat in recipes.keys) {
      toRet.add(Text(
        cat,
        style: const TextStyle(
          fontSize: addIngredientPageTextSize,
          color: searchFieldText,
        ),
      ));
      toRet.add(
        GridView.builder(
          itemCount: itemsToDisplay - itemsDisplayed < recipes[cat]!.length
              ? itemsToDisplay - itemsDisplayed
              : recipes[cat]!.length,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            RecipeData item = recipes[cat]![index];

            itemsDisplayed++;
            return GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () {
                recipeId = item.ID;
                Navigator.restorablePushNamed(context, '/recipe/recipe');
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
          physics: const NeverScrollableScrollPhysics(),
        ),
      );
    }
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
  Future<bool>? done;

  @override
  void initState() {
    super.initState();
    done = getFullRecipeData();
  }

  String errorMessage = '';
  int numServings = 0;
  List<int> servingNums = [1, 2, 3, 4, 5, 6];
  List<IngredientData> missingIngredients = [];
  bool missing = false;

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
            future: done,
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
                  return Container(
                      padding: const EdgeInsets.all(5),
                      child: Column(
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
                          const SizedBox(
                            height: 10,
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
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                'Servings:',
                                style: ingredientInfoTextStyle,
                              ),
                              Container(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
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
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
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
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
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
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                'Cuisine types: ',
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
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                'Diet fulfilments: ',
                                style: ingredientInfoTextStyle,
                                textAlign: TextAlign.left,
                              ),
                              Flexible(
                                child: Text(
                                  recipeToDisplay.diets.join(', '),
                                  style: ingredientInfoTextStyle,
                                  textAlign: TextAlign.left,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                'Meal types: ',
                                style: ingredientInfoTextStyle,
                                textAlign: TextAlign.left,
                              ),
                              Flexible(
                                child: Text(
                                  recipeToDisplay.types.join(', '),
                                  style: ingredientInfoTextStyle,
                                  textAlign: TextAlign.left,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width,
                            padding: const EdgeInsets.all(5),
                            child: Text(
                              'Ingredients:',
                              style: ingredientInfoTextStyle,
                              textAlign: TextAlign.left,
                            ),
                          ),
                          ListView.builder(
                            padding: const EdgeInsets.all(5),
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: recipeToDisplay.ingredients.length,
                            itemBuilder: (BuildContext context, int index) {
                              IngredientData ingred =
                                  recipeToDisplay.ingredients[index];
                              bool hasIngred =
                                  missingIngredients.contains(ingred);
                              return Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text('\u2022 ',
                                      style: ingredientInfoTextStyle),
                                  Expanded(
                                    child: Text(
                                      ingred.name,
                                      style: TextStyle(
                                        fontSize: ingredientInfoFontSize,
                                        color: hasIngred ? Colors.red : black,
                                      ),
                                    ),
                                  ),
                                  if (!hasIngred)
                                    const Icon(
                                      Icons.clear,
                                      color: Colors.red,
                                    ),
                                ],
                              );
                            },
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width,
                            padding: const EdgeInsets.all(5),
                            child: Text(
                              'Instructions:',
                              style: ingredientInfoTextStyle,
                              textAlign: TextAlign.left,
                            ),
                          ),
                          ListView.builder(
                            padding: const EdgeInsets.all(10),
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: recipeToDisplay.instructions.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Container(
                                    alignment: Alignment.topLeft,
                                    child: Text(
                                      'Step ${index + 1}: ',
                                      style: const TextStyle(
                                        fontSize: ingredientInfoFontSize,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      '${recipeToDisplay.instructions[index].instruction}',
                                      style: ingredientInfoTextStyle,
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Expanded(
                                flex: 5,
                                child: Container(
                                  height: 75,
                                  padding: const EdgeInsets.all(5),
                                  child: ElevatedButton(
                                    onPressed: () async {
                                      await addMissingIngredients();
                                    },
                                    style: buttonStyle,
                                    child: const Text(
                                      'Add missing Ingredients To Shopping Cart',
                                      style: TextStyle(
                                        fontSize: 18,
                                        color: white,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 5,
                                child: Container(
                                  height: 75,
                                  padding: const EdgeInsets.all(5),
                                  child: ElevatedButton(
                                    onPressed: () async {
                                      if (missing) {
                                        bool addSome =
                                            await holdOnDialog(context);
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
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          )
                        ],
                      ));
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

  Future<bool> getFullRecipeData() async {
    await fetchRecipeData();
    return true;
  }

  Future<void> fetchRecipeData() async {
    final res = await Recipes.getRecipeByID(recipeId);
    if (res.statusCode == 200) {
      var data = json.decode(res.body);
      recipeToDisplay.putRecipe(data);
    }
    for (var ingreds in recipeToDisplay.ingredients) {
      bool hasIngred = searchInventory(ingreds);
      if (!hasIngred) {
        missing = true;
        missingIngredients.add(ingreds);
      }
    }
    return;
  }

  Future<bool> holdOnDialog(BuildContext context) async {
    var ret = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Hold On!', style: TextStyle(fontSize: 40)),
          scrollable: true,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          elevation: 15,
          actions: <Widget>[
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context, false);
              },
              style: buttonStyle,
              child: const Text(
                "Don't Add",
                style: TextStyle(color: white, fontSize: 22),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context, true);
              },
              style: buttonStyle,
              child: const Text(
                "Add!",
                style: TextStyle(color: white, fontSize: 22),
              ),
            ),
          ],
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Flexible(
                child: Text(
                  'It seems you don\'t have all the necessary ingredients to make this recipe. You are missing the following:',
                  style: ingredientInfoTextStyle,
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              for (var item in missingIngredients)
                Flexible(
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: Text(
                      '\u2022 ${item.name}',
                      style: ingredientInfoTextStyle,
                      textAlign: TextAlign.left,
                    ),
                  ),
                ),
              const SizedBox(
                height: 10,
              ),
              Flexible(
                child: Text(
                  'Would you like to add these ingredients to your shopping cart? You\'ll have the option to add other ingredients from this recipe as well.',
                  style: ingredientInfoTextStyle,
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        );
      },
    );
    if (ret == true) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> addMissingIngredients() async {
    List<IngredientData> itemsToAdd = List.from(missingIngredients);
    var ret = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          scrollable: true,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          elevation: 15,
          actions: <Widget>[
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context, false);
              },
              style: buttonStyle,
              child: const Text(
                "Cancel",
                style: TextStyle(color: white, fontSize: 22),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context, true);
              },
              style: buttonStyle,
              child: const Text(
                "Add!",
                style: TextStyle(color: white, fontSize: 22),
              ),
            ),
          ],
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const Flexible(
                child: Text(
                  'Select the ingredients to add to your cart:',
                  style: TextStyle(
                    fontSize: 24,
                    color: black,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              for (var item in recipeToDisplay.ingredients)
                CheckboxListTile(
                  title: Text(item.name, style: ingredientInfoTextStyle),
                  dense: true,
                  checkColor: mainScheme,
                  value: itemsToAdd.contains(item),
                  onChanged: (bool? value) {
                    if (value!) {
                      itemsToAdd.add(item);
                    } else {
                      itemsToAdd.remove(item);
                    }
                    setState(() {});
                  },
                ),
            ],
          ),
        );
      },
    );
    if (ret == true) {
      return true;
    } else {
      return false;
    }
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
