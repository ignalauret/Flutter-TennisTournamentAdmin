import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

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
  List<String> winners = ["", "", ""];

  Future<void> addTournament() async {
    final tournaments = await http.get("https://tennis-tournament-4990d.firebaseio.com/tournaments.json");
    final tournamentsList = json.decode(tournaments.body) as List;
    final tournamentsCount = tournamentsList.length;
    final List<List<String>> playersList =
        players.map((playerIds) => playerIds.split(",")).toList();
    final Map<String, Map<String, String>> playersMap = {};

    playersMap.addAll({"A": {}, "B": {}, "C": {}});
    for (int j = 0; j < playersList[0].length; j++) {
      playersMap["A"].addAll({j.toString(): playersList[0][j]});
    }
    for (int j = 0; j < playersList[1].length; j++) {
      playersMap["B"].addAll({j.toString(): playersList[1][j]});
    }
    for (int j = 0; j < playersList[2].length; j++) {
      playersMap["C"].addAll({j.toString(): playersList[2][j]});
    }
    final Map<String, String> winnersMap = {
      "A": winners[0],
      "B": winners[1],
      "C": winners[2]
    };
    Map<String, Map<String, String>> draw = {};
    draw.addAll({"Final": {"0": "2"}},);
    draw.addAll({"Semifinal": {"0": "1", "1": "0"}},);

    final response = await http.put(
      "https://tennis-tournament-4990d.firebaseio.com/tournaments/$tournamentsCount.json",
      body: json.encode({
        "name": name,
        "club": club,
        "start": start,
        "end": end,
        "players": playersMap,
        "winners": winnersMap,
        "draws": {"A" : draw},
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Container(
                    width: size.width * 0.25,
                    child: TextField(
                      decoration: InputDecoration(hintText: "Winner A"),
                      onChanged: (val) => winners[0] = val,
                    ),
                  ),
                  Container(
                    width: size.width * 0.25,
                    child: TextField(
                      decoration: InputDecoration(hintText: "Winner B"),
                      onChanged: (val) => winners[1] = val,
                    ),
                  ),
                  Container(
                    width: size.width * 0.25,
                    child: TextField(
                      decoration: InputDecoration(hintText: "Winner C"),
                      onChanged: (val) => winners[2] = val,
                    ),
                  ),
                ],
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
