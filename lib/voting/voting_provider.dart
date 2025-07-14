import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'voting_repository.dart';
import '../common/models.dart';

class VotingProvider with ChangeNotifier {
  final VotingRepository _repository = VotingRepository();
  List<Candidate> candidates = [];
  List<Vote> votes = [];
  bool isLoading = false;
  String? errorMessage;

  final List<String> domains = List.generate(18, (i) => 'region${i + 1}.com');

  Future<void> fetchData() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      isLoading = false;
      errorMessage = 'No internet connection';
      notifyListeners();
      return;
    }

    try {
      candidates = await _repository.getCandidates();
      votes = await _repository.getVotes();
    } catch (e) {
      errorMessage = 'Error fetching data: $e';
    }
    isLoading = false;
    notifyListeners();
  }

  Future<void> vote(String userEmail, String candidateId) async {
    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      errorMessage = 'No internet connection';
      notifyListeners();
      return;
    }

    String domain = userEmail.split('@').last;
    if (!domains.contains(domain)) {
      errorMessage = 'Invalid domain: $domain';
      notifyListeners();
      return;
    }

    bool alreadyVoted = votes.any((v) => v.voterEmail == userEmail && v.candidateId == candidateId);
    if (alreadyVoted) {
      errorMessage = 'You have already voted for this candidate';
      notifyListeners();
      return;
    }

    try {
      await _repository.addVote(userEmail, candidateId);
      await fetchData(); // Refresh data after voting
    } catch (e) {
      errorMessage = 'Error submitting vote: $e';
      notifyListeners();
    }
  }

  Map<String, Map<String, int>> getVoteCounts() {
    Map<String, Map<String, int>> voteCounts = {};
    for (var candidate in candidates) {
      voteCounts[candidate.id] = {for (var domain in domains) domain: 0};
    }
    for (var vote in votes) {
      String domain = vote.voterEmail.split('@').last;
      if (voteCounts.containsKey(vote.candidateId)) {
        voteCounts[vote.candidateId]![domain] = voteCounts[vote.candidateId]![domain]! + 1;
      }
    }
    return voteCounts;
  }
}