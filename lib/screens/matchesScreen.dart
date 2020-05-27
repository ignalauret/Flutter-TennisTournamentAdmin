import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

List<String> rounds = ["Cuartos de Final", "Semifinal", "Final"];

class MatchesScreen extends StatefulWidget {
  @override
  _MatchesScreenState createState() => _MatchesScreenState();
}

class _MatchesScreenState extends State<MatchesScreen> {
  String p1;
  String p2;
  String r1;
  String r2;
  String date;
  String tournamentId;
  String round;
  String category;

  Future<void> addMatch() async {
    final matches = await http
        .get("https://tennis-tournament-4990d.firebaseio.com/matches.json");
    final matchesList = json.decode(matches.body) as List;
    final matchesCount = 0; // matchesList.length;
    http.put(
      "https://tennis-tournament-4990d.firebaseio.com/matches/$matchesCount.json",
      body: json.encode({
        "player1": p1,
        "player2": p2,
        "result1": r1,
        "result2": r2,
        "date": date,
        "tournament": tournamentId,
        "category": category,
        "round": round,
      }),
    );
    var response = await http.get(
        "https://tennis-tournament-4990d.firebaseio.com/tournaments/$tournamentId/draws/$category.json");
    final data = json.decode(response.body) as Map<String, dynamic>;
    final index = data[round].indexWhere((match) {
      final list = match.toString().split(",");
      return (list[0] == p1 || list[1] == p1);
    });
    http.put(
        "https://tennis-tournament-4990d.firebaseio.com/tournaments/$tournamentId/draws/$category/$round/$index.json",
        body: json.encode("$p1,$p2,$matchesCount"));
    if(round != "Final") {
      final newIndex = 0; //TODO
      final newRound = rounds[rounds.indexOf(round) + 1];
      final previousData = data[newRound][newIndex].toString();
      final list = previousData.split(",");
      if(index % 2 == 0) list.insert(0, p1);
      else list.insert(1, p1);
      http.put(
          "https://tennis-tournament-4990d.firebaseio.com/tournaments/$tournamentId/draws/$category/$newRound/$newIndex.json",
          body: json.encode("${list[0]},${list[1]},${list[2]}"));

    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Partidos"),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(15),
          child: Column(
            children: <Widget>[
              Text("Agregar Partido"),
              TextField(
                decoration: InputDecoration(hintText: "Player 1"),
                onChanged: (val) => p1 = val,
              ),
              TextField(
                decoration: InputDecoration(hintText: "Player 2"),
                onChanged: (val) => p2 = val,
              ),
              TextField(
                decoration: InputDecoration(hintText: "Result 1"),
                onChanged: (val) => r1 = val,
              ),
              TextField(
                decoration: InputDecoration(hintText: "Result 2"),
                onChanged: (val) => r2 = val,
              ),
              TextField(
                decoration: InputDecoration(hintText: "Torneo"),
                onChanged: (val) => tournamentId = val,
              ),
              TextField(
                decoration: InputDecoration(hintText: "Ronda"),
                onChanged: (val) => round = val,
              ),
              TextField(
                decoration: InputDecoration(hintText: "Fecha"),
                onChanged: (val) => date = val,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  FlatButton(
                    child: Text("A"),
                    color: category == "A" ? Colors.black26 : Colors.white,
                    onPressed: () {
                      setState(() {
                        category = "A";
                      });
                    },
                  ),
                  FlatButton(
                    child: Text("B"),
                    color: category == "B" ? Colors.black26 : Colors.white,
                    onPressed: () {
                      setState(() {
                        category = "B";
                      });
                    },
                  ),
                  FlatButton(
                    child: Text("C"),
                    color: category == "C" ? Colors.black26 : Colors.white,
                    onPressed: () {
                      setState(() {
                        category = "C";
                      });
                    },
                  ),
                ],
              ),
              FlatButton(
                child: Text("Agregar"),
                color: Colors.redAccent,
                onPressed: addMatch,
              )
            ],
          ),
        ),
      ),
    );
  }
}
