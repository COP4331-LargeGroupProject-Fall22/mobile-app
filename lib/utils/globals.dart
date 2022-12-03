import 'package:flutter/material.dart';
import 'package:smart_chef/utils/colors.dart';

const double bottomIconSize = 55;
const double bottomRowHeight = 90;
const double topBarIconSize = 28;
const double ingredientInfoFontSize = 18;
const double addIngredientPageTextSize = 32;
const double roundedCorner = 15;
const double searchIconButtonSize = 20;

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
TextStyle ingredientInfoTextStyle = const TextStyle(
  fontSize: ingredientInfoFontSize,
  color: black,
);
TextStyle noMoreTextStyle = const TextStyle(
  fontSize: addIngredientPageTextSize,
  color: searchFieldText,
);

final buttonStyle = ElevatedButton.styleFrom(
  shape: RoundedRectangleBorder(
    borderRadius:
    BorderRadius.circular(roundedCorner),
  ),
  backgroundColor: mainScheme,
  shadowColor: black,
);

TextStyle textFieldFontStyle = const TextStyle(
  fontSize: 20,
  color: black,
);
TextStyle errorTextStyle = const TextStyle(fontSize: 10, color: Colors.red);

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
Future<bool> deleteDialog(BuildContext context) async{
  bool delete = await showDialog(
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
              Navigator.pop(context, false);
            },
            child: const Text(
              'Cancel',
              style: TextStyle(color: Colors.red, fontSize: 18),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context, true);
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

class AlwaysDisabledFocusNode extends FocusNode {
  @override
  bool get hasFocus => false;
}
