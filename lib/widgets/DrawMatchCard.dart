import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tennistournamentadmin/providers/matches.dart';
import 'package:tennistournamentadmin/utils/parsers.dart';
import 'package:tennistournamentadmin/widgets/add_match_dialog.dart';
import '../utils/constants.dart';
import '../models/match.dart';
import './ranking_badge.dart';

class DrawMatchCard extends StatelessWidget {
  DrawMatchCard({
    @required this.name1,
    @required this.name2,
    @required this.result1,
    @required this.result2,
    @required this.isFirstWinner,
    @required this.ranking1,
    @required this.ranking2,
    this.id1,
    this.id2,
    this.tid,
    this.matchIndex,
    this.category,
    this.round,
  });

  final String id1;
  final String id2;
  final String ranking1;
  final String ranking2;
  final String name1;
  final String name2;
  final List<String> result1;
  final List<String> result2;
  final bool isFirstWinner;
  final String tid;
  final int matchIndex;
  final String category;
  final String round;

  Future<void> addMatch(List<String> result, BuildContext context) async {
    final Match match = Match(
      idPlayer1: id1,
      idPlayer2: id2,
      result1: parseResult(result[0]),
      result2: parseResult(result[1]),
      date: parseDateWithHour(result[2]),
      tournament: tid,
      category: category,
      round: round,
    );
    Provider.of<Matches>(context, listen: false).addMatch(match, matchIndex);
  }

  Widget _buildPlayerName(String name, String ranking, bool winner) {
    return Container(
      width: 130,
      height: DRAW_MATCH_HEIGHT * 0.32,
      child: Row(
        children: <Widget>[
          RankingBadge(
            ranking,
            size: 15,
          ),
          Container(
            width: 90,
            height: DRAW_MATCH_HEIGHT * 0.32,
            child: FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerLeft,
              child: Text(
                name,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                textAlign: TextAlign.start,
              ),
            ),
          ),
          SizedBox(
            width: 5,
          ),
          if (winner)
            Icon(
              Icons.check,
              size: 12,
              color: ACCENT_COLOR,
            ),
        ],
      ),
    );
  }

  Widget _buildResult(double resultWidth, List<String> result) {
    return Container(
      height: DRAW_MATCH_HEIGHT * 0.32,
      width: resultWidth,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: result.map((score) {
          return Container(
            padding: const EdgeInsets.all(5),
            child: Text(
              score[0],
              style: TextStyle(
                color: score.length == 2 ? ACCENT_COLOR : Colors.black,
                fontSize: 12,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildPlayerRow(
    String name,
    List<String> result,
    double resultWidth,
    bool winner,
    String ranking,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        _buildPlayerName(name, ranking, winner),
        _buildResult(resultWidth, result),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 5,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(BORDER_RADIUS),
      ),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: result1[0] == "  "
            ? Row(
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      Container(
                          height: DRAW_MATCH_HEIGHT * 0.32,
                          child: _buildPlayerName(name1, ranking1, false)),
                      Container(
                          height: DRAW_MATCH_HEIGHT * 0.32,
                          child: _buildPlayerName(name2, ranking2, false)),
                    ],
                  ),
                  Container(
                    height: DRAW_MATCH_HEIGHT * 0.64,
                    width: 80,
                    alignment: Alignment.centerRight,
                    child: name1.isNotEmpty && name2.isNotEmpty
                        ? IconButton(
                            icon: Icon(
                              Icons.add,
                              color: Colors.green,
                            ),
                            padding: const EdgeInsets.all(2),
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) => AddMatchDialog(
                                  name2: name2,
                                  name1: name1,
                                  ranking2: ranking2,
                                  ranking1: ranking1,
                                ),
                              ).then((result) {
                                addMatch(result, context);
                              });
                            },
                          )
                        : null,
                  ),
                ],
              )
            : Column(
                children: <Widget>[
                  _buildPlayerRow(name1, result1, 80, isFirstWinner, ranking1),
                  _buildPlayerRow(name2, result2, 80, !isFirstWinner, ranking2),
                ],
              ),
      ),
    );
  }
}
