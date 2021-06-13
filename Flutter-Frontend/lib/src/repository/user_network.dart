import 'package:http/http.dart' show Response;

abstract class UserNetwork {
  Future<Response> login(String email, String password);
  Future<Response> signup(String email, String password, String confirmPassword,
      String mobileNumber, String aadharNumber);
}
