import 'package:http/http.dart' show Response;

abstract class UserNetwork {
  Future<Response> login(String email, String password);
  Future<Response> signup(String name, String email, String password,
      String confirmPassword, String mobileNumber, String aadharNumber);
  Future<Response> getUserInfo(String? accountAddress);
  Future<Response> registerAsVoter();
  Future<Response> registerAsCandidate(String name, String partyName, String manifesto);
}
