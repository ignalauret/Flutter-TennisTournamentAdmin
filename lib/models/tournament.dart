import 'package:flutter/cupertino.dart';
import 'package:tennistournamentadmin/models/Draw.dart';
import 'package:tennistournamentadmin/utils/parsers.dart';

class Tournament {
  Tournament({
    @required this.id,
    @required this.name,
    @required this.club,
    @required this.players,
    @required this.start,
    @required this.end,
    this.winners = const {"A": "0", "B": "", "C": ""},
    this.draws,
  });

  Tournament.fromJson(String id, Map<String, dynamic> tournamentData)
      : id = id,
        name = tournamentData["name"],
        club = tournamentData["club"],
        start = parseDate(tournamentData["start"]),
        end = parseDate(tournamentData["end"]),
        winners = Map<String, String>.from(tournamentData["winners"]),
        players = parsePlayers(Map<String, List>.from(tournamentData["players"])),
        draws = parseDraws(Map<String,List>.from(tournamentData["draws"]));

  final String id;
  final String name;
  final String club;
  final Map<String, List<String>> players;
  final DateTime start;
  final DateTime end;
  final Map<String, String> winners;
  final Map<String, Draw> draws;

  int get playerCount {
    int result = 0;
    players.forEach((key, playersList) => result += playersList.length);
    return result;
  }

  bool isWinner(String id, String category) {
    return winners[category] == id;
  }

  int getPlayerTitles(String id) {
    int result = 0;
    winners.forEach((category, pid) {
      if (pid == id) result++;
    });
    return result;
  }

  int getPlayerParticipation(String id) {
    int result = 0;
    players.values.forEach((playersList) {
      if (playersList.contains(id)) result++;
    });
    return result;
  }
}
