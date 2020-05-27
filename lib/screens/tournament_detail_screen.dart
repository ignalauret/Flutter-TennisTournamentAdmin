import 'package:flutter/material.dart';
import 'package:tennistournamentadmin/widgets/tournament_draw.dart';
import '../models/tournament.dart';

class TournamentDetailScreen extends StatelessWidget {
  static const routeName = "/tournament-detail";
  @override
  Widget build(BuildContext context) {
    final Tournament tournament = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      appBar: AppBar(
        title: Text(tournament.name),
      ),
      body: Column(
        children: <Widget>[
          FlatButton(
            child: Text("Categoria A"),
            onPressed: () {
              Navigator.of(context).pushNamed(TournamentDraw.routeName,
                  arguments: {"category": "A", "tournament": tournament});
            },
          ),
          FlatButton(
            child: Text("Categoria B"),
            onPressed: () {
              Navigator.of(context).pushNamed(TournamentDraw.routeName,
                  arguments: {"category": "B", "tournament": tournament});
            },
          ),
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
