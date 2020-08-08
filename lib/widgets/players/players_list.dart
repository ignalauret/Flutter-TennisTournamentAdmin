import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tennistournamentadmin/models/player.dart';
import 'package:tennistournamentadmin/screens/player/player_detail_screen.dart';
import '../../providers/players.dart';
import 'player_list_item.dart';

class PlayersList extends StatelessWidget {
  PlayersList(this.players);
  final List<Player> players;
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(0),
      itemBuilder: (ctx, index) => InkWell(
        onTap: () => Navigator.of(context).pushNamed(
          PlayerDetailScreen.routeName,
          arguments: players[index],
        ),
        child: PlayerListItem(players[index]),
      ),
      itemCount: players.length,
    );
  }
}
