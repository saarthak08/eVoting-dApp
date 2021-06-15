import 'package:evoting/src/models/candidate.dart';
import 'package:evoting/src/providers/user_provider.dart';
import 'package:evoting/src/utils/dimensions.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CandidateListViewItem extends StatefulWidget {
  final Candidate candidate;

  const CandidateListViewItem({Key? key, required this.candidate})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return new _CandidateListViewItemState(candidate);
  }
}

class _CandidateListViewItemState extends State<CandidateListViewItem> {
  final Candidate candidate;
  UserProvider? userProvider;

  _CandidateListViewItemState(this.candidate);

  @override
  Widget build(BuildContext context) {
    userProvider = Provider.of<UserProvider>(context);

    return Card(
        child: Padding(
      padding: EdgeInsets.symmetric(
          horizontal: getViewportHeight(context) * 0.01,
          vertical: getViewportWidth(context) * 0.01),
      child: ExpansionTile(
        title: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(
            candidate.name,
            style: TextStyle(
                fontSize: getViewportHeight(context) * 0.04,
                color: Colors.blue),
          ),
          SizedBox(
            height: getViewportHeight(context) * 0.01,
          ),
          RichText(
              text: TextSpan(
                  text: "Party Name: ",
                  style: TextStyle(
                      color: Colors.black,
                      fontFamily: "Averia Serif Libre",
                      fontSize: getViewportHeight(context) * 0.018,
                      fontWeight: FontWeight.bold),
                  children: [
                TextSpan(
                  text: candidate.partyName,
                  style: TextStyle(
                      color: Colors.black,
                      fontFamily: "Mulish",
                      fontSize: getViewportHeight(context) * 0.018,
                      fontWeight: FontWeight.normal),
                )
              ])),
        ]),
        childrenPadding: EdgeInsets.symmetric(
          vertical: getViewportHeight(context) * 0.02,
          horizontal: getViewportHeight(context) * 0.02,
        ),
        expandedCrossAxisAlignment: CrossAxisAlignment.start,
        expandedAlignment: Alignment.topLeft,
        children: [
          RichText(
              text: TextSpan(
                  text: "Manifesto: ",
                  style: TextStyle(
                      color: Colors.black,
                      fontFamily: "Averia Serif Libre",
                      fontSize: getViewportHeight(context) * 0.018,
                      fontWeight: FontWeight.bold),
                  children: [
                TextSpan(
                  text: candidate.manifesto,
                  style: TextStyle(
                      color: Colors.black,
                      fontFamily: "Mulish",
                      fontSize: getViewportHeight(context) * 0.018,
                      fontWeight: FontWeight.normal),
                )
              ])),
          SizedBox(
            height: getViewportHeight(context) * 0.02,
          ),
          userProvider?.user.isVoter
              ? Align(
                  alignment: Alignment.center,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ButtonStyle(
                        shape: MaterialStateProperty.all(
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(40.0)),
                        ),
                        backgroundColor:
                            MaterialStateProperty.all(Colors.blue)),
                    child: Container(
                        height: getViewportHeight(context) * 0.05,
                        width: getViewportWidth(context) * 0.2,
                        alignment: Alignment.center,
                        child: Text("Vote",
                            style: TextStyle(
                                color: Colors.white,
                                fontFamily: "Averia Serif Libre"))),
                  ))
              : Container()
        ],
      ),
    ));
  }
}
