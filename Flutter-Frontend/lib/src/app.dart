import 'package:evoting/src/pages/login_page.dart';
import 'package:evoting/src/pages/home_page.dart';
import 'package:evoting/src/pages/signup_page.dart';
import 'package:evoting/src/providers/user_provider.dart';
import 'package:evoting/src/providers/voting_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class App extends StatelessWidget {
  final bool isLoggedIn;

  const App({Key? key, required this.isLoggedIn}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (ctx) => UserProvider(),
          ),
          ChangeNotifierProvider(
            create: (ctx) => VotingProvider(),
          ),
        ],
        child: MaterialApp(
          home: isLoggedIn ? HomePage() : LoginPage(),
          theme: ThemeData(
            canvasColor: Colors.white,
            fontFamily: "Nuntino Sans",
            primarySwatch: Colors.blue,
          ),
          routes: {
            '/signup': (BuildContext context) => SignupPage(),
            '/login': (BuildContext context) => LoginPage(),
            '/home': (BuildContext context) => HomePage()
          },
        ));
  }
}
