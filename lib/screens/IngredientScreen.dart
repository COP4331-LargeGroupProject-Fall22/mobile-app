import 'dart:convert';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:smart_chef/screens/LoadingOverlay.dart';
import 'package:smart_chef/utils/APIutils.dart';
import 'package:smart_chef/utils/authAPI.dart';
import 'package:smart_chef/utils/colors.dart';
import 'package:smart_chef/utils/globals.dart';
import 'package:smart_chef/utils/ingredientAPI.dart';
import 'package:smart_chef/utils/ingredientData.dart';
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
    inventoryScroll = ScrollController()..addListener(_scrollListener);
  }

  @override
  void dispose() {
    inventoryScroll.removeListener(_scrollListener);
    super.dispose();
  }

  late List<Widget> body;
  Map<String, List<IngredientData>> userInventory = {};
  late ScrollController inventoryScroll;
  String errorMessage = 'You have no items in your inventory!';

  Future<void> makeTiles() async {
    userInventory = await retrieveInventory(_groupValue);
    body = await BuildTiles();
  }

  Icon leadingIcon = const Icon(Icons.search, color: black);
  Widget searchBar = const Text('SmartChef',
      style: TextStyle(fontSize: 24, color: mainScheme));
  final _search = TextEditingController();

  int _groupValue = 0;
  int itemsToDisplay = 30;

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
          IconButton(
            icon: const Icon(
              Icons.clear,
              color: Colors.red,
            ),
            iconSize: topBarIconSize,
            onPressed: () async {
              bool delete = false;
              await showDialog(
                context: context,
                barrierDismissible: true,
                builder: (context) {
                  return AlertDialog(
                    title: const Text(
                        'Are you sure you want to clear your inventory?'),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    elevation: 15,
                    actions: <Widget>[
                      TextButton(
                        onPressed: () {
                          delete = false;
                          Navigator.pop(context);
                        },
                        child: const Text(
                          'Cancel',
                          style: TextStyle(color: Colors.red, fontSize: 18),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          delete = true;
                          Navigator.pop(context);
                        },
                        child: const Text(
                          'Yes',
                          style: TextStyle(color: Colors.red, fontSize: 18),
                        ),
                      )
                    ],
                  );
                },
              );

              if (!delete) {
                return;
              }

              try {
                for (var cat in userInventory.keys) {
                  if (userInventory[cat]!.length == 0) {
                    continue;
                  }
                  for (var ingreds in userInventory[cat]!) {
                    print(ingreds.toString());
                    final res = await Inventory.deleteIngredientfromInventory(
                        ingreds.ID);
                    if (res.statusCode == 200) {
                      errorMessage =
                      'Successfully cleared your inventory!';
                      await messageDelay;
                      Navigator.pop(context);
                    } else {
                      int errorCode = await getDeleteError(res.statusCode);
                      if (errorCode == 2) {
                        final ret = await Inventory.deleteIngredientfromInventory(
                            ingreds.ID);
                        if (ret.statusCode == 200) {
                          errorMessage =
                          'Successfully deleted ingredient from inventory!';
                          await messageDelay;
                          Navigator.pop(context);
                        } else {
                          errorDialog(context);
                        }
                      }
                    }
                  }
                }
              } catch(e) {
                print(e.toString());
                errorMessage = 'Cannot clear Inventory!';
              }
              setState(() {});
            }),
          Builder(builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(
                Icons.manage_search,
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
                  'Sort by...',
                  style: TextStyle(
                    fontSize: 24,
                    color: black,
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
                      fontSize: ingredientInfoFontSize,
                      color: black,
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
        child: SingleChildScrollView(
          controller: inventoryScroll,
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: bodyHeight,
            decoration: const BoxDecoration(color: white),
            child: Column(
              children: <Widget>[
                Container(
                    margin: const EdgeInsets.all(10),
                    width: MediaQuery.of(context).size.width,
                    decoration: const BoxDecoration(
                      color: Colors.transparent,
                    ),
                    child: Text(sorted,
                        style: const TextStyle(
                          fontSize: ingredientInfoFontSize,
                          color: black,
                        ))),
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
                          if (body.length == 0) {
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
                          return ListView.builder(
                            itemCount: body.length,
                            itemBuilder: (context, index) {
                              return body[index];
                            },
                          );
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
        foregroundColor: white,
        elevation: 25,
        child: const Icon(Icons.add, size: 65, color: white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  void _scrollListener() {
    if (inventoryScroll.position.atEdge) {
      bool isTop = inventoryScroll.position.pixels == 0;
      if (!isTop) {
        makeTiles();
      }
    }
  }

  DateTime convertToDate(int secondEpoch) {
    var date = DateTime.fromMicrosecondsSinceEpoch(secondEpoch * 1000);
    return date;
  }

  int convertToEpoch(DateTime date) {
    return date.toUtc().microsecondsSinceEpoch;
  }

  Future<Map<String, List<IngredientData>>> retrieveInventory(
      int sortBy) async {
    bool reverse = false;
    bool exDate = true;
    bool cat = false;
    bool alphabet = false;
    String toSortBy = '';
    itemsToDisplay = 30;

    Map<String, List<IngredientData>> inventory = {};

    switch (sortBy) {
      case 1:
        reverse = true;
        break;
      case 2:
        alphabet = true;
        exDate = false;
        toSortBy = 'lexigraphical';
        break;
      case 3:
        alphabet = true;
        reverse = true;
        exDate = false;
        toSortBy = 'reverseLexigraphical';
        break;
      case 4:
        cat = true;
        exDate = false;
        toSortBy = 'category';
        break;
      case 5:
        cat = true;
        reverse = true;
        exDate = false;
        toSortBy = 'categoryReversed';
        break;
      default:
        break;
    }

    final res =
        await Inventory.retrieveUserInventory(reverse, exDate, cat, alphabet);
    bool success = false;
    do {
      if (res.statusCode == 200) {
        var data = json.decode(res.body);
        for (int i = 0; i < data.length; i += 2) {
          for (var cats in data) {
            List<IngredientData> ingredients = [];
            for (var ingred in cats[1]) {
              ingredients
                  .add(IngredientData.create().inventoryIngredient(ingred));
            }
            inventory[cats[i]] = ingredients;
          }
        }
        success = true;
      } else {
        int errorCode = await getDataRetrieveError(res.statusCode);
        if (errorCode == 3) {
          errorDialog(context);
        }
      }
    } while (!success);

    return inventory;
  }

  Future<List<Widget>> BuildTiles() async {
    List<Widget> toRet = [];

    for (var cat in userInventory.keys) {
      if (userInventory[cat]!.length == 0) {
        continue;
      }
      toRet.add(Text(
        cat,
        style: const TextStyle(
          fontSize: addIngredientPageTextSize,
          color: searchFieldText,
        ),
      ));
      toRet.add(
        GridView.builder(
          itemCount: itemsToDisplay < userInventory[cat]!.length
              ? itemsToDisplay
              : userInventory[cat]!.length,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            IngredientData item = userInventory[cat]![index];
            bool expiresSoon = false;
            bool expired = false;

            double tileHeight = MediaQuery.of(context).size.height;

            if (item.expirationDate != 0) {
              DateTime expDate = convertToDate(item.expirationDate);

              if (DateTime.now().difference(expDate).inDays < 7) {
                expiresSoon = true;
              } else {
                if (expDate.difference(DateTime.now()).inDays > 0) {
                  expired = true;
                }
              }
            }
            return GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () {
                Navigator.restorablePushNamed(context, '/food/food', arguments:IngredientArguments(ingredient: item, isEditing: false, navFromAdd: false));
                setState(() {});
              },
              child: Stack(
                children: <Widget>[
                  Container(
                    height: tileHeight,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(20)),
                      color: expiresSoon
                          ? Colors.red[200]
                          : (expired ? const Color(0xffFF0000) : white),
                    ),
                    child: Align(
                      alignment: FractionalOffset.bottomLeft,
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: Text(
                                expiresSoon
                                    ? 'Expires Soon!'
                                    : (expired ? 'Expired!' : ''),
                                style: const TextStyle(
                                  color: white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Container(
                    height: tileHeight - 40,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20)),
                    ),
                    child: Image.network(
                      item.imageUrl,
                      fit: BoxFit.contain,
                    ),
                  ),
                  Container(
                    height: tileHeight - 40,
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
      case 401:
        errorMessage = 'Reconnecting...';
        if (await tryTokenRefresh()) {
          errorMessage = 'Reconnected';
          return 2;
        } else {
          errorMessage = 'Cannot connect to server';
          return 3;
        }
      case 404:
        return 3;
      case 503:
        errorMessage = 'Cannot connect to server!';
        return 3;
      default:
        return 3;
    }
  }

  Future<int> getDeleteError(int statusCode) async {
    switch (statusCode) {
      case 400:
        errorMessage = "Unknown error has occured";
        return 1;
      case 401:
        errorMessage = 'Reconnecting...';
        if (await tryTokenRefresh()) {
          errorMessage = 'Reconnected';
          return 2;
        } else {
          errorMessage = 'Cannot connect to server';
          return 3;
        }
      case 404:
        return 3;
      case 503:
        errorMessage = 'Cannot connect to server!';
        return 3;
      default:
        return 3;
    }
  }
}

class IngredientPage extends StatefulWidget {
  IngredientArguments args;

  IngredientPage(this.args);

  @override
  _IngredientPageState createState() => _IngredientPageState(args);
}

class _IngredientPageState extends State<IngredientPage> {
  IngredientArguments args;

  _IngredientPageState(this.args);

  IngredientData ingredientToDisplay = IngredientData.create();
  bool isEditing = false;
  bool navFromAddIngred = false;

  @override
  void initState() {
    super.initState();
    ingredientToDisplay = args.ingredient;
    isEditing = args.isEditing;
    navFromAddIngred = args.navFromAdd;
    getFullIngredientData();
    if (ingredientToDisplay.expirationDate != 0) {
      _selectedDate = convertToDate(ingredientToDisplay.expirationDate);
    } else {
      _selectedDate = DateTime.now();
    }
    _expirationDate.text = DateFormat.yMd().format(_selectedDate);
  }

  final _expirationDate = TextEditingController();
  bool unfilledExpirationDate = false;
  late DateTime _selectedDate;

  String errorMessage = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: white,
          actions: [
            if (isEditing)
              IconButton(
                onPressed: () async {
                  if (navFromAddIngred) {
                    Map<String, dynamic> payload = {
                      'id': ingredientToDisplay.ID,
                      'name': ingredientToDisplay.name,
                      'category': ingredientToDisplay.category,
                      'image': {'srcUrl': ingredientToDisplay.imageUrl},
                      'expirationDate': _expirationDate.text.isEmpty
                          ? 0
                          : convertToEpoch(_selectedDate)
                    };

                    final res = await Inventory.addIngredient(payload);
                    print(res.body);
                    if (res.statusCode == 201) {
                      errorMessage = 'Ingredient Added Successfully!';
                      setState(() {});
                      await messageDelay;
                      Navigator.pop(context);
                      navFromAddIngred = false;
                    } else {
                      int errorCode = await getError(res.statusCode);
                      if (errorCode == 2) {
                        final ret = await Inventory.addIngredient(payload);
                        if (ret.statusCode == 200) {
                          errorMessage = 'Ingredient Added Successfully!';
                          await messageDelay;
                          Navigator.pop(context);
                          navFromAddIngred = false;
                        } else {
                          errorDialog(context);
                        }
                      }
                    }
                  } else {
                    Map<String, dynamic> payload = {
                      'expirationDate': _expirationDate.text.isEmpty
                          ? 1
                          : convertToEpoch(_selectedDate)
                    };
                    final res = await Inventory.updateIngredientInInventory(
                        ingredientToDisplay.ID, payload);
                    if (res.statusCode == 200) {
                      errorMessage = 'Ingredient Updated Successfully!';
                      await messageDelay;
                      Navigator.pop(context);
                    } else {
                      int errorCode = await getError(res.statusCode);
                      if (errorCode == 2) {
                        final res = await Inventory.updateIngredientInInventory(
                            ingredientToDisplay.ID, payload);
                        if (res.statusCode == 200) {
                          errorMessage = 'Ingredient Updated Successfully!';
                          await messageDelay;
                          Navigator.pop(context);
                          navFromAddIngred = false;
                        } else {
                          errorDialog(context);
                        }
                      }
                    }
                  }
                },
                icon: const Icon(Icons.check, color: Colors.red),
                iconSize: topBarIconSize,
              ),
            if (!isEditing)
              IconButton(
                onPressed: () {
                  isEditing = true;
                  setState(() {});
                },
                icon: const Icon(Icons.edit, color: black),
                iconSize: topBarIconSize,
              ),
            if (!isEditing)
              IconButton(
                onPressed: () async {
                  bool delete = false;
                  await showDialog(
                    context: context,
                    barrierDismissible: true,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text(
                            'Are you sure you want to remove this ingredient from your inventory?'),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        elevation: 15,
                        actions: <Widget>[
                          TextButton(
                            onPressed: () {
                              delete = false;
                              Navigator.pop(context);
                            },
                            child: const Text(
                              'Cancel',
                              style: TextStyle(color: Colors.red, fontSize: 18),
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              delete = true;
                              Navigator.pop(context);
                            },
                            child: const Text(
                              'Yes',
                              style: TextStyle(color: Colors.red, fontSize: 18),
                            ),
                          )
                        ],
                      );
                    },
                  );

                  if (!delete) {
                    return;
                  }

                  final res = await Inventory.deleteIngredientfromInventory(
                      ingredientToDisplay.ID);
                  if (res.statusCode == 200) {
                    errorMessage =
                        'Successfully deleted ingredient from inventory!';
                    await messageDelay;
                    Navigator.pop(context);
                  } else {
                    int errorCode = await getError(res.statusCode);
                    if (errorCode == 2) {
                      final ret = await Inventory.deleteIngredientfromInventory(
                          ingredientToDisplay.ID);
                      if (ret.statusCode == 200) {
                        errorMessage =
                            'Successfully deleted ingredient from inventory!';
                        await messageDelay;
                        Navigator.pop(context);
                      } else {
                        errorDialog(context);
                      }
                    }
                  }
                },
                icon: const Icon(Icons.delete, color: Colors.red),
                iconSize: topBarIconSize,
              ),
          ],
          leading: IconButton(
            icon: const Icon(Icons.navigate_before, color: black),
            iconSize: 35,
            onPressed: () {
              if (isEditing) {
                isEditing = false;
                setState(() {});
              } else {
                Navigator.pop(context);
              }
            },
          )),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        margin: const EdgeInsets.fromLTRB(5, 10, 5, 0),
        child: SingleChildScrollView(
          child: FutureBuilder(
            future: fetchIngredientData(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                  break;
                case ConnectionState.done:
                  break;
              }
              return Column(
                children: <Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width / 2,
                    height: MediaQuery.of(context).size.width / 2,
                    margin: const EdgeInsets.symmetric(vertical: 20),
                    child: Image.network(
                      ingredientToDisplay.imageUrl,
                      fit: BoxFit.contain,
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    margin: const EdgeInsets.symmetric(vertical: 20),
                    child: Text(
                      ingredientToDisplay.name,
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
                              ingredientToDisplay.category.isEmpty
                                  ? 'Miscellaneous'
                                  : ingredientToDisplay.category,
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
                          Container(
                            width: MediaQuery.of(context).size.width / 2,
                            margin: const EdgeInsets.symmetric(horizontal: 5),
                            padding: const EdgeInsets.symmetric(
                                vertical: 5, horizontal: 5),
                            decoration: const BoxDecoration(
                              color: mainScheme,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                            ),
                            child: isEditing
                                ? TextField(
                                    focusNode: AlwaysDisabledFocusNode(),
                                    controller: _expirationDate,
                                    decoration: unfilledExpirationDate
                                        ? invalidTextField.copyWith(
                                            hintText: 'Click to choose a date')
                                        : globalDecoration.copyWith(
                                            hintText: 'Click to choose a date'),
                                    onTap: () {
                                      if (isEditing) _selectDate(context);
                                    })
                                : Text(
                                    _expirationDate.value.text,
                                    style: ingredientInfoTextStyle,
                                    textAlign: TextAlign.center,
                                  ),
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
                            'Nutrition Values:',
                            style: ingredientInfoTextStyle,
                            textAlign: TextAlign.left,
                          ),
                        ),
                        Expanded(
                          child: BuildNutrientTiles(),
                        ),
                      ],
                    ),
                  ),
                ],
              );
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

  void getFullIngredientData() async {
    ingredientToDisplay = await fetchIngredientData();
    setState(() {});
  }

  _selectDate(BuildContext context) async {
    DateTime? newSelectedDate = await showDatePicker(
        context: context,
        initialDate: _selectedDate != null ? _selectedDate : DateTime.now(),
        firstDate: DateTime(2020),
        lastDate: DateTime(2030),
        builder: (BuildContext context, Widget? child) {
          return Theme(
              data: ThemeData.dark().copyWith(
                colorScheme: const ColorScheme.dark(
                  primary: mainScheme,
                  onPrimary: black,
                  surface: Colors.grey,
                  onSurface: black,
                ),
                dialogBackgroundColor: white,
              ),
              child: child as Widget);
        });

    if (newSelectedDate != null) {
      _selectedDate = newSelectedDate;
      _expirationDate.text = DateFormat.yMd().format(_selectedDate);
    }
    setState(() {});
  }

  DateTime convertToDate(int secondEpoch) {
    var date = DateTime.fromMicrosecondsSinceEpoch(secondEpoch * 1000);
    return date;
  }

  int convertToEpoch(DateTime date) {
    return date.toUtc().microsecondsSinceEpoch;
  }

  Widget BuildNutrientTiles() {
    if (ingredientToDisplay.nutrients.length == 0) {
      return Container();
    }

    List<Nutrient> nuts = ingredientToDisplay.nutrients;

    ListView toRet = ListView.builder(
      padding: const EdgeInsets.all(10),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: nuts.length,
      itemBuilder: (BuildContext context, int index) {
        if (index == 0) {
          return Row(
            children: <Widget>[
              Expanded(
                flex: 4,
                child: Text(
                  'Nutrient Name',
                  style: ingredientInfoTextStyle,
                  textAlign: TextAlign.left,
                ),
              ),
              Expanded(
                flex: 3,
                child: Text(
                  'Amount',
                  style: ingredientInfoTextStyle,
                  textAlign: TextAlign.right,
                ),
              ),
              Expanded(
                flex: 3,
                child: Text(
                  '% value',
                  style: ingredientInfoTextStyle,
                  textAlign: TextAlign.right,
                ),
              ),
            ],
          );
        } else {
          if (nuts[index].unit.value == 0) return Container();
          return Row(
            children: <Widget>[
              Expanded(
                flex: 4,
                child: Text(
                  nuts[index].name,
                  style: ingredientInfoTextStyle,
                  textAlign: TextAlign.left,
                ),
              ),
              Expanded(
                flex: 3,
                child: Text(
                  '${nuts[index].unit.value} ${nuts[index].unit.unit}',
                  style: ingredientInfoTextStyle,
                  textAlign: TextAlign.right,
                ),
              ),
              Expanded(
                flex: 3,
                child: Text(
                  '${nuts[index].percentOfDaily}%',
                  style: ingredientInfoTextStyle,
                  textAlign: TextAlign.right,
                ),
              ),
            ],
          );
        }
      },
    );

    return toRet;
  }

  Future<int> getError(int status) async {
    switch (status) {
      case 400:
        errorMessage = "Incorrect Request Format";
        return 1;
      case 401:
        errorMessage = 'Reconnecting...';
        if (await tryTokenRefresh()) {
          errorMessage = 'Reconnected!';
          return 2;
        } else {
          errorMessage = 'Cannot connect to server';
          return 3;
        }
      case 404:
        errorMessage = 'User not found';
        return 3;
      default:
        return 3;
    }
  }

  Future<IngredientData> fetchIngredientData() async {
    IngredientData newIngred = ingredientToDisplay;
    final res = await Ingredients.getIngredientByID(newIngred.ID, 0, '');
    if (res.statusCode == 200) {
      var data = json.decode(res.body);
      newIngred.addInformationToIngredient(data);
    }
    return newIngred;
  }
}

class AddIngredientPage extends StatefulWidget {
  @override
  _AddIngredientPageState createState() => _AddIngredientPageState();
}

class _AddIngredientPageState extends State<AddIngredientPage> {
  late ScrollController loading;
  final searchController = TextEditingController();
  List<IngredientData> searchResultList = [];
  late ListView resultsList;
  late FocusNode _search;

  @override
  void initState() {
    loading = ScrollController()..addListener(_scrollListener);
    _search = FocusNode();
    _search.addListener(_onFocusChange);
    resultsList = ListView(key: key);
    super.initState();
  }

  @override
  void dispose() {
    loading.removeListener(_scrollListener);
    super.dispose();
  }

  UniqueKey key = UniqueKey();

  bool searching = false;
  bool searchChanged = false;
  String oldQuery = '';
  String errorMessage = '';
  int pageCount = 1;
  int queryID = -1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: white,
          leading: IconButton(
            icon: const Icon(Icons.navigate_before, color: black),
            iconSize: 35,
            onPressed: () {
              Navigator.pop(context);
            },
          )),
      body: SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height - bottomRowHeight,
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
                  margin: const EdgeInsets.only(
                      top: 50, bottom: 20, left: 15, right: 15),
                  child: Row(
                    children: const <Widget>[
                      Flexible(
                        child: Text(
                          'Search for an ingredient to get started',
                          style: TextStyle(
                            fontSize: addIngredientPageTextSize,
                            color: black,
                            fontWeight: FontWeight.w400,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  errorMessage,
                  style:
                      errorTextStyle.copyWith(fontSize: ingredientInfoFontSize),
                  textAlign: TextAlign.center,
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
                    return Row(
                      children: <Widget>[
                        SizedBox(
                          width: constraints.maxWidth - topBarIconSize,
                          child: TextField(
                            key: key,
                            maxLines: 1,
                            focusNode: _search,
                            controller: searchController,
                            decoration: const InputDecoration.collapsed(
                              hintText: 'Search...',
                              hintStyle: TextStyle(
                                color: searchFieldText,
                                fontSize: ingredientInfoFontSize,
                              ),
                            ),
                            style: const TextStyle(
                              color: searchFieldText,
                              fontSize: ingredientInfoFontSize,
                            ),
                            textInputAction: TextInputAction.done,
                            onChanged: (query) {
                              if (query == oldQuery) {
                                searchChanged = false;
                              } else {
                                searchChanged = true;
                              }
                            },
                            onSubmitted: (query) async {
                              if (query.isNotEmpty && searchChanged) {
                                pageCount = 1;
                                oldQuery = query;
                                setList();
                              }
                              if (query.isEmpty) {
                                oldQuery = '';
                                resultsList = ListView(
                                  controller: loading,
                                );
                              }
                              searchChanged = false;
                            },
                          ),
                        ),
                        const Icon(
                          Icons.search,
                          color: black,
                          size: topBarIconSize,
                        ),
                      ],
                    );
                  }),
                ),
                Stack(
                  alignment: Alignment.center,
                  children: <Widget>[
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          width: MediaQuery.of(context).size.width,
                          padding: const EdgeInsets.all(10),
                          child: Row(
                            children: const <Widget>[
                              Flexible(
                                child: Text(
                                  'Click on the ingredient name to continue',
                                  style: TextStyle(
                                    fontSize: 24,
                                    color: black,
                                    fontWeight: FontWeight.w400,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          padding: const EdgeInsets.only(
                              top: 100, left: 15, right: 15, bottom: 50),
                          child: Row(
                            children: const <Widget>[
                              Flexible(
                                child: Text(
                                  'Or scan a barcode to automatically add it to your inventory',
                                  style: TextStyle(
                                    fontSize: addIngredientPageTextSize,
                                    color: black,
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
                            // TODO(31): Add ability to scan barcodes
                          },
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            backgroundColor: mainScheme,
                            padding: const EdgeInsets.symmetric(
                                vertical: 15, horizontal: 25),
                            shadowColor: black,
                          ),
                          child: const Text(
                            'Scan!',
                            style: TextStyle(
                              fontSize: 50,
                              color: white,
                              fontWeight: FontWeight.w400,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                    searching
                        ? Container(
                            width: MediaQuery.of(context).size.width / 1.5,
                            height: MediaQuery.of(context).size.height / 2,
                            decoration: BoxDecoration(
                              color: white,
                              border: Border.all(color: searchFieldText),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Expanded(
                                  child: FutureBuilder(
                                    builder: (BuildContext context,
                                        AsyncSnapshot snapshot) {
                                      switch (snapshot.connectionState) {
                                        case ConnectionState.waiting:
                                          return SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                1.5,
                                            height: MediaQuery.of(context)
                                                .size
                                                .height,
                                            child: const Text(
                                              'Loading...',
                                              style: TextStyle(
                                                fontSize:
                                                    ingredientInfoFontSize,
                                                color: searchFieldText,
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                          );
                                        case ConnectionState.done:
                                          return resultsList;
                                        default:
                                          return resultsList;
                                      }
                                    },
                                  ),
                                ),
                              ],
                            ),
                          )
                        : Container(),
                  ],
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
    if (loading.position.atEdge) {
      bool isTop = loading.position.pixels == 0;
      if (!isTop) {
        setList();
      }
    }
  }

  void _onFocusChange() {
    if (_search.hasFocus) {
      searching = true;
    }
    if (!_search.hasFocus && searchController.value.text.isEmpty) {
      searching = false;
    }
  }

  void setList() async {
    resultsList = await buildSearchList(searchController.text);
    setState(() {});
  }

  Future<ListView> buildSearchList(String searchQuery) async {
    bool updated = await updateSearchList(searchQuery);

    if (searchResultList.length == 0) {
      return ListView(
        children: <Widget>[
          Align(
            alignment: Alignment.center,
            child: Container(
              width: MediaQuery.of(context).size.width / 1.5,
              color: white,
              padding: const EdgeInsets.all(10),
              child: const Text(
                'Sorry, your query produced no results',
                style: TextStyle(
                  color: searchFieldText,
                  fontSize: ingredientInfoFontSize,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(10),
      itemCount: searchResultList.length,
      controller: loading,
      itemBuilder: (BuildContext context, int index) {
        return ListTile(
            key: key,
            title: Text(
              index == searchResultList.length && !updated
                  ? 'No items to list'
                  : searchResultList[index].name,
              style: const TextStyle(
                color: searchFieldText,
                fontSize: 18,
              ),
              textAlign: TextAlign.left,
            ),
            trailing: const Icon(
              Icons.call_made,
              color: black,
              size: searchIconButtonSize,
            ),
            onTap: () async {
              errorMessage = '';
              final res = await Ingredients.getIngredientByID(
                  searchResultList[index].ID, 0, '');
              if (res.statusCode == 200) {
                var data = json.decode(res.body);
                IngredientData toPass = searchResultList[index];
                toPass.completeIngredient(data);
                Navigator.popAndPushNamed(context, '/food/food', arguments: IngredientArguments(ingredient: toPass, isEditing: true, navFromAdd: true));
              } else {
                errorMessage = 'Could not retrieve item details!';
              }
              setState(() => searching = false);
            });
      },
    );
  }

  Future<bool> updateSearchList(String searchQuery) async {
    int resultsPerPage = 20;
    int oldLength = searchResultList.length;
    if (pageCount == 1) {
      searchResultList = [];
    }

    if (searchQuery.isEmpty) {
      searchResultList = [];
      return false;
    }

    final res = await Ingredients.searchIngredients(
        searchQuery, resultsPerPage, pageCount++, '');
    if (res.statusCode != 200) {
      return false;
    }

    var data = json.decode(res.body);
    for (var value in data['results']) {
      searchResultList.add(IngredientData.create().baseIngredient(value));
    }

    if (searchResultList.length == oldLength) {
      return false;
    }

    return true;
  }
}

class IngredientArguments {
  IngredientData ingredient;
  bool isEditing;
  bool navFromAdd;
  IngredientArguments({required this.ingredient, required this.isEditing, required this.navFromAdd});
}
