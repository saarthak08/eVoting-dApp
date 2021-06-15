import 'package:evoting/src/models/user.dart';

class Candidate {
  String _name = "";
  String _id = "";
  String _votes = "";
  String _partyName = "";
  String _manifesto = "";
  User _user = User.empty();

  get name => this._name;

  set name(value) => this._name = value;

  get id => this._id;

  set id(value) => this._id = value;

  get votes => this._votes;

  set votes(value) => this._votes = value;

  get partyName => this._partyName;

  set partyName(value) => this._partyName = value;

  get manifesto => this._manifesto;

  set manifesto(value) => this._manifesto = value;

  get user => this._user;

  set user(value) => this._user = value;

  Candidate.empty();

  Candidate.fromJSON(Map<String, dynamic> map) {
    try {
      this._id = map["id"];
      this._partyName = map["partyName"];
      this._name = map["name"];
      this._manifesto = map["manifesto"];
      this._votes = map["votes"];
      map["user"]["id"] = '';
      this._user = User.fromJSON(map["user"]);
    } catch (err) {
      print("Error in parsing JSON to Candidate Object: " + err.toString());
    }
  }
}
