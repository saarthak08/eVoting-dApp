import 'package:evoting/src/pages/login_page.dart';
import 'package:flutter/material.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: LoginPage(),
      theme: ThemeData(
        fontFamily: "Nuntino Sans",
        primarySwatch: Colors.blue,
      ),
    );
  }
}
