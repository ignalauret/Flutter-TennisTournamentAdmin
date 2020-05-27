import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tennistournamentadmin/models/player.dart';
import '../providers/players.dart';
import 'player_list_item.dart';

class PlayersList extends StatelessWidget {
  PlayersList(this.players);
  final List<Player> players;
  @override
  Widget build(BuildContext context) {
    final playersData = Provider.of<Players>(context);
    return ListView.builder(
      padding: const EdgeInsets.all(0),
      itemBuilder: (ctx, index) => InkWell(
//        onTap: () => Navigator.of(context).pushNamed(
//          //PlayerProfileScreen.routeName,
//          arguments: playersData.getPlayerById(ranking[index]),
//        ),
        child: PlayerListItem(
          name: players[index].name,
        ),
      ),
      itemCount: players.length,
    );
  }
}
