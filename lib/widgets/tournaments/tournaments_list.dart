import 'package:flutter/material.dart';
import 'package:tennistournamentadmin/models/tournament.dart';
import 'package:tennistournamentadmin/widgets/tournaments/tournament_list_item.dart';

class TournamentsList extends StatelessWidget {
  TournamentsList(this.tournaments);
  final List<Tournament> tournaments;
  @override
  Widget build(BuildContext context) {
    if (tournaments.isEmpty)
      return Center(
        child: Text("No hay torneos"),
      );
    return ListView.builder(
      itemBuilder: (context, index) {
        return Card(
          elevation: 8,
          margin: const EdgeInsets.all(20),
          child: TournamentListItem(
            tournaments[index],
            color: Colors.white,
            textColor: Colors.black,
          ),
        );
      },
      itemCount: tournaments.length,
    );
  }
}
