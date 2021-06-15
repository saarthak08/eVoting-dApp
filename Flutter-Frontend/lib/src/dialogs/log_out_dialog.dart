import 'package:evoting/src/models/user.dart';
import 'package:evoting/src/providers/user_provider.dart';
import 'package:evoting/src/repository/network_config.dart';
import 'package:evoting/src/utils/dimensions.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> showLogoutDialog(context, UserProvider? userProvider) {
  return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Text(
            'Do you really want to log out?',
            style: TextStyle(
              fontSize: getViewportWidth(context) * 0.045,
              color: Colors.black,
            ),
          ),
          actions: [
            TextButton(
                child: Text('OK',
                    style: TextStyle(
                      fontFamily: "Averia Serif Libre",
                    )),
                onPressed: () async {
                  SharedPreferences sharedPreferences =
                      await SharedPreferences.getInstance();
                  sharedPreferences.clear();
                  networkToken = "";
                  userProvider?.user = User.empty();
                  Navigator.of(context).pushNamedAndRemoveUntil(
                      "/login", (Route<dynamic> route) => false);
                }),
            TextButton(
                child: Text('Cancel',
                    style: TextStyle(
                      fontFamily: "Averia Serif Libre",
                    )),
                onPressed: () {
                  Navigator.of(context, rootNavigator: true).pop('dialog');
                }),
          ],
        );
      });
}
