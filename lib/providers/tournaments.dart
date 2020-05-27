import 'dart:convert';

import 'package:flutter/foundation.dart';
import '../models/tournament.dart';
import 'package:http/http.dart' as http;

class Tournaments extends ChangeNotifier {
  final List<Tournament> _tournaments = [];

  Future<List<Tournament>> fetchTournaments() async {
    if (_tournaments.isNotEmpty) return [..._tournaments];
    final response = await http
        .get("https://tennis-tournament-4990d.firebaseio.com/tournaments.json");
    final responseData = json.decode(response.body) as List<dynamic>;
    for (int i = 0; i < responseData.length; i++) {
      final Map<String, dynamic> tournamentData = responseData[i];
      _tournaments.add(Tournament.fromJson(i.toString(), tournamentData));
    }
    return [..._tournaments];
  }

  Tournament getTournamentById(String id) {
    return _tournaments.firstWhere((tournament) => tournament.id == id);
  }

  String getTournamentName(String id) {
    return getTournamentById(id).name;
  }

  int getPlayerTitles(String id) {
    int result = 0;
    _tournaments
        .forEach((tournament) => result += tournament.getPlayerTitles(id));
    return result;
  }

  int getPlayersPlayedTournaments(String id) {
    int result = 0;
    _tournaments.forEach(
        (tournament) => result += tournament.getPlayerParticipation(id));
    return result;
  }
}
