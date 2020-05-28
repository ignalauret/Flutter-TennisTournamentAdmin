import 'dart:convert';

import 'package:flutter/foundation.dart';
import '../utils/math_methods.dart';
import '../models/tournament.dart';
import '../models/match.dart';
import 'package:http/http.dart' as http;

class Tournaments extends ChangeNotifier {
  final List<Tournament> _tournaments = [];

  Future<List<Tournament>> fetchTournaments() async {
    if (_tournaments.isNotEmpty) return [..._tournaments];
    final response = await http
        .get("https://tennis-tournament-4990d.firebaseio.com/tournaments.json");
    final responseData = json.decode(response.body) as List<dynamic>;
    if (responseData == null) return [];
    for (int i = 0; i < responseData.length; i++) {
      final Map<String, dynamic> tournamentData = responseData[i];
      _tournaments.add(Tournament.fromJson(i.toString(), tournamentData));
    }
    return [..._tournaments];
  }

  Future<void> addTournament(Tournament tournament) async {
    final tournaments = await http
        .get("https://tennis-tournament-4990d.firebaseio.com/tournaments.json");
    final tournamentsList = json.decode(tournaments.body) as List;
    final tournamentsCount =
        tournamentsList == null ? 0 : tournamentsList.length;
    tournament.id = tournamentsCount.toString();
    http.put(
      "https://tennis-tournament-4990d.firebaseio.com/tournaments/$tournamentsCount.json",
      body: tournament.toJson(),
    );
    _tournaments.add(tournament);
    notifyListeners();
  }

  Future<void> deleteTournament(String tournamentId) async {
    // Remove tournament from local memory
    _tournaments.removeWhere((tournament) => tournament.id == tournamentId);
    // Remove tournament from db.
    http.delete(
        "https://tennis-tournament-4990d.firebaseio.com/tournaments/$tournamentId.json");
    notifyListeners();
  }

  Future<void> addMatch(Match match, int index) async {
    // Add match to the tournament.
    http.put(
      "https://tennis-tournament-4990d.firebaseio.com/tournaments/${match.tournament}/draws/${match.category}/$index.json",
      body: json.encode("${match.idPlayer1},${match.idPlayer2},${match.id}"),
    );
    _tournaments[int.parse(match.tournament)]
        .draws[match.category]
        .setMatch(index, "${match.idPlayer1},${match.idPlayer2},${match.id}");
    // If its not the final, add winner to next match, else add the winner to the tournament winners.
    if (index != 0) {
      final prevMatchData = _tournaments[int.parse(match.tournament)]
          .draws[match.category]
          .getMatch(getNextMatchIndex(index));
      final arr = prevMatchData.split(",");
      arr[nextMatchPosition(index)] = idOfWinner(
          match.idPlayer1, match.idPlayer2, match.result1, match.result2);
      http.put(
        "https://tennis-tournament-4990d.firebaseio.com/tournaments/${match.tournament}/draws/${match.category}/${getNextMatchIndex(index)}.json",
        body: json.encode(arr.join(",")),
      );
      _tournaments[int.parse(match.tournament)].draws[match.category].setMatch(
            getNextMatchIndex(index),
            arr.join(","),
          );
    } else {
      http.put(
          "https://tennis-tournament-4990d.firebaseio.com/tournaments/${match.tournament}/winners/${match.category}.json",
          body: json.encode(
              "${idOfWinner(match.idPlayer1, match.idPlayer2, match.result1, match.result2)}"));
      _tournaments[int.parse(match.tournament)].setWinner(
        match.category,
        idOfWinner(
            match.idPlayer1, match.idPlayer2, match.result1, match.result2),
      );
      //TODO: Add points to players.
    }
    notifyListeners();
  }

  /* Getters */

  Tournament getTournamentById(String id) {
    return _tournaments.firstWhere((tournament) => tournament.id == id);
  }

  String getTournamentName(String id) {
    return getTournamentById(id).name;
  }

//  int getPlayerTitles(String id) {
//    int result = 0;
//    _tournaments
//        .forEach((tournament) => result += tournament.getPlayerTitles(id));
//    return result;
//  }

//  int getPlayersPlayedTournaments(String id) {
//    int result = 0;
//    _tournaments.forEach(
//        (tournament) => result += tournament.getPlayerParticipation(id));
//    return result;
//  }

  /* Predicates */

  bool playerHasTournaments(String playerId) {
    for (Tournament tournament in _tournaments) {
      if (tournament.hasPlayed(playerId)) return true;
    }
    return false;
  }
}
