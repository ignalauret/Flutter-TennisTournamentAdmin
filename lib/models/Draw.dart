import 'dart:math';

import 'package:tennistournamentadmin/utils/constants.dart';
import 'package:tennistournamentadmin/utils/math_methods.dart';

List<String> rounds = ["Final", "Semifinal", "Cuartos de Final", "Octavos de Final"];

class Draw {
  final List<String> draw;

  Draw(this.draw);

  int get nRounds {
    return log2(draw.length).floor() + 1;
  }

  double get drawHeight {
    return pow(2, nRounds - 1) * DRAW_MATCH_HEIGHT;
  }

  Map<String, List<String>> getSortedDraw() {
    final Map<String, List<String>> temp = {};
    // For each round, add to the map the matches.
    for (int i = 0; i < nRounds; i++) {
      temp.addAll({
        rounds[i]: [],
      });
      if (i == 0) {
        temp[rounds[i]].add(draw[0]);
      } else {
        for (int j = pow(2, i) - 1; j < pow(2, i + 1) - 1; j++) {
          temp[rounds[i]].add(draw[j]);
        }
      }
    }
    final Map<String, List<String>> result = {};
    rounds.sublist(0, nRounds).reversed.forEach(
          (round) => result.addAll({round: temp[round]}),
        );
    return result;
  }
}
