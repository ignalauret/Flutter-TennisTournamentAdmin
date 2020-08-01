import 'package:flutter/material.dart';
import '../utils/constants.dart';

class RankingBadge extends StatelessWidget {
  RankingBadge(this.rank, {this.size = 20});
  final String rank;
  final double size;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: size,
      width: size,
      margin: const EdgeInsets.only(right: 5),
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        color: Constants.kAccentColor,
        borderRadius: BorderRadius.circular(5),
      ),
      alignment: Alignment.center,
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Text(
          rank,
          style: TextStyle(
            fontSize: 13,
            color: Colors.white,
            fontWeight: FontWeight.bold
          ),
        ),
      ),
    );
  }
}
