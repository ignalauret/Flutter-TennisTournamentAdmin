import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tennistournamentadmin/providers/matches.dart';
import 'package:tennistournamentadmin/providers/players.dart';
import 'package:tennistournamentadmin/providers/tournaments.dart';
import 'package:tennistournamentadmin/screens/tournament_draw_screen.dart';
import 'package:tennistournamentadmin/utils/constants.dart';
import 'package:tennistournamentadmin/widgets/dialogs/confirm_dialog.dart';
import '../models/tournament.dart';

class TournamentDetailScreen extends StatelessWidget {
  static const routeName = "/tournament-detail";

  void deleteThisTournament(BuildContext context, Tournament tournament) {
    Provider.of<Tournaments>(context, listen: false)
        .deleteTournament(tournament.id);
    Provider.of<Matches>(context, listen: false)
        .deleteMatchesOfTournament(tournament.id);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final Tournament tournament = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      appBar: AppBar(
        title: Text(tournament.name),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.delete),
            iconSize: 25,
            onPressed: () {
              showDialog(
                context: context,
                builder: (_) => ConfirmDialog(
                    "Esta seguro que quiere eliminar este torneo?"),
              ).then((confirm) {
                if (confirm) deleteThisTournament(context, tournament);
              });
            },
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          Text(
            "Cuadros",
            style: Constants.kTitleStyle,
          ),
          if (tournament.players["A"] != null)
            FlatButton(
              child: Text("Categoria A"),
              onPressed: () {
                Navigator.of(context).pushNamed(TournamentDraw.routeName,
                    arguments: {"category": "A", "tournament": tournament});
              },
            ),
          if (tournament.players["B"] != null)
            FlatButton(
              child: Text("Categoria B"),
              onPressed: () {
                Navigator.of(context).pushNamed(TournamentDraw.routeName,
                    arguments: {"category": "B", "tournament": tournament});
              },
            ),
          if (tournament.players["C"] != null)
            FlatButton(
              child: Text("Categoria C"),
              onPressed: () {
                Navigator.pushNamed(context, TournamentDraw.routeName,
                    arguments: {"category": "C", "tournament": tournament});
              },
            ),
        ],
      ),
    );
  }
}
