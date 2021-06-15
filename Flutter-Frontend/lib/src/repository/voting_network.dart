import 'package:http/http.dart' show Response;

abstract class VotingNetwork {
  Future<Response> vote(String candidateAddress, String password);
  Future<Response> startVoting();
  Future<Response> stopVoting();
  Future<Response> votingStatus();
  Future<Response> electionCommissioner();
  Future<Response> totalVotes();
  Future<Response> totaVotersCount();
}
