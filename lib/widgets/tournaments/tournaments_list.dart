import 'package:flutter/material.dart';
import 'package:tennistournamentadmin/models/tournament.dart';
import 'package:tennistournamentadmin/utils/constants.dart';
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
          margin: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 10,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(Constants.kCardBorderRadius),
          ),
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
