import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tennistournamentadmin/providers/players.dart';
import 'package:tennistournamentadmin/screens/create_player/insert_name_screen.dart';
import 'package:tennistournamentadmin/widgets/players/players_list.dart';

class PlayerScreen extends StatelessWidget {
  static const routeName = "/players";
  @override
  Widget build(BuildContext context) {
    final playerData = Provider.of<Players>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Jugadores"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).pushNamed(InsertNameScreen.routeName);
            },
          ),
        ],
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        child: FutureBuilder(
          future: playerData.fetchPlayers(),
          builder: (ctx, snapshot) {
            if (snapshot == null || snapshot.data == null)
              return Center(
                child: CircularProgressIndicator(),
              );
            return PlayersList(snapshot.data);
          },
        ),
      ),
    );
  }
}
