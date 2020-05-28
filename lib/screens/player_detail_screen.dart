import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tennistournamentadmin/models/player.dart';
import 'package:tennistournamentadmin/providers/matches.dart';
import 'package:tennistournamentadmin/providers/players.dart';
import 'package:tennistournamentadmin/providers/tournaments.dart';
import 'package:tennistournamentadmin/widgets/dialogs/confirm_dialog.dart';

class PlayerDetailScreen extends StatelessWidget {
  static const routeName = "/player-profile";

  @override
  Widget build(BuildContext context) {
    final Player player = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      appBar: AppBar(
        title: Text(player.name),
        actions: <Widget>[
          DeleteButton(player),
        ],
      ),
      body: Column(
        children: <Widget>[],
      ),
    );
  }
}

class DeleteButton extends StatelessWidget {
  DeleteButton(this.player);
  final Player player;
  void deletePlayer(BuildContext context, Player player) {
    bool hasMatches = Provider.of<Matches>(context, listen: false)
        .playerHasMatches(player.id);
    bool hasTournaments = Provider.of<Tournaments>(context, listen: false)
        .playerHasTournaments(player.id);
    if (hasMatches) {
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text("Lo sentimos, este jugador tiene partidos."),
      ));
    } else if (hasTournaments) {
      Scaffold.of(context).showSnackBar(
        SnackBar(
          content: Text("Lo sentimos, este jugador ha participado en torneos."),
        ),
      );
    } else {
      Provider.of<Players>(context, listen: false).deletePlayer(player.id);
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        Icons.delete,
        size: 25,
      ),
      onPressed: () {
        showDialog(
          context: context,
          builder: (_) => ConfirmDialog(
              "Esta seguro que quiere eliminar a ${player.name}?"),
        ).then((confirm) {
          if (confirm) deletePlayer(context, player);
        });
      },
    );
  }
}
