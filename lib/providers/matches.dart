import 'dart:convert';

import 'package:flutter/material.dart';
import '../models/match.dart';
import 'package:http/http.dart' as http;

const Categories = ["A", "B", "C"];

class Matches extends ChangeNotifier {
  final List<Match> _matches = [];

  Future<List<Match>> fetchMatches() async {
    if(_matches.isNotEmpty) return [..._matches];
    final response = await http.get("https://tennis-tournament-4990d.firebaseio.com/matches.json");
    final responseData = json.decode(response.body) as List<dynamic>;
    for(int i = 0; i < responseData.length; i++) {
      final Map<String, dynamic> tournamentData = responseData[i];
      _matches.add(Match.fromJson(i.toString(), tournamentData));
    }
    return [..._matches];
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
    return _matches.firstWhere((match) => match.id == id);
  }
}
