import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tennistournamentadmin/providers/players.dart';
import 'package:tennistournamentadmin/providers/tournaments.dart';
import 'package:tennistournamentadmin/screens/create_tournament/select_categories_screen.dart';
import 'package:tennistournamentadmin/screens/tournament_screen.dart';
import 'package:tennistournamentadmin/utils/constants.dart';
import 'package:tennistournamentadmin/widgets/buttons/action_button.dart';
import 'package:tennistournamentadmin/widgets/inputs/selectable_players_list.dart';

class SelectTournamentPlayers extends StatefulWidget {
  static const routeName = "select-players";
  @override
  _SelectTournamentPlayersState createState() =>
      _SelectTournamentPlayersState();
}

class _SelectTournamentPlayersState extends State<SelectTournamentPlayers> {
  final List<String> selectedPlayers = [];

  void selectPlayer(String id) {
    setState(() {
      if(selectedPlayers.contains(id)) {
        selectedPlayers.remove(id);
      } else {
        selectedPlayers.add(id);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final String category = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      appBar: AppBar(
        title: Text("Crear Torneo"),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(30.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    width: double.infinity,
                    alignment: Alignment.center,
                    child: Text(
                      "Seleccione los jugadores de la categoría $category",
                      style: Constants.kTitleStyle,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Expanded(
                    child: SelectablePlayersList(
                      players:
                          Provider.of<Players>(context, listen: false).players,
                      selectedIds: selectedPlayers,
                      selectPlayer: selectPlayer,
                    ),
                  )
                ],
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.all(30),
            child: ActionButton(
              "Siguiente",
              () {
                final tournamentData = Provider.of<Tournaments>(context, listen: false);
                tournamentData.newTournamentPlayers(category, selectedPlayers);
                if(category == "A" && tournamentData.newTournamentCategories[1]) {
                  Navigator.of(context).pushNamed(SelectTournamentPlayers.routeName, arguments: "B");
                } else if((category == "A" || category == "B") && tournamentData.newTournamentCategories[2]) {
                  Navigator.of(context).pushNamed(SelectTournamentPlayers.routeName, arguments: "C");
                } else {
                  tournamentData.createTournament();
                  Navigator.of(context).popUntil(
                    ModalRoute.withName(TournamentScren.routeName),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
