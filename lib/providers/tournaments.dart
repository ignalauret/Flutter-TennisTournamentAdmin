import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:tennistournamentadmin/models/draw.dart';
import 'package:tennistournamentadmin/providers/players.dart';
import 'package:tennistournamentadmin/utils/parsers.dart';
import '../utils/math_methods.dart';
import '../models/tournament.dart';
import '../models/match.dart';
import 'package:http/http.dart' as http;

const List<int> Points = [100, 80, 60, 40, 20, 10, 5];

class Tournaments extends ChangeNotifier {
  Tournaments(this._playerData, this._tournaments);
  final Players _playerData;
  final List<Tournament> _tournaments;

  String _newTournamentName;
  String _newTournamentClub = "Las Delicias";
  String _newTournamentStart;
  String _newTournamentEnd;
  List<bool> _newTournamentCategories = [false, false, false];
  Map<String, List<String>> _newTournamentPlayers = {};

  List<bool> get newTournamentCategories => _newTournamentCategories;

  set newTournamentName(String value) {
    _newTournamentName = value;
  }

  set newTournamentClub(String value) {
    _newTournamentClub = value;
  }

  set newTournamentStart(String value) {
    _newTournamentStart = value;
  }

  set newTournamentEnd(String value) {
    _newTournamentEnd = value;
  }

  void newTournamentCategory(int category, bool value) {
    _newTournamentCategories[category] = value;
  }

  void newTournamentPlayers(String category, List<String> playerIds) {
    _newTournamentPlayers[category] = playerIds;
  }

  Future<List<Tournament>> fetchTournaments() async {
    if (_tournaments != null && _tournaments.isNotEmpty)
      return [..._tournaments];
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

  Future<void> createTournament() async {
    final tournaments = await http
        .get("https://tennis-tournament-4990d.firebaseio.com/tournaments.json");
    final tournamentsList = json.decode(tournaments.body) as List;
    final tournamentsCount =
      tournamentsList == null ? 0 : tournamentsList.length;
    final Map<String, Draw> draws = {};
    for (int i = 0; i < Categories.length; i++) {
      if (_newTournamentPlayers.containsKey(Categories[i]))
        draws[Categories[i]] =
            Draw.fromPlayerList(_newTournamentPlayers[Categories[i]]);
    }
    final tournament = Tournament(
      id: tournamentsCount.toString(),
      name: _newTournamentName,
      club: _newTournamentClub,
      start: parseDate(_newTournamentStart),
      end: parseDate(_newTournamentEnd),
      players: _newTournamentPlayers,
      draws: draws,
    );
    addTournament(tournament);
  }

  Future<void> addTournament(Tournament tournament) async {
    http.put(
      "https://tennis-tournament-4990d.firebaseio.com/tournaments/${tournament.id}.json",
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
      final winner = idOfWinner(
          match.idPlayer1, match.idPlayer2, match.result1, match.result2);
      http.put(
          "https://tennis-tournament-4990d.firebaseio.com/tournaments/${match.tournament}/winners/${match.category}.json",
          body: json.encode(
              "${idOfWinner(match.idPlayer1, match.idPlayer2, match.result1, match.result2)}"));
      _tournaments[int.parse(match.tournament)].setWinner(
        match.category,
        winner,
      );
      // The tournament ended, so we add the points to de players
      addPointsToPlayers(match.tournament, match.category, winner);
    }
    notifyListeners();
  }

  Future<void> addPointsToPlayers(
      String id, String category, String winner) async {
    final Map<String, int> points = {winner: Points[0]};
    final draw = getTournamentDraw(id, category);
    // Get corresponding points for each player.
    for (int i = 0; i < draw.draw.length; i++) {
      final match = draw.getMatch(i).split(",");
      final String id1 = match[0];
      final String id2 = match[1];
      if (!points.containsKey(id1) && id1 != "-1") {
        points[id1] = Points[log2(i + 1).floor() + 1];
      } else if (!points.containsKey(id2) && id2 != "-1") {
        points[id2] = Points[log2(i + 1).floor() + 1];
      }
    }
    // Add the points.
    points.forEach((player, pointsToAdd) {
      _playerData.addPointsToPlayer(player, pointsToAdd, category);
    });
  }

  /* Getters */

  List<Tournament> get tournaments {
    return [..._tournaments];
  }

  Tournament getTournamentById(String id) {
    return _tournaments.firstWhere((tournament) => tournament.id == id);
  }

  String getTournamentName(String id) {
    return getTournamentById(id).name;
  }

  Draw getTournamentDraw(String id, String category) {
    return getTournamentById(id).draws[category];
  }

  /* Predicates */

  bool playerHasTournaments(String playerId) {
    for (Tournament tournament in _tournaments) {
      if (tournament.hasPlayed(playerId)) return true;
    }
    return false;
  }
}
