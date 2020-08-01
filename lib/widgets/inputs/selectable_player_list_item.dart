import 'package:flutter/material.dart';
import 'package:tennistournamentadmin/models/player.dart';
import 'package:tennistournamentadmin/utils/constants.dart';

class SelectablePlayerListItem extends StatelessWidget {
  SelectablePlayerListItem({
    @required this.player,
    this.selected = false,
  });

  final bool selected;
  final Player player;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: selected ? Constants.kAccentColor : Colors.white,
      margin: const EdgeInsets.all(5),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Container(
        height: 40,
        padding: const EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              player.name,
              style: TextStyle(
                color: selected ? Colors.white : Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            if (selected)
              Icon(
                Icons.check,
                color: Colors.white,
              ),
          ],
        ),
      ),
    );
  }
}
