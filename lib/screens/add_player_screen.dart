import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:tennistournamentadmin/providers/players.dart';
import 'package:tennistournamentadmin/utils/parsers.dart';
import '../models/player.dart';

class AddPlayerScreen extends StatefulWidget {
  static const routeName = "/add-player";
  @override
  _AddPlayerScreenState createState() => _AddPlayerScreenState();
}

class _AddPlayerScreenState extends State<AddPlayerScreen> {
  String name = "";
  String club = "";
  String nationality = "";
  int backhand = 1;
  String handed = "r";
  String birth = "";

  Future<void> addPlayer() async {
    final players = await http
        .get("https://tennis-tournament-4990d.firebaseio.com/players.json");
    final playersList = json.decode(players.body) as List;
    final playersCount = playersList.length;
    final player = Player(
      name: name,
      club: club,
      nationality: nationality,
      backhand: backhand == 1 ? Backhand.OneHanded : Backhand.TwoHanded,
      handed: handed == "r" ? Handed.Right : Handed.Left,
      birth: parseDate(birth),
      id: playersCount.toString(),
      profileUrl: "assets/img/ignacio_lauret_profile.png",
      imageUrl: "assets/img/ignacio_lauret_image.png",
      bestRankings: {"A": 1000, "B": 1000, "C": 1000},
      bestRankingsDates: {"A": " ", "B": " ", "C": " "},
      points: {"A": 0, "B": 0, "C": 0},
    );
    Provider.of<Players>(context, listen: false).addPlayer(player);

    final response = await http.put(
        "https://tennis-tournament-4990d.firebaseio.com/players/$playersCount.json",
        body: player.toJson());

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Añadir Jugador"),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(15),
          child: Column(
            children: <Widget>[
              Text("Agregar jugador"),
              TextField(
                decoration: InputDecoration(hintText: "Nombre"),
                onChanged: (val) => name = val,
              ),
              TextField(
                decoration: InputDecoration(hintText: "Club"),
                onChanged: (val) => club = val,
              ),
              TextField(
                decoration: InputDecoration(hintText: "Nacionalidad"),
                onChanged: (val) => nationality = val,
              ),
              TextField(
                decoration: InputDecoration(hintText: "Nacimiento"),
                onChanged: (val) => birth = val,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  FlatButton(
                    child: Text("Derecho"),
                    color: handed == "r" ? Colors.black26 : Colors.white,
                    onPressed: () {
                      setState(() {
                        handed = "r";
                      });
                    },
                  ),
                  FlatButton(
                    child: Text("Zurdo"),
                    color: handed == "l" ? Colors.black26 : Colors.white,
                    onPressed: () {
                      setState(() {
                        handed = "l";
                      });
                    },
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  FlatButton(
                    child: Text("Una mano"),
                    color: backhand == 1 ? Colors.black26 : Colors.white,
                    onPressed: () {
                      setState(() {
                        backhand = 1;
                      });
                    },
                  ),
                  FlatButton(
                    child: Text("Dos manos"),
                    color: backhand == 2 ? Colors.black26 : Colors.white,
                    onPressed: () {
                      setState(() {
                        backhand = 2;
                      });
                    },
                  ),
                ],
              ),
              FlatButton(
                child: Text("Agregar"),
                color: Colors.redAccent,
                onPressed: () {
                  addPlayer().then((_) => Navigator.of(context).pop());
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
