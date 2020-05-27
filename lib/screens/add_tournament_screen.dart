import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tennistournamentadmin/models/Draw.dart';
import 'package:tennistournamentadmin/models/tournament.dart';
import 'package:tennistournamentadmin/utils/parsers.dart';
import '../providers/tournaments.dart';

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

  void addTournament() {
    final List<List<String>> playersList =
        players.map((playerIds) => playerIds.split(",")).toList();

    final Map<String, List<String>> playersMap = {};
    Map<String, Draw> draws = {};

    for (int i = 0; i < Categories.length; i++) {
      playersMap.addAll({Categories[i]: []});
      for (int j = 0; j < playersList[i].length; j++) {
        playersMap[Categories[i]].add(playersList[i][j]);
      }
      draws.addAll(
        {Categories[i]: Draw.fromPlayerList(playersList[i])},
      );
    }

    final tournament = Tournament(
        name: name,
        club: club,
        start: parseDate(start),
        end: parseDate(end),
        players: playersMap,
        draws: draws);
    Provider.of<Tournaments>(context, listen: false).addTournament(tournament);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Crear Torneo"),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(15),
          child: Column(
            children: <Widget>[
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
