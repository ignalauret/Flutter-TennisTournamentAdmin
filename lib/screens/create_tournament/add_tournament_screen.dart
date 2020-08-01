import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tennistournamentadmin/models/tournament.dart';
import 'package:tennistournamentadmin/providers/tournaments.dart';
import 'package:tennistournamentadmin/screens/create_tournament/select_date_screen.dart';
import 'package:tennistournamentadmin/utils/constants.dart';
import 'package:tennistournamentadmin/widgets/buttons/action_button.dart';
import 'package:tennistournamentadmin/widgets/inputs/input_card.dart';

class AddTournamentsScreen extends StatelessWidget {
  static const routeName = "/add-tournament";
  final nameController = TextEditingController();

//  void addTournament() {
//    final List<List<String>> playersList =
//        players.map((playerIds) => playerIds.split(",")).toList();
//
//    final Map<String, List<String>> playersMap = {};
//    Map<String, Draw> draws = {};
//
//    for (int i = 0; i < Categories.length; i++) {
//      playersMap.addAll({Categories[i]: []});
//      for (int j = 0; j < playersList[i].length; j++) {
//        playersMap[Categories[i]].add(playersList[i][j]);
//      }
//      draws.addAll(
//        {Categories[i]: Draw.fromPlayerList(playersList[i])},
//      );
//    }
//
//    final tournament = Tournament(
//        name: name,
//        club: club,
//        start: parseDate(start),
//        end: parseDate(end),
//        players: playersMap,
//        draws: draws);
//    Provider.of<Tournaments>(context, listen: false).addTournament(tournament);
//  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Crear Torneo"),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(30.0),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                      height: 80,
                    ),
                    Text(
                      "Ingrese el nombre",
                      style: Constants.kTitleStyle,
                    ),
                    SizedBox(
                      height: 100,
                    ),
                    InputCard(
                      nameController,
                      "Nombre",
                    ),
                  ],
                ),
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.all(30),
            child: ActionButton(
              "Siguiente",
              () {
                Provider.of<Tournaments>(context, listen: false)
                    .newTournamentName = nameController.text;
                Navigator.of(context).pushNamed(SelectDateScreen.routeName);
              },
            ),
          ),
        ],
      ),
    );
  }
}
