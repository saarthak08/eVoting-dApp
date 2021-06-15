import 'package:flutter/material.dart';

class VotingProvider extends ChangeNotifier {
  bool _votingStatus = false;

  bool get votingStatus {
    return _votingStatus;
  }

  set votingStatus(bool votingStatus) {
    _votingStatus = votingStatus;
    notifyListeners();
  }
}
