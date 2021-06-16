import 'dart:convert';
import 'dart:io';
import 'package:evoting/src/repository/network_config.dart';
import 'package:http/http.dart';

import '../voting_network.dart';

class _VotingRepository implements VotingNetwork {
  final Client _client = Client();

  @override
  Future<Response> electionCommissioner() async {
    return await _client
        .get(Uri.parse("$baseURL/voting/election-commissioner"), headers: {
      HttpHeaders.contentTypeHeader: 'application/json',
      HttpHeaders.authorizationHeader: networkToken
    });
  }

  @override
  Future<Response> startVoting() async {
    return await _client.get(Uri.parse("$baseURL/voting/start"), headers: {
      HttpHeaders.contentTypeHeader: 'application/json',
      HttpHeaders.authorizationHeader: networkToken
    });
  }

  @override
  Future<Response> stopVoting() async {
    return await _client.get(Uri.parse("$baseURL/voting/stop"), headers: {
      HttpHeaders.contentTypeHeader: 'application/json',
      HttpHeaders.authorizationHeader: networkToken
    });
  }

  @override
  Future<Response> totaVotersCount() async {
    return await _client
        .get(Uri.parse("$baseURL/voting/voters-count"), headers: {
      HttpHeaders.contentTypeHeader: 'application/json',
      HttpHeaders.authorizationHeader: networkToken
    });
  }

  @override
  Future<Response> totalVotes() async {
    return await _client
        .get(Uri.parse("$baseURL/voting/total-votes"), headers: {
      HttpHeaders.contentTypeHeader: 'application/json',
      HttpHeaders.authorizationHeader: networkToken
    });
  }

  @override
  Future<Response> vote(String candidateAddress, String password) async {
    return await _client.post(Uri.parse("$baseURL/voting/vote"),
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
          HttpHeaders.authorizationHeader: networkToken
        },
        body: jsonEncode(<String, dynamic>{
          "candidateAddress": candidateAddress,
          "password": password
        }));
  }

  @override
  Future<Response> votingStatus() async {
    return await _client.get(Uri.parse("$baseURL/voting/"), headers: {
      HttpHeaders.contentTypeHeader: 'application/json',
      HttpHeaders.authorizationHeader: networkToken
    });
  }
}

_VotingRepository? _votingRepository;

_VotingRepository get votingRepository {
  if (_votingRepository == null) {
    _votingRepository = _VotingRepository();
  }
  return _votingRepository!;
}
