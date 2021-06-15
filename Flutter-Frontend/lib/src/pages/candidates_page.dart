import 'dart:convert';

import 'package:evoting/src/models/candidate.dart';
import 'package:evoting/src/providers/user_provider.dart';
import 'package:evoting/src/repository/impl/candidate_repository.dart';
import 'package:evoting/src/utils/dimensions.dart';
import 'package:evoting/src/widgets/candidate_list_view_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CandidatesPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new _CandidatesPageState();
  }
}

class _CandidatesPageState extends State<CandidatesPage> {
  UserProvider? userProvider;
  late double viewportHeight;
  late double viewportWidth;
  List<dynamic> candidates = [];
  final GlobalKey<RefreshIndicatorState> refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  final Candidate candidate = Candidate.empty();
  _CandidatesPageState() {
    candidate.name = "hi";
    candidate.partyName = "ba";
    candidate.manifesto =
        "fjsdlkfajsdfkfdjsfkl;sdjfklsajdlfkjsdklfjsd;klfjsdlak;fjklsdjf;klsadjfkl;dsajfklasdjflk;sadjflk;sdjkl;fjsdlkfjdsklfjskld;jfkls;adjflksdjflksdajfklsadjflksdjfklsjdfkl;jsdlk;fjsdkl;fjksladjfaksldjf;";
  }

  @override
  void initState() {
    super.initState();
    fetchCandidates();
  }

  void fetchCandidates() async {
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
  }

  @override
  Widget build(BuildContext context) {
    viewportHeight = getViewportHeight(context);
    viewportWidth = getViewportWidth(context);
    userProvider = Provider.of<UserProvider>(context);
    return RefreshIndicator(
        key: refreshIndicatorKey,
        onRefresh: () async {
          return fetchCandidates();
        },
        child: Container(
            alignment: Alignment.center,
            padding: EdgeInsets.symmetric(
                vertical: viewportHeight * 0.025,
                horizontal: viewportWidth * 0.01),
            child: ListView.builder(
                itemCount: candidates.length,
                addAutomaticKeepAlives: true,
                itemBuilder: (BuildContext context, int index) {
                  return CandidateListViewItem(
                    candidate: candidates[index],
                  );
                })));
  }
}
