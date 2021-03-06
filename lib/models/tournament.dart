import 'dart:convert';

import 'package:flutter/material.dart';
import './draw.dart';
import '../utils/parsers.dart';

/* List of categories for the entire app */
const List<String> Categories = const ["A", "B", "C"];

class Tournament {
  const Tournament({
    @required this.id,
    @required this.name,
    @required this.club,
    @required this.players,
    @required this.start,
    @required this.end,
    @required this.draws,
    this.winners = const {},
    this.logoUrl =
        "https://vignette.wikia.nocookie.net/logopedia/images/a/a9/Austopen2017.png/revision/latest/scale-to-width-down/340?cb=20171231140337",
  });

  final String id;
  final String name;
  final String club;
  final Map<String, List<String>> players;
  final DateTime start;
  final DateTime end;
  final Map<String, String> winners;
  final Map<String, Draw> draws;
  final String logoUrl;

  /* Getters */
  int get playerCount {
    int result = 0;
    players.forEach((key, playersList) => result += playersList.length);
    return result;
  }

  /* Setters */
  void setWinner(String category, String playerId) {
    winners[category] = playerId;
  }

  /* Predicates */
  bool isWinner(String id, String category) {
    if (!winners.containsKey(category)) return false;
    return winners[category] == id;
  }

  bool hasPlayed(String playerId) {
    for (List<String> playerList in players.values) {
      if (playerList.contains(playerId)) return true;
    }
    return false;
  }

  /* Parsers */
  Tournament.fromJson(String id, Map<String, dynamic> tournamentData)
      : id = id,
        name = tournamentData["name"],
        club = tournamentData["club"],
        start = parseDate(tournamentData["start"]),
        end = parseDate(tournamentData["end"]),
        winners = tournamentData["winners"] == null
            ? {}
            : Map<String, String>.from(tournamentData["winners"]),
        players =
            parsePlayers(Map<String, List>.from(tournamentData["players"])),
        draws = parseDraws(Map<String, List>.from(tournamentData["draws"])),
        logoUrl = tournamentData["logoUrl"];

  String toJson() {
    return json.encode(
      {
        "id": this.id,
        "name": this.name,
        "club": this.club,
        "start": encodeDate(this.start),
        "end": encodeDate(this.end),
        "winners": this.winners,
        "players": this.players,
        "draws": encodeDraws(this.draws),
        "logoUrl": this.logoUrl,
      },
    );
  }
}
