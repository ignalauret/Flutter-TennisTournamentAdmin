import 'dart:convert';

import 'package:flutter/material.dart';
import '../providers/tournaments.dart';
import '../models/match.dart';
import 'package:http/http.dart' as http;

class Matches extends ChangeNotifier {
  Matches(this._tournamentsData, this._matches);

  final Tournaments _tournamentsData;
  final List<Match> _matches;

  List<Match> get matches {
    return _matches == null ? [] : [..._matches];
  }

  Future<List<Match>> fetchMatches() async {
    if (_matches != null && _matches.isNotEmpty) return [..._matches];
    final response = await http
        .get("https://tennis-tournament-4990d.firebaseio.com/matches.json");
    final responseData = json.decode(response.body) as List<dynamic>;
    if(responseData == null) return [];
    for (int i = 0; i < responseData.length; i++) {
      final Map<String, dynamic> tournamentData = responseData[i];
      _matches.add(Match.fromJson(i.toString(), tournamentData));
    }
    notifyListeners();
    return [..._matches];
  }

  Future<void> addMatch(Match match, int matchIndex) async {
    // Get matches count and add match at next available index.
    final matches = await http
        .get("https://tennis-tournament-4990d.firebaseio.com/matches.json");
    final matchesList = json.decode(matches.body) as List;
    final matchesCount = matchesList == null ? 0 : matchesList.length;
    match.id = matchesCount.toString();
    http.put(
      "https://tennis-tournament-4990d.firebaseio.com/matches/$matchesCount.json",
      body: match.toJson(),
    );
    _matches.add(match);
    notifyListeners();
    await _tournamentsData.addMatch(match, matchIndex);
  }

  Future<void> deleteMatch(String matchId) async {
    // Delete match from local memory.
    _matches.removeWhere((match) => match.id == matchId);
    // Delete match from db.
    http.delete(
        "https://tennis-tournament-4990d.firebaseio.com/matches/$matchId.json");
  }

  Future<void> deleteMatchesOfTournament(String tournamentId) async {
    _matches.forEach((match) {
      if (match.tournament == tournamentId) {
        deleteMatch(match.id);
      }
    });
  }

  /* Getters */

  Match getMatchById(String id) {
    return _matches.firstWhere((match) => match.id == id);
  }

  /* Predicates */

  bool playerHasMatches(String playerId) {
    for (Match match in _matches) {
      if (match.idPlayer1 == playerId || match.idPlayer2 == playerId)
        return true;
    }
    return false;
  }
}
