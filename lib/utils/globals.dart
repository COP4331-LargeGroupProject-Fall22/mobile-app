import 'package:flutter/material.dart';
import 'package:smart_chef/utils/colors.dart';

const double bottomIconSize = 55;
final globalDecoration = InputDecoration(
    contentPadding: const EdgeInsets.fromLTRB(5, 1, 5, 1),
    filled: true,
    fillColor: textFieldBacking,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(20),
      borderSide: const BorderSide(color: textFieldBorder),
    ));

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

final invalidTextField = globalDecoration.copyWith(
    enabledBorder:
        const OutlineInputBorder(borderSide: BorderSide(color: Colors.red)),
    suffixIcon: const Icon(Icons.clear, color: Colors.red));
