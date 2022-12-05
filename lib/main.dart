import 'package:flutter/material.dart';
import 'package:smart_chef/routes/routes.dart';

void main() {
  runApp(SmartChef());
}

class SmartChef extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '',
      debugShowCheckedModeBanner: false,
      restorationScopeId: 'root',
      theme: ThemeData(),
      routes: Routes.getroutes,
      onGenerateRoute: (settings) {
        return Routes.generateRoute(settings);
      },
    );
  }
}
