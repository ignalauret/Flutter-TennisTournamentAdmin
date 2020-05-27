import 'package:flutter/material.dart';
import '../utils/constants.dart';

class PlayerListItem extends StatelessWidget {
  PlayerListItem({
    this.name,
  });
  final String name;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(
        horizontal: 15,
        vertical: 5,
      ),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(BORDER_RADIUS)),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width * 0.3,
              alignment: Alignment.centerLeft,
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  name,
                  style: PLAYER_NAME_STYLE,
                  textAlign: TextAlign.start,
                ),
              ),
            ),
//            Expanded(
//              child: Text(
//                tournaments,
//                textAlign: TextAlign.center,
//              ),
//            ),
//            Container(
//              width: MediaQuery.of(context).size.width * 0.12,
//              child: Text(
//                points,
//                style: TextStyle(
//                  color: ACCENT_COLOR,
//                ),
//                textAlign: TextAlign.center,
//              ),
//            )
          ],
        ),
      ),
    );
  }
}
