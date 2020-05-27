import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tennistournamentadmin/providers/matches.dart';
import 'package:tennistournamentadmin/providers/players.dart';
import 'package:tennistournamentadmin/providers/ranking.dart';
import 'package:tennistournamentadmin/screens/player_screen.dart';
import 'package:tennistournamentadmin/screens/tournament_screen.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Provider.of<Players>(context).fetchPlayers();
    Provider.of<Matches>(context).fetchMatches();
    Provider.of<Ranking>(context).fetchRanking("A");
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text("Home"),
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            InkWell(
              onTap: () {
                Navigator.of(context).pushNamed(TournamentScren.routeName);
              },
              child: Card(
                margin: const EdgeInsets.symmetric(horizontal: 15),
                elevation: 10,
                child: Container(
                  height: size.height * 0.40,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Center(
                    child: Text("Torneos"),
                  ),
                ),
              ),
            ),
            InkWell(
              onTap: () {
                Navigator.of(context).pushNamed(PlayerScreen.routeName);
              },
              child: Card(
                margin: const EdgeInsets.symmetric(horizontal: 15),
                elevation: 10,
                child: Container(
                  height: size.height * 0.40,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Center(
                    child: Text("Jugadores"),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
