import 'package:flutter/material.dart';

class MainPage extends StatelessWidget {
  Widget _buildPageContent(BuildContext context) {
    return Column(mainAxisAlignment: MainAxisAlignment.center,
        // crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          InkWell(
              child: Container(
                  child: Text("Register as Candidate"),
                  alignment: Alignment.center,
                  padding: EdgeInsets.symmetric(vertical: 30.0),
                  margin: EdgeInsets.all(30.0),
                  width: 220.0,
                  height: 90.0,
                  decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.all(Radius.circular(35.0)))),
              onTap: () {
                print("Tapped on container");
              }),
          InkWell(
              child: Container(
                  child: Text("Register as Voter"),
                  alignment: Alignment.center,
                  padding: EdgeInsets.symmetric(vertical: 30.0),
                  margin: EdgeInsets.all(30.0),
                  width: 220.0,
                  height: 90.0,
                  decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.all(Radius.circular(35.0)))),
              onTap: () {
                print("Tapped on container");
              }),
          InkWell(
              child: Container(
                  child: Text("Current Vote Status"),
                  alignment: Alignment.center,
                  padding: EdgeInsets.symmetric(vertical: 30.0),
                  margin: EdgeInsets.all(30.0),
                  width: 220.0,
                  height: 90.0,
                  decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.all(Radius.circular(35.0)))),
              onTap: () {
                print("Tapped on container");
              }),
        ]);
  }

  Widget _buildMainForm(BuildContext context) {
    return Container(
        alignment: Alignment.center,
        child: _buildPageContent(context),
        color: Colors.blue.shade100);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildMainForm(context),
    );
  }
}
