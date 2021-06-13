import 'dart:convert';
import 'package:evoting/src/repository/network_config.dart';
import 'package:http/http.dart';

import '../user_network.dart';

class _UserRepository implements UserNetwork {
  final Client _client = Client();

  @override
  Future<Response> login(String email, String password) async {
    return await _client.post(
      Uri.parse('$baseURL/login'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{'email': email, 'password': password}),
    );
  }

  @override
  Future<Response> signup(String email, String password, String confirmPassword,
      String mobileNumber, String aadharNumber) async {
    return await _client.post(
      Uri.parse('$baseURL/signup'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'email': email,
        'password': password,
        'confirmPassword': confirmPassword,
        'mobileNumber': mobileNumber,
        'aadharNumber': aadharNumber
      }),
    );
  }
}

_UserRepository? _userRepository;

_UserRepository get userRepository {
  if (_userRepository == null) {
    _userRepository = _UserRepository();
  }
  return _userRepository!;
}
