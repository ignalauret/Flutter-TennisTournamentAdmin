import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:tennistournamentadmin/utils/parsers.dart';

class Match {
  Match({
    this.id,
    @required this.idPlayer1,
    @required this.idPlayer2,
    @required this.result1,
    @required this.result2,
    @required this.date,
    @required this.tournament,
    @required this.round,
    @required this.category,
  });

  Match.fromJson(String id, Map<String, dynamic> matchData)
      : id = id,
        idPlayer1 = matchData["player1"],
        idPlayer2 = matchData["player2"],
        result1 = parseResult(matchData["result1"]),
        result2 = parseResult(matchData["result2"]),
        date = parseDateWithHour(matchData["date"]),
        tournament = matchData["tournament"],
        round = matchData["round"],
        category = matchData["category"];

  String id;
  final String idPlayer1;
  final String idPlayer2;
  final List<String> result1;
  final List<String> result2;
  final DateTime date;
  final String tournament;
  final String round;
  final String category;

  String toJson() {
    return json.encode({
      "id": this.id,
      "player1": this.idPlayer1,
      "player2": this.idPlayer2,
      "result1": encodeResult(this.result1),
      "result2": encodeResult(this.result2),
      "date": encodeDateWithHour(this.date),
      "tournament": this.tournament,
      "category": this.category,
      "round": this.round,
    });
  }

  bool get isFirstWinner {
    return int.parse(result1.last) > int.parse(result2.last);
  }

  String get winnerId {
    return isFirstWinner ? idPlayer1 : idPlayer2;
  }

  List<String> getColouredResult(bool firstPlayer) {
    if (firstPlayer) {
      final result = result1;
      for (int i = 0; i < result.length; i++) {
        if (int.parse(result[i]) > int.parse(result2[i]))
          result[i] = result[i][0] + " ";
      }
      return result;
    } else {
      final result = result2;
      for (int i = 0; i < result.length; i++) {
        if (int.parse(result[i]) > int.parse(result1[i]))
          result[i] = result[i][0] + " ";
      }
      return result;
    }
  }
}
