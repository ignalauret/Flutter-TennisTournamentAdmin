import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tennistournamentadmin/providers/tournaments.dart';
import 'package:tennistournamentadmin/widgets/tournaments_list.dart';

class TournamentScren extends StatelessWidget {
  static const routeName = "/tournaments";
  @override
  Widget build(BuildContext context) {
    final tournamentData = Provider.of<Tournaments>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Torneos"),
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
