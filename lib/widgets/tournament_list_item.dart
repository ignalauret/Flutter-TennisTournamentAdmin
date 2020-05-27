import 'package:flutter/material.dart';
import 'package:tennistournamentadmin/models/tournament.dart';
import 'package:tennistournamentadmin/screens/tournament_detail_screen.dart';

class TournamentListItem extends StatelessWidget {
  TournamentListItem(this.tournament);
  final Tournament tournament;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).pushNamed(TournamentDetailScreen.routeName, arguments: tournament);
      },
      child: Container(
        color: Colors.red,
        height: 150,
        width: double.infinity,
        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
        child: Text(tournament.name),
      ),
    );
  }
}
