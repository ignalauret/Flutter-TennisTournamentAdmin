import 'package:flutter/material.dart';
import 'package:tennistournamentadmin/utils/math_methods.dart';
import 'package:tennistournamentadmin/widgets/add_match_dialog.dart';
import '../utils/constants.dart';
import './ranking_badge.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

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

  Future<void> addMatch(List<String> result) async {
    // Get matches count and add match at next available index.
    final matches = await http
        .get("https://tennis-tournament-4990d.firebaseio.com/matches.json");
    final matchesList = json.decode(matches.body) as List;
    final matchesCount = matchesList.length;
    http.put(
      "https://tennis-tournament-4990d.firebaseio.com/matches/$matchesCount.json",
      body: json.encode({
        "player1": id1,
        "player2": id2,
        "result1": result[0],
        "result2": result[1],
        "date": result[2],
        "tournament": tid,
        "category": category,
        "round": round,
      }),
    );
    // Add match to the tournament.
    http.put(
        "https://tennis-tournament-4990d.firebaseio.com/tournaments/$tid/draws/$category/$matchIndex.json",
        body: json.encode("$id1,$id2,$matchesCount"));
    // If its not the final, add winner to next match, else add the winner to the tournament winners.
    if (matchIndex != 0) {
      final response = await http.get(
        "https://tennis-tournament-4990d.firebaseio.com/tournaments/$tid/draws/$category/${getNextMatchIndex(matchIndex)}.json",
      );
      final prevData = json.decode(response.body).toString();
      final arr = prevData.split(",");
      arr[nextMatchPosition(matchIndex)] =
          idOfWinner(id1, id2, result[0], result[1]);
      http.put(
          "https://tennis-tournament-4990d.firebaseio.com/tournaments/$tid/draws/$category/${getNextMatchIndex(matchIndex)}.json",
          body: json.encode(arr.join(",")));
    } else {
      http.put(
          "https://tennis-tournament-4990d.firebaseio.com/tournaments/$tid/winners/$category.json",
          body: json.encode("${idOfWinner(id1, id2, result[0], result[1])}"));
    }
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
                                addMatch(result);
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
