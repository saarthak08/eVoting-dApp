import 'package:evoting/src/app.dart';
import 'package:evoting/src/repository/network_config.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  String? token = sharedPreferences.getString("token");
  if (token != null && token.length != 0) {
    networkToken = token;
    runApp(App(isLoggedIn: true));
  } else {
    runApp(App(isLoggedIn: false));
  }
}
