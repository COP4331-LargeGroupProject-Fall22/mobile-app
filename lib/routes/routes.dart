import 'package:flutter/material.dart';
import 'package:smart_chef/screens/StartupScreen.dart';
import 'package:smart_chef/screens/RecipeScreen.dart';
import 'package:smart_chef/screens/IngredientScreen.dart';
import 'package:smart_chef/screens/ShoppingCartScreen.dart';
import 'package:smart_chef/screens/UsersProfileScreen.dart';

class Routes {
  static const String startupScreen = '/startup';
  static const String signinScreen = '/signin';
  static const String registerScreen = '/register';

  static const String recipeScreen = '/recipe';
  static const String ingredientScreen = '/food';
  static const String shoppingCartScreen = '/cart';

  static const String userProfileScreen = '/user';
  static const String editUserProfileScreen = '/user/edit';

  // routes of pages in the app
  static Map<String, Widget Function(BuildContext)> get getroutes => {
    '/': (context) => StartupScreen(),
    startupScreen: (context) => StartupScreen(),
    signinScreen: (context) => SignInPage(),
    registerScreen: (context) => RegisterPage(),

    recipeScreen: (context) => RecipeScreen(),
    ingredientScreen: (context) => IngredientsScreen(),
    shoppingCartScreen: (context) => ShoppingCartScreen(),

    userProfileScreen: (context) => UserProfileScreen(),
    editUserProfileScreen: (context) => EditUserProfilePage(),
  };
}