import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/voting/voting_repository.dart';
import 'package:flutter_application_1/common/models.dart';
import 'package:flutter_application_1/auth/auth_service.dart';

class VotingProvider with ChangeNotifier {
  final VotingRepository _repository = VotingRepository();
  bool _isConnected = true;
  String _error = '';
  Map<String, Candidate?> _selectedCandidates = {'Director': null, 'Adviser': null};
  static const List<String> requiredPositions = ['Director', 'Adviser'];

  bool get isConnected => _isConnected;
  String get error => _error;
  Map<String, Candidate?> get selectedCandidates => _selectedCandidates;
  bool get areAllPositionsSelected => _selectedCandidates.values.every((candidate) => candidate != null);

  Future<void> checkConnectivity() async {
    final result = await Connectivity().checkConnectivity();
    _isConnected = result != ConnectivityResult.none;
    notifyListeners();
  }

  void setSelectedCandidate(String position, Candidate? candidate) {
    if (_isConnected && (candidate == null || _selectedCandidates[position] != candidate)) {
      _selectedCandidates[position] = candidate;
      notifyListeners();
    }
  }

  Future<void> castVotes(String region) async {
    if (!areAllPositionsSelected) {
      _error = 'Please select one candidate for each position';
      notifyListeners();
      return;
    }

    try {
      final user = AuthService().currentUser;
      if (user == null) throw Exception('User not logged in');

      final alreadyVoted = await _repository.hasVoted(user.uid);
      print('hasVoted check for UID ${user.uid}: $alreadyVoted'); // Debug log
      if (alreadyVoted) {
        throw Exception('You have already voted');
      }

      for (var entry in _selectedCandidates.entries) {
        final candidate = entry.value;
        if (candidate != null) {
          await _repository.castVote(candidate.id, region);
        }
      }

      _selectedCandidates = {'Director': null, 'Adviser': null};
      _error = 'Thank you for voting!';
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }
}