import 'package:flutter/material.dart';
import 'package:motorassesmentapp/screens/create_instruction.dart';
import 'package:motorassesmentapp/screens/login_screen.dart';

void main() {
  runApp(MyApp());
}

final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          scaffoldBackgroundColor: Colors.white, primaryColor: Colors.white),
      home: LoginPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
