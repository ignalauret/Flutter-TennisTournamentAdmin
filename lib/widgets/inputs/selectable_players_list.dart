import 'package:flutter/material.dart';
import 'package:tennistournamentadmin/models/player.dart';
import 'package:tennistournamentadmin/widgets/inputs/selectable_player_list_item.dart';

class SelectablePlayersList extends StatelessWidget {
  SelectablePlayersList({
    @required this.players,
    @required this.selectedIds,
    @required this.selectPlayer,
  });

  final List<Player> players;
  final List<String> selectedIds;
  final Function(String) selectPlayer;
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: (context, index) => InkWell(
        onTap: () => selectPlayer(players[index].id),
        child: SelectablePlayerListItem(
          player: players[index],
          selected: selectedIds.contains(players[index].id),
        ),
      ),
      itemCount: players.length,
    );
  }
}
