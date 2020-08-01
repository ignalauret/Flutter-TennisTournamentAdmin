import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tennistournamentadmin/providers/tournaments.dart';
import 'package:tennistournamentadmin/screens/create_tournament/add_tournament_screen.dart';
import 'package:tennistournamentadmin/widgets/tournaments/tournaments_list.dart';

class TournamentScreen extends StatelessWidget {
  static const routeName = "/tournaments";
  @override
  Widget build(BuildContext context) {
    final tournamentData = Provider.of<Tournaments>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Torneos"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            iconSize: 30,
            onPressed: () =>
                Navigator.of(context).pushNamed(AddTournamentsScreen.routeName),
          ),
        ],
      ),
      body: Container(
        child: FutureBuilder(
          future: tournamentData.fetchTournaments(),
          builder: (ctx, snapshot) {
            if (snapshot == null || snapshot.data == null)
              return Center(
                child: CircularProgressIndicator(),
              );
            return TournamentsList(snapshot.data);
          },
        ),
      ),
    );
  }
}
