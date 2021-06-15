import 'package:evoting/src/models/candidate.dart';
import 'package:evoting/src/providers/user_provider.dart';
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
  Widget build(BuildContext context) {
    viewportHeight = getViewportHeight(context);
    viewportWidth = getViewportWidth(context);
    userProvider = Provider.of<UserProvider>(context);
    return RefreshIndicator(
        key: refreshIndicatorKey,
        onRefresh: () async {
          //await getAppointmentsList();
        },
        child: Container(
            alignment: Alignment.center,
            padding: EdgeInsets.symmetric(
                vertical: viewportHeight * 0.025,
                horizontal: viewportWidth * 0.01),
            child: ListView.builder(
                itemCount: 2,
                addAutomaticKeepAlives: true,
                itemBuilder: (BuildContext context, int index) {
                  return CandidateListViewItem(
                    candidate: candidate,
                  );
                })));
  }
}
