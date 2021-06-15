import 'package:evoting/src/models/candidate.dart';
import 'package:evoting/src/repository/impl/voting_repository.dart';
import 'package:evoting/src/utils/dimensions.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

Future<void> showVotingDialog(context, Candidate candidate) {
  final TextEditingController _passwordController = TextEditingController();
  return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            'Are you sure you want to vote for ${candidate.name} of ${candidate.partyName}?',
            style: TextStyle(
              fontSize: getViewportWidth(context) * 0.045,
              color: Colors.black,
              fontFamily: "Mulish",
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Account Address: ${candidate.user.accountAddress}',
                style: TextStyle(
                  fontFamily: "Averia Serif Libre",
                  fontSize: getViewportWidth(context) * 0.04,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: getViewportHeight(context) * 0.02),
              TextField(
                  controller: _passwordController,
                  style: TextStyle(color: Colors.black, fontFamily: "Mulish"),
                  decoration: InputDecoration(
                      hintText: "Enter your password",
                      hintStyle:
                          TextStyle(color: Colors.black, fontFamily: "Mulish"),
                      icon: Icon(
                        Icons.password,
                        color: Colors.blue,
                      ))),
            ],
          ),
          actions: [
            TextButton(
                child: Text('OK',
                    style: TextStyle(
                      fontFamily: "Averia Serif Libre",
                    )),
                onPressed: () async {
                  votingRepository
                      .vote(candidate.user.accountAddress,
                          _passwordController.text)
                      .then((value) {
                    if (value.statusCode == 200) {
                      Fluttertoast.showToast(msg: "Successfully Voted!");
                      Navigator.of(context, rootNavigator: true).pop('dialog');
                    }
                    if (value.statusCode == 401) {
                      Fluttertoast.showToast(msg: "Wrong password");
                    }
                    if (value.statusCode == 400) {
                      Fluttertoast.showToast(msg: "Invalid Input");
                    }
                    if (value.statusCode == 500) {
                      Fluttertoast.showToast(msg: "Error! ${value.body}");
                    }
                  }).catchError((err) {
                    Fluttertoast.showToast(msg: "Error $err");
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
