import 'dart:convert';
import 'dart:io';
import 'package:evoting/src/repository/network_config.dart';
import 'package:http/http.dart';

import '../user_network.dart';

class _UserRepository implements UserNetwork {
  final Client _client = Client();

  @override
  Future<Response> login(String email, String password) async {
    return await _client.post(
      Uri.parse('$baseURL/login'),
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
      },
      body: jsonEncode(<String, dynamic>{'email': email, 'password': password}),
    );
  }

  @override
  Future<Response> signup(String email, String password, String confirmPassword,
      String mobileNumber, String aadharNumber) async {
    return await _client.post(
      Uri.parse('$baseURL/signup'),
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
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

  @override
  Future<Response> getUserInfo(String? accountAddress) async {
    return await _client.get(
      Uri.parse('$baseURL/user?accountAddress=$accountAddress'),
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
        HttpHeaders.authorizationHeader: networkToken
      },
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
