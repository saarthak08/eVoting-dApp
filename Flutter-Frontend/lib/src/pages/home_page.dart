import 'dart:convert';

import 'package:evoting/src/dialogs/candidate_register_dialog.dart';
import 'package:evoting/src/dialogs/log_out_dialog.dart';
import 'package:evoting/src/models/user.dart';
import 'package:evoting/src/pages/candidates_page.dart';
import 'package:evoting/src/pages/election_status_page.dart';
import 'package:evoting/src/providers/user_provider.dart';
import 'package:evoting/src/providers/voting_provider.dart';
import 'package:evoting/src/repository/impl/user_repository.dart';
import 'package:evoting/src/repository/impl/voting_repository.dart';
import 'package:evoting/src/utils/app_utils.dart';
import 'package:evoting/src/utils/dimensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new _HomePageState();
  }
}

class _HomePageState extends State<HomePage> {
  UserProvider? userProvider;
  VotingProvider? votingProvider;
  String totalVotes = "";
  String totalVoters = "";
  int selectedIndex = 0;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      String? userString = sharedPreferences.getString("user");
      if (userString != null && userString.isNotEmpty) {
        User user = User.fromJSON(json.decode(userString));
        userProvider?.user = user;
      }
      await votingRepository.votingStatus().then((value) {
        if (value.statusCode == 200) {
          votingProvider?.votingStatus =
              json.decode(value.body)['votingStatus'];
        }
      });
      await votingRepository.totalVotes().then((value) {
        if (value.statusCode == 200) {
          setState(() {
            totalVotes = json.decode(value.body)["totalVotes"];
          });
        }
      });
      await votingRepository.totaVotersCount().then((value) {
        if (value.statusCode == 200) {
          setState(() {
            totalVoters = json.decode(value.body)["votersCount"];
          });
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    userProvider = Provider.of<UserProvider>(context);
    votingProvider = Provider.of<VotingProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(selectedIndex == 0
            ? 'Candidates'
            : selectedIndex == 1
                ? 'Election Status'
                : ''),
        centerTitle: true,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
      ),
      body: getBody(),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            Container(
                height: getViewportHeight(context) * 0.3,
                child: DrawerHeader(
                    curve: Curves.elasticInOut,
                    decoration: BoxDecoration(
                        color: Colors.blue,
                        gradient: LinearGradient(colors: [
                          Colors.blue.withOpacity(.5),
                          Colors.blue.withOpacity(.6),
                          Colors.blue.withOpacity(.7),
                          Colors.blue.withOpacity(.8),
                        ])),
                    child: ListView(
                      children: [
                        Container(
                            alignment: Alignment.center,
                            child: Hero(
                                child: Material(
                                    type: MaterialType.transparency,
                                    child: Text(
                                      appName,
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontFamily: "Pacifico",
                                          fontSize: getViewportHeight(context) *
                                              0.05),
                                    )),
                                tag: "appName")),
                        SizedBox(height: getViewportHeight(context) * 0.03),
                        Text(userProvider?.user.name),
                        Text(
                          "Email: ${userProvider?.user.email}",
                          style: TextStyle(fontFamily: "Averia Serif Libre"),
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          "Mobile Number: ${userProvider?.user.mobileNumber}",
                          style: TextStyle(fontFamily: "Averia Serif Libre"),
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          "Aadhar Number: ${userProvider?.user.aadharNumber}",
                          style: TextStyle(fontFamily: "Averia Serif Libre"),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ))),
            ListTile(
              tileColor: selectedIndex == 0
                  ? Colors.blue.withOpacity(0.2)
                  : Colors.white,
              title: Text("Candidates"),
              onTap: () {
                setState(() {
                  selectedIndex = 0;
                });
                Navigator.pop(context);
              },
              trailing: Icon(Icons.navigate_next_outlined),
            ),
            ListTile(
              tileColor: selectedIndex == 1
                  ? Colors.blue.withOpacity(0.2)
                  : Colors.white,
              title: totalVotes == "0" && totalVoters == "0"
                  ? Text("Election Status: Not Started")
                  : votingProvider!.votingStatus
                      ? Text("Election Status: In Progress")
                      : Text("Election Status: Stopped"),
              onTap: () {
                setState(() {
                  selectedIndex = 1;
                });
                Navigator.pop(context);
              },
              trailing: Icon(Icons.navigate_next_outlined),
            ),
            ListTile(
              enabled: !userProvider?.user.isVoter,
              title: Text(userProvider?.user.isVoter
                  ? "Registered as Voter"
                  : 'Register as Voter'),
              onTap: () async {
                await userRepository.registerAsVoter().then((value) async {
                  if (value.statusCode == 200) {
                    var user = userProvider!.user;
                    user.isVoter = true;
                    userProvider?.user = user;
                    SharedPreferences sharedPreferences =
                        await SharedPreferences.getInstance();
                    sharedPreferences.setString(
                        "user", json.encode(user.toMap()));
                    Fluttertoast.showToast(msg: "Registered as Voter");
                  } else {
                    print(value.body);
                  }
                });
              },
              trailing: userProvider?.user.isVoter
                  ? Icon(Icons.verified)
                  : Icon(Icons.navigate_next_outlined),
            ),
            ListTile(
              enabled: !userProvider?.user.isCandidate,
              title: Text(userProvider?.user.isCandidate
                  ? "Registered as Candidate"
                  : 'Register as Candidate'),
              onTap: () async {
                await showCandidateRegisterDialog(context, userProvider);
              },
              trailing: userProvider?.user.isCandidate
                  ? Icon(Icons.verified)
                  : Icon(Icons.navigate_next_outlined),
            ),
            userProvider?.user.email == "ec@evoting.com"
                ? ListTile(
                    enabled: !votingProvider!.votingStatus,
                    title: Text("Start Voting"),
                    onTap: () async {
                      await votingRepository.startVoting().then((value) {
                        if (value.statusCode == 200) {
                          votingProvider!.votingStatus = true;
                        }
                      });
                    },
                    trailing: Icon(Icons.navigate_next_outlined),
                  )
                : Container(),
            userProvider?.user.email == "ec@evoting.com"
                ? ListTile(
                    enabled: votingProvider!.votingStatus,
                    title: Text("Stop Voting"),
                    onTap: () async {
                      await votingRepository.stopVoting().then((value) {
                        if (value.statusCode == 200) {
                          votingProvider!.votingStatus = false;
                        }
                      });
                    },
                    trailing: Icon(Icons.navigate_next_outlined))
                : Container(),
            ListTile(
              title: Text("Log Out"),
              onTap: () async {
                await showLogoutDialog(context, userProvider);
              },
              trailing: Icon(Icons.logout),
            ),
          ],
        ),
      ),
    );
  }

  Widget getBody() {
    switch (selectedIndex) {
      case 0:
        return CandidatesPage();
      case 1:
        return ElectionStatusPage();
      default:
        return Container();
    }
  }
}
