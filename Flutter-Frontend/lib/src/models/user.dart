class User {
  String _id = "";
  String _name = "";
  String _email = "";
  int _mobileNumber = 0;
  int _aadharNumber = 0;
  String _accountAddress = "";
  bool _isVoter = false;
  bool _isCandidate = false;

  get id => this._id;

  set id(value) => this._id = value;

  get name => this._name;

  set name(value) => this._name = value;

  get email => this._email;

  set email(value) => this._email = value;

  get mobileNumber => this._mobileNumber;

  set mobileNumber(value) => this._mobileNumber = value;

  get aadharNumber => this._aadharNumber;

  set aadharNumber(value) => this._aadharNumber = value;

  get accountAddress => this._accountAddress;

  set accountAddress(value) => this._accountAddress = value;

  get isVoter => this._isVoter;

  set isVoter(value) => this._isVoter = value;

  get isCandidate => this._isCandidate;

  set isCandidate(value) => this._isCandidate = value;

  User.empty();

  User.fromJSON(Map<String, dynamic> map) {
    try {
      this._email = map["email"];
      this._name = map["name"];
      this._mobileNumber = map["mobileNumber"];
      this._accountAddress = map["accountAddress"];
      this._aadharNumber = map["aadharNumber"];
      this._isVoter = map["isVoter"];
      this._isCandidate = map["isCandidate"];
      this._id = map["id"];
    } catch (err) {
      print("Error in parsing JSON to User Object: " + err.toString());
    }
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = Map<String, dynamic>();
    map['name'] = this.name;
    map['email'] = this.email;
    map['mobileNumber'] = this.mobileNumber;
    map['aadharNumber'] = this.aadharNumber;
    map['accountAddress'] = this.accountAddress;
    map['isVoter'] = this.isVoter;
    map['isCandidate'] = this.isCandidate;
    map['id'] = this.id;
    return map;
  }
}
