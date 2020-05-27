import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:http/http.dart' as http;
import 'package:tennistournamentadmin/utils/math_methods.dart';

class AddTournamentsScreen extends StatefulWidget {
  static const routeName = "/add-tournament";
  @override
  _AddTournamentsScreenState createState() => _AddTournamentsScreenState();
}

class _AddTournamentsScreenState extends State<AddTournamentsScreen> {
  String name = "";
  String club = "";
  String start = "";
  String end = "";
  List<String> players = ["", "", ""];

  List<String> buildDraw(List<String> playersIds) {
    final int nPlayers = playersIds.length;
    final int nRounds = log2(nPlayers).ceil();
    final int nMatches = pow(2, nRounds) - 1;
    final List<String> result = List.generate(nMatches, (_) => ",,");
    for (int i = 0; i < (nPlayers / 2).floor(); i++) {
      result[nMatches - i - 1] =
          "${playersIds[2 * i]},${playersIds[2 * i + 1]},";
    }
    if (nPlayers % 2 == 1) {
      result[(nPlayers / 2).floor()] = playersIds[nPlayers - 1];
    }
    return result;
  }

  Future<void> addTournament() async {
    final tournaments = await http
        .get("https://tennis-tournament-4990d.firebaseio.com/tournaments.json");
    final tournamentsList = json.decode(tournaments.body) as List;
    final tournamentsCount = tournamentsList.length;
    final List<List<String>> playersList =
        players.map((playerIds) => playerIds.split(",")).toList();
    final Map<String, List<String>> playersMap = {};

    playersMap.addAll({"A": [], "B": [], "C": []});
    for (int j = 0; j < playersList[0].length; j++) {
      playersMap["A"].add(playersList[0][j]);
    }
    for (int j = 0; j < playersList[1].length; j++) {
      playersMap["B"].add(playersList[1][j]);
    }
    for (int j = 0; j < playersList[2].length; j++) {
      playersMap["C"].add(playersList[2][j]);
    }

    Map<String, List<String>> draws = {};
    draws.addAll(
      {"A": buildDraw(playersList[0])},
    );

    http.put(
      "https://tennis-tournament-4990d.firebaseio.com/tournaments/$tournamentsCount.json",
      body: json.encode({
        "name": name,
        "club": club,
        "start": start,
        "end": end,
        "players": playersMap,
        "winners": {"A": "", "B": "", "C": ""},
        "draws": draws,
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text("Crear Torneo"),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(15),
          child: Column(
            children: <Widget>[
              Text("Crear torneo"),
              TextField(
                decoration: InputDecoration(hintText: "Name"),
                onChanged: (val) => name = val,
              ),
              TextField(
                decoration: InputDecoration(hintText: "Club"),
                onChanged: (val) => club = val,
              ),
              TextField(
                decoration: InputDecoration(hintText: "Start"),
                onChanged: (val) => start = val,
              ),
              TextField(
                decoration: InputDecoration(hintText: "End"),
                onChanged: (val) => end = val,
              ),
              TextField(
                decoration: InputDecoration(hintText: "Jugadores A"),
                onChanged: (val) => players[0] = val,
              ),
              TextField(
                decoration: InputDecoration(hintText: "Jugadores B"),
                onChanged: (val) => players[1] = val,
              ),
              TextField(
                decoration: InputDecoration(hintText: "Jugadores C"),
                onChanged: (val) => players[2] = val,
              ),
              FlatButton(
                child: Text("Agregar"),
                color: Colors.redAccent,
                onPressed: addTournament,
              )
            ],
          ),
        ),
      ),
    );
  }
}
