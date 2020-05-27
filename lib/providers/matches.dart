import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:tennistournamentadmin/providers/tournaments.dart';
import '../models/match.dart';
import 'package:http/http.dart' as http;

const Categories = ["A", "B", "C"];

class Matches extends ChangeNotifier {
  Matches(this._tournamentsData, this._matches);

  final Tournaments _tournamentsData;
  final List<Match> _matches;

  List<Match> get matches {
    return [..._matches];
  }

  Future<List<Match>> fetchMatches() async {
    if (_matches.isNotEmpty) return [..._matches];
    final response = await http
        .get("https://tennis-tournament-4990d.firebaseio.com/matches.json");
    final responseData = json.decode(response.body) as List<dynamic>;
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
    final matchesCount = matchesList.length;
    match.id = matchesCount.toString();
    http.put(
      "https://tennis-tournament-4990d.firebaseio.com/matches/$matchesCount.json",
      body: match.toJson(),
    );
    _matches.add(match);
    notifyListeners();
    await _tournamentsData.addMatch(match, matchIndex);
  }

  Map<String, Map<String, int>> getPlayerStats(String id) {
    Map<String, Map<String, int>> result = {};
    Categories.forEach((category) {
      final matches = _matches.where((match) =>
          (match.idPlayer1 == id || match.idPlayer2 == id) &&
          match.category == category);
      final wins = matches.fold(
          0, (prev, match) => match.winnerId == id ? prev + 1 : prev);
      final tournaments = 1; //TODO
      result.addAll({
        category: {
          "played": matches.length,
          "wins": wins,
          "tournaments": tournaments
        }
      });
    });
    return result;
  }

  Match getMatchById(String id) {
    print("getMatchByID: $id, length: ${_matches.length}");
    return _matches.firstWhere((match) => match.id == id);
  }
}
