import 'package:evoting/src/models/user.dart';
import 'package:flutter/material.dart';

class UserProvider extends ChangeNotifier {
  User _user = User.empty();

  User get user {
    return _user;
  }

  set user(User user) {
    _user = user;
    notifyListeners();
  }
}
