import 'dart:math' as math;

import '../models/Draw.dart';
import './constants.dart';

double log2(num x) => math.log(x) / math.log(2);

double getMargin(Draw draw, int roundLength, int index) {
  if (roundLength == index + 1) return 0;
  final int nRounds = draw.nRounds;
  final int thisRound = (log2(roundLength) + 1).floor();
  if (nRounds == thisRound) return 0;
  return (math.pow(2, nRounds - thisRound) - 1) * DRAW_MATCH_HEIGHT;
}

double getTopOffset(Draw draw, int roundLength) {
  final int nRounds = draw.nRounds;
  final int thisRound = (log2(roundLength) + 1).floor();
  if (nRounds == thisRound) return 0;
  return DRAW_MATCH_HEIGHT / 2 +
      (math.pow(2, nRounds - thisRound - 1) - 1) * DRAW_MATCH_HEIGHT;
}

// Returns the index of the match given the matches in the round and the index
// in the round.
int getMatchIndex(int roundLength, int roundIndex) {
  final int thisRound = (log2(roundLength) + 1).floor();
  final firstIndex = math.pow(2, thisRound - 1) - 1;
  return firstIndex + roundIndex;
}

// Returns the index of the match that the winner will play.
int getNextMatchIndex(int index) {
  return (index / 2).ceil() - 1;
}

// Returns 0 if next match the name mast go on top, and 1 otherwise.
int nextMatchPosition(int index) {
  return (index + 1) % 2;
}

String idOfWinner(String id1, String id2, String result1, String result2) {
  final arr1 = result1.split(".");
  final arr2 = result2.split(".");
  if(int.parse(arr1.last) > int.parse(arr2.last)) {
    // First player won.
    return id1;
  } else {
    // Second player won.
    return id2;
  }
}
