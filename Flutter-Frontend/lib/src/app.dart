import 'package:evoting/src/pages/login_page.dart';
import 'package:evoting/src/pages/main_page.dart';
import 'package:flutter/material.dart';

class App extends StatelessWidget {
  final bool isLoggedIn;

  const App({Key? key, required this.isLoggedIn}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: isLoggedIn ? LoginPage() : MainPage(),
      theme: ThemeData(
        fontFamily: "Nuntino Sans",
        primarySwatch: Colors.blue,
      ),
    );
  }
}
