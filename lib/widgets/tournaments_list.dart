import 'package:flutter/material.dart';
import 'package:tennistournamentadmin/models/tournament.dart';
import 'package:tennistournamentadmin/widgets/tournament_list_item.dart';

class TournamentsList extends StatelessWidget {
  TournamentsList(this.tournaments);
  final List<Tournament> tournaments;
  @override
  Widget build(BuildContext context) {
    if (tournaments == null)
      return Center(
        child: Text("No hay torneos"),
      );
    return ListView.builder(
      itemBuilder: (context, index) {
        return TournamentListItem(tournaments[index]);
      },
      itemCount: tournaments.length,
    );
  }
}
