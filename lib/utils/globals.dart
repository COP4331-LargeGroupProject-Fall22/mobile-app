import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:smart_chef/utils/colors.dart';

const double bottomIconSize = 55;
const double bottomRowHeight = 90;
const double topBarIconSize = 28;

bool ingredientPage = true;
bool recipePage = false;
bool shoppingCartPage = false;
bool userProfilePage = false;
const double roundedCorner = 15;

final globalDecoration = InputDecoration(
    contentPadding: const EdgeInsets.fromLTRB(5, 1, 5, 1),
    filled: true,
    fillColor: textFieldBacking,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(20),
      borderSide: const BorderSide(color: textFieldBorder),
    ));

TextStyle bottomRowIconTextStyle = const TextStyle(fontSize: 12, color: bottomRowIcon);
TextStyle bottomRowOnScreenTextStyle = const TextStyle(fontSize: 12, color: mainScheme);

final buttonStyle = ElevatedButton.styleFrom(
  shape: RoundedRectangleBorder(
    borderRadius:
    BorderRadius.circular(roundedCorner),
  ),
  backgroundColor: mainScheme,
  shadowColor: Colors.black,
);

TextStyle textFieldFontStyle = const TextStyle(
  fontSize: 20,
  color: Colors.black,
);
TextStyle errorTextStyle = const TextStyle(fontSize: 10, color: Colors.red);

final searchField = TextField(
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
);

void errorDialog(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return AlertDialog(
        title: const Text('Something went wrong'),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        elevation: 15,
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.pushNamedAndRemoveUntil(
                  context, '/startup', ((Route<dynamic> route) => false));
            },
            child: const Text(
              'OK',
              style: TextStyle(color: Colors.red, fontSize: 18),
            ),
          )
        ],
        content:
            Column(mainAxisSize: MainAxisSize.min, children: const <Widget>[
          Flexible(
              child: Text(
                  'It seems you have lost connection to the SmartChef server\nPress OK to be redirected to the home page')),
        ]),
      );
    },
  );
}
bool deleteDialog(BuildContext context) {
  bool delete = false;
  showDialog(
    context: context,
    barrierDismissible: true,
    builder: (context) {
      return AlertDialog(
        title: const Text('Deleting your account?'),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10)),
        elevation: 15,
        actions: <Widget>[
          TextButton(
            onPressed: () {
              delete = true;
              Navigator.pop(context, 'Cancel');
            },
            child: const Text(
              'Cancel',
              style: TextStyle(color: Colors.red, fontSize: 18),
            ),
          ),
          TextButton(
            onPressed: () {
              delete = true;
              Navigator.pop(context, 'delete');
            },
            child: const Text(
              'Delete my account',
              style: TextStyle(color: Colors.red, fontSize: 18),
            ),
          )
        ],
        content: Column(
            mainAxisSize: MainAxisSize.min,
            children: const <Widget>[
              Flexible(
                  child: Text(
                      'Are you sure you want to delete your account?')),
            ]),
      );
    },
  );
  return delete;
}

final invalidTextField = globalDecoration.copyWith(
    enabledBorder:
        const OutlineInputBorder(borderSide: BorderSide(color: Colors.red)),
    suffixIcon: const Icon(Icons.clear, color: Colors.red));
