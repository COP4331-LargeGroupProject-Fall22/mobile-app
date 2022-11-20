import 'package:flutter/material.dart';
import 'package:smart_chef/screens/StartupScreen.dart';
import 'package:smart_chef/screens/RecipeScreen.dart';
import 'package:smart_chef/screens/IngredientScreen.dart';
import 'package:smart_chef/screens/ShoppingCartScreen.dart';
import 'package:smart_chef/screens/UsersProfileScreen.dart';

class Routes {
  static const String startupScreen = '/startup';
  static const String loginScreen = '/login';
  static const String registerScreen = '/register';

  static const String recipeScreen = '/recipe';

  static const String ingredientsScreen = '/food';
  static const String ingredientScreen = '/food/food';

  static const String shoppingCartScreen = '/cart';

  static const String userProfileScreen = '/user';
  static const String editUserProfileScreen = '/user/edit';
  static const String editPasswordScreen = '/user/changePassword';

  // routes of pages in the app
  static Map<String, Widget Function(BuildContext)> get getroutes => {
    '/': (context) => StartupScreen(),
    startupScreen: (context) => StartupScreen(),
    loginScreen: (context) => LogInPage(),
    registerScreen: (context) => RegisterPage(),

    recipeScreen: (context) => RecipeScreen(),

    ingredientsScreen: (context) => IngredientsScreen(),
    ingredientScreen: (context) => IngredientPage(),

    shoppingCartScreen: (context) => ShoppingCartScreen(),

    userProfileScreen: (context) => UserProfileScreen(),
    editUserProfileScreen: (context) => EditUserProfilePage(),
    editPasswordScreen: (context) => EditPasswordPage(),
  };
}
