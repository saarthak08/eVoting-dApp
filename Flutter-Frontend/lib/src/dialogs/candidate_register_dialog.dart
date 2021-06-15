import 'dart:convert';

import 'package:evoting/src/models/user.dart';
import 'package:evoting/src/repository/impl/user_repository.dart';
import 'package:evoting/src/utils/dimensions.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> showCandidateRegisterDialog(context, userProvider) {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _partyNameController = TextEditingController();
  final TextEditingController _manifestoController = TextEditingController();

  return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            'Register as Candidate',
            style: TextStyle(
                fontSize: getViewportWidth(context) * 0.045,
                color: Colors.black,
                fontFamily: "Averial Serif Libre"),
          ),
          content: Container(
              height: getViewportHeight(context) * 0.25,
              width: getViewportWidth(context) * 0.8,
              child: SingleChildScrollView(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                    TextField(
                        controller: _nameController,
                        style: TextStyle(
                            color: Colors.black, fontFamily: "Mulish"),
                        decoration: InputDecoration(
                            hintText: "Name",
                            hintStyle: TextStyle(
                                color: Colors.black, fontFamily: "Mulish"),
                            icon: Icon(
                              Icons.person,
                              color: Colors.blue,
                            ))),
                    SizedBox(height: getViewportHeight(context) * 0.02),
                    TextField(
                        controller: _partyNameController,
                        style: TextStyle(
                            color: Colors.black, fontFamily: "Mulish"),
                        decoration: InputDecoration(
                            hintText: "Party Name",
                            hintStyle: TextStyle(
                                color: Colors.black, fontFamily: "Mulish"),
                            icon: Icon(
                              Icons.group,
                              color: Colors.blue,
                            ))),
                    SizedBox(height: getViewportHeight(context) * 0.02),
                    TextField(
                        controller: _manifestoController,
                        style: TextStyle(
                            color: Colors.black, fontFamily: "Mulish"),
                        decoration: InputDecoration(
                            hintText: "Manifesto",
                            hintStyle: TextStyle(
                                color: Colors.black, fontFamily: "Mulish"),
                            icon: Icon(
                              Icons.list_alt,
                              color: Colors.blue,
                            )))
                  ]))),
          actions: [
            TextButton(
                child: Text('OK',
                    style: TextStyle(
                      fontFamily: "Averia Serif Libre",
                    )),
                onPressed: () async {
                  await userRepository
                      .registerAsCandidate(_nameController.text,
                          _partyNameController.text, _manifestoController.text)
                      .then((value) async {
                    if (value.statusCode == 200) {
                      User user = userProvider!.user;
                      user.isCandidate = true;
                      userProvider?.user = user;
                      SharedPreferences sharedPreferences =
                          await SharedPreferences.getInstance();
                      sharedPreferences.setString(
                          "user", json.encode(user.toMap()));
                      Fluttertoast.showToast(msg: "Registered as Candidate");
                      Navigator.of(context, rootNavigator: true).pop('dialog');
                    } else if (value.statusCode == 400) {
                      Fluttertoast.showToast(msg: "Error: ${value.body}");
                    } else if (value.statusCode == 500) {
                      Fluttertoast.showToast(msg: "Error! ${value.body}");
                    }
                  }).catchError((err) {
                    Fluttertoast.showToast(msg: "Error: $err");
                  });
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
