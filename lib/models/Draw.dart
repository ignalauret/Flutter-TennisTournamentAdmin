import 'dart:math';

import 'package:tennistournamentadmin/utils/constants.dart';
import 'package:tennistournamentadmin/utils/math_methods.dart';

const List<String> Rounds = [
  "Final",
  "Semifinal",
  "Cuartos de Final",
  "Octavos de Final"
];

class Draw {
  final List<String> _draw;

  Draw(this._draw);

  factory Draw.fromPlayerList(List<String> playersIds) {
    return Draw(buildDraw(playersIds));
  }

  // Generates an entire draw from a list of players.
  // Made static to use it in factory constructor.
  static List<String> buildDraw(List<String> playersIds) {
    final int nPlayers = playersIds.length;
    if (nPlayers < 2) return [];
    final int nRounds = log2(nPlayers).ceil();
    final int nMatches = pow(2, nRounds) - 1;
    // 2^n = sum(2^n-1, 2^n-2...) + 1
    final int drawSize = nMatches + 1;
    for (int i = 0; i < drawSize - nPlayers; i++) {
      playersIds.add("-1");
    }
    // Fill the draw with empty matches
    final List<String> result = List.generate(nMatches, (_) => ",,");
    // Add matches in order
    //TODO: Tournament ranking order.
    for (int i = 0; i < (drawSize / 2).floor(); i++) {
      result[nMatches - i - 1] =
          "${playersIds[2 * i]},${playersIds[2 * i + 1]},";
      // Add to next match if opponent is Bye.
      if (playersIds[2 * i] == "-1") {
        result[getNextMatchIndex(nMatches - i - 1)] =
            nextMatchPosition(nMatches - i - 1) == 0
                ? "${playersIds[2 * i + 1]},,"
                : ",${playersIds[2 * i + 1]},";
        result[nMatches - i - 1] =
            "${playersIds[2 * i]},${playersIds[2 * i + 1]},-1";
      }
      if (playersIds[2 * i + 1] == "-1") {
        result[getNextMatchIndex(nMatches - i - 1)] =
            nextMatchPosition(nMatches - i - 1) == 0
                ? "${playersIds[2 * i]},,"
                : ",${playersIds[2 * i]},";
        result[nMatches - i - 1] =
            "${playersIds[2 * i]},${playersIds[2 * i + 1]},-1";
      }
    }
    return result;
  }

  /* Getters */

  List<String> get draw {
    return [..._draw];
  }

  int get nRounds {
    return log2(_draw.length).floor() + 1;
  }

  double get drawHeight {
    return pow(2, nRounds - 1) * DRAW_MATCH_HEIGHT;
  }

  Map<String, List<String>> getSortedDraw() {
    final Map<String, List<String>> temp = {};
    // For each round, add to the map the matches.
    for (int i = 0; i < nRounds; i++) {
      temp.addAll({
        Rounds[i]: [],
      });
      if (i == 0) {
        temp[Rounds[i]].add(_draw[0]);
      } else {
        for (int j = pow(2, i) - 1; j < pow(2, i + 1) - 1; j++) {
          temp[Rounds[i]].add(_draw[j]);
        }
      }
    }
    final Map<String, List<String>> result = {};
    Rounds.sublist(0, nRounds).reversed.forEach(
          (round) => result.addAll({round: temp[round]}),
        );
    return result;
  }

  String getMatch(int index) {
    return _draw[index];
  }

  /* Setters */
  void setMatch(int index, String match) {
    _draw[index] = match;
  }

  void addMatch(String match) {
    _draw.add(match);
  }
}
