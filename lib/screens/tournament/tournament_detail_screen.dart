import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tennistournamentadmin/providers/matches.dart';
import 'package:tennistournamentadmin/providers/tournaments.dart';
import 'package:tennistournamentadmin/screens/tournament/tournament_draw_screen.dart';
import 'package:tennistournamentadmin/utils/constants.dart';
import 'package:tennistournamentadmin/widgets/dialogs/confirm_delete_dialog.dart';
import '../../models/tournament.dart';

class TournamentDetailScreen extends StatelessWidget {
  static const routeName = "/tournament-detail";

  void deleteThisTournament(BuildContext context, Tournament tournament) {
    Provider.of<Tournaments>(context, listen: false)
        .deleteTournament(tournament.id);
    Provider.of<Matches>(context, listen: false)
        .deleteMatchesOfTournament(tournament.id);
    Navigator.of(context).pop();
  }

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
              color: Colors.black,
              fontSize: 15,
            ),
          ),
        ),
      ],
    );
  }

  _buildCategoryCard(
    BuildContext context,
    String category,
    Tournament tournament,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: InkWell(
        onTap: () {
          Navigator.of(context).pushNamed(
            TournamentDraw.routeName,
            arguments: {"category": category, "tournament": tournament},
          );
        },
        child: Card(
          elevation: 6,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(Constants.kCardBorderRadius),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: <Widget>[
                Text(
                  "Categoría $category",
                  style: Constants.kTitleStyle,
                ),
                SizedBox(height: 20),
                _buildInfo(
                    Icons.people,
                    "Inscriptos: " +
                        tournament.players[category].length.toString()),
                _buildInfo(Icons.home,
                    "Ronda actual: " + tournament.draws[category].actualRound),
                Spacer(),
                Container(
                  height: 30,
                  width: double.infinity,
                  alignment: Alignment.bottomRight,
                  child: FlatButton(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Text(
                          "Ir al cuadro",
                          style: TextStyle(
                            color: Constants.kAccentColor,
                          ),
                        ),
                        Icon(
                          Icons.arrow_forward,
                          color: Constants.kAccentColor,
                          size: 18,
                        ),
                      ],
                    ),
                    onPressed: () {
                      Navigator.of(context).pushNamed(
                        TournamentDraw.routeName,
                        arguments: {
                          "category": category,
                          "tournament": tournament
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
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
                  builder: (_) => ConfirmDeleteDialog(
                    "Esta seguro que quiere eliminar este torneo?",
                  ),
                ).then((confirm) {
                  if (confirm != null && confirm) deleteThisTournament(context, tournament);
                });
              },
            ),
          ],
        ),
        body: Container(
          height: MediaQuery.of(context).size.height,
          width: double.infinity,
          child: ListView.builder(
            itemBuilder: (context, index) {
              if (tournament.players[Categories[index]] != null)
                return Container(
                  height: 180,
                  width: double.infinity,
                  child: _buildCategoryCard(
                      context, Categories[index], tournament),
                );
              else
                return Container();
            },
            itemCount: Categories.length,
          ),
        ));
  }
}
