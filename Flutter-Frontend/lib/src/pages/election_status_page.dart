import 'dart:convert';

import 'package:evoting/src/models/candidate.dart';
import 'package:evoting/src/providers/voting_provider.dart';
import 'package:evoting/src/repository/impl/candidate_repository.dart';
import 'package:evoting/src/repository/impl/voting_repository.dart';
import 'package:evoting/src/utils/dimensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

class ElectionStatusPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new _ElectionStatusPageState();
  }
}

class _ElectionStatusPageState extends State<ElectionStatusPage> {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  List<dynamic> candidates = [];
  String totalVotes = "0";
  String totalVoters = "0";
  bool fetching = true;
  bool votingStatus = false;
  VotingProvider? votingProvider;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) async {
      _refreshIndicatorKey.currentState?.show();
    });
  }

  Future<void> fetchInformation() async {
    await votingRepository.votingStatus().then((value) async {
      if (value.statusCode == 200) {
        votingProvider?.votingStatus = json.decode(value.body)['votingStatus'];
        setState(() {
          votingStatus = votingProvider!.votingStatus;
        });

        await candidateRepository.getCandidates().then((value) {
          if (value.statusCode == 200) {
            var candidatesList = [];
            var responseMap = json.decode(value.body);
            for (var candidate in responseMap['candidates']) {
              candidatesList.add(Candidate.fromJSON(candidate));
            }
            setState(() {
              candidates = candidatesList;
            });
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
      }
    }).whenComplete(() {
      setState(() {
        fetching = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    votingProvider = Provider.of<VotingProvider>(context);
    return RefreshIndicator(
        key: _refreshIndicatorKey,
        onRefresh: () async {
          await fetchInformation();
        },
        child: SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            child: Container(
                child: fetching
                    ? Container(
                        margin: EdgeInsets.symmetric(
                            horizontal: getViewportWidth(context) * 0.0),
                        height: getViewportHeight(context),
                        width: getViewportWidth(context),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              height: getViewportHeight(context) * 0.6,
                              width: getViewportWidth(context) * 0.6,
                              child: SvgPicture.asset(
                                'assets/images/fetching_data.svg',
                                height: getViewportWidth(context) * 0.6,
                                width: getViewportWidth(context) * 0.6,
                              ),
                            ),
                            Container(
                                alignment: Alignment.center,
                                margin: EdgeInsets.symmetric(
                                    horizontal:
                                        getViewportWidth(context) * 0.05),
                                child: Text(
                                  "Fetching Data...",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Averia Serif Libre',
                                    fontSize: getViewportHeight(context) * 0.05,
                                  ),
                                )),
                          ],
                        ))
                    : totalVotes == "0" && totalVoters == "0"
                        ? Container(
                            height: getViewportHeight(context),
                            width: getViewportWidth(context),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  height: getViewportHeight(context) * 0.6,
                                  width: getViewportWidth(context) * 0.6,
                                  child: SvgPicture.asset(
                                    'assets/images/voting_not_started.svg',
                                    height: getViewportWidth(context) * 0.6,
                                    width: getViewportWidth(context) * 0.6,
                                  ),
                                ),
                                Container(
                                    margin: EdgeInsets.symmetric(
                                        horizontal:
                                            getViewportWidth(context) * 0.05),
                                    child: Text(
                                      "Voting not started yet...",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'Averia Serif Libre',
                                        fontSize:
                                            getViewportHeight(context) * 0.05,
                                      ),
                                    )),
                              ],
                            ))
                        : votingStatus
                            ? Container(
                                height: getViewportHeight(context),
                                width: getViewportWidth(context),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      height: getViewportHeight(context) * 0.6,
                                      width: getViewportWidth(context) * 0.6,
                                      child: SvgPicture.asset(
                                        'assets/images/voting_in_progress.svg',
                                        height: getViewportWidth(context) * 0.6,
                                        width: getViewportWidth(context) * 0.6,
                                      ),
                                    ),
                                    Container(
                                        alignment: Alignment.center,
                                        margin: EdgeInsets.symmetric(
                                            horizontal:
                                                getViewportWidth(context) *
                                                    0.05),
                                        child: Text(
                                          "Voting in Progress...",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: 'Averia Serif Libre',
                                            fontSize:
                                                getViewportHeight(context) *
                                                    0.05,
                                          ),
                                        )),
                                  ],
                                ))
                            : Container())));
  }
}
