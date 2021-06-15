import 'package:http/http.dart' show Response;

abstract class CandidateNetwork {
  Future<Response> getCandidates();
}
