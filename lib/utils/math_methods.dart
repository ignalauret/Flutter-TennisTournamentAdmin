import 'dart:math' as math;

import '../models/Draw.dart';
import './constants.dart';

double log2(num x) => math.log(x) / math.log(2);

double getMargin(Draw draw, int roundLength, int index) {
  if (roundLength == index + 1) return 0;
  final int nRounds = draw.nRounds;
  final int thisRound = (log2(roundLength) + 1).floor();
  if (nRounds == thisRound) return 0;
  return (math.pow(2, nRounds - thisRound) - 1) * Constants.kDrawMatchHeight;
}

double getTopOffset(Draw draw, int roundLength) {
  final int nRounds = draw.nRounds;
  final int thisRound = (log2(roundLength) + 1).floor();
  if (nRounds == thisRound) return 0;
  return Constants.kDrawMatchHeight / 2 +
      (math.pow(2, nRounds - thisRound - 1) - 1) * Constants.kDrawMatchHeight;
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

String idOfWinner(
    String id1, String id2, List<String> result1, List<String> result2) {
  if (int.parse(result1.last) > int.parse(result2.last)) {
    // First player won.
    return id1;
  } else {
    // Second player won.
    return id2;
  }
}
