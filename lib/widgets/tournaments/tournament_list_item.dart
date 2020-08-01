import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tennistournamentadmin/models/tournament.dart';
import 'package:tennistournamentadmin/screens/tournament_detail_screen.dart';
import 'package:tennistournamentadmin/utils/constants.dart';

class TournamentListItem extends StatelessWidget {
  Widget _buildInfo(IconData icon, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Icon(
          icon,
          color: Constants.kAccentColor,
          size: 25,
        ),
        SizedBox(
          width: 5,
        ),
        FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            value,
            style: TextStyle(
              color: textColor,
              fontSize: 15,
            ),
          ),
        ),
      ],
    );
  }

  TournamentListItem(this.tournament,
      {this.color = Colors.black45, this.textColor = Colors.white});
  final Tournament tournament;
  final Color color;
  final Color textColor;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context)
            .pushNamed(TournamentDetailScreen.routeName, arguments: tournament);
      },
      child: Container(
        width: 300,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(Constants.kCardBorderRadius),
          color: color,
        ),
        padding: const EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
              width: 60,
              margin: const EdgeInsets.only(right: 10),
              child: Image.network(tournament.logoUrl),
            ),
            Container(
              width: 210,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      tournament.name,
                      style: TextStyle(
                        color: textColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 17,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 4,
                  ),
                  _buildInfo(
                    Icons.home,
                    tournament.club,
                  ),
                  _buildInfo(
                      Icons.calendar_today,
                      "Del " +
                          DateFormat("d/MM").format(tournament.start) +
                          " al " +
                          DateFormat("d/MM").format(tournament.end)),
                  _buildInfo(
                    Icons.people,
                    tournament.playerCount.toString() + " inscriptos",
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
