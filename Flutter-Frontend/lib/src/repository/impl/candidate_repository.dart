import 'dart:io';
import 'package:evoting/src/repository/candidate_network.dart';
import 'package:evoting/src/repository/network_config.dart';
import 'package:http/http.dart';

class _CandidateRepository implements CandidateNetwork {
  final Client _client = Client();

  @override
  Future<Response> getCandidates() async {
    return await _client.get(Uri.parse("$baseURL/candidate/all"), headers: {
      HttpHeaders.contentTypeHeader: 'application/json',
      HttpHeaders.authorizationHeader: networkToken
    });
  }
}

_CandidateRepository? _candidateRepository;

_CandidateRepository get candidateRepository {
  if (_candidateRepository == null) {
    _candidateRepository = _CandidateRepository();
  }
  return _candidateRepository!;
}
