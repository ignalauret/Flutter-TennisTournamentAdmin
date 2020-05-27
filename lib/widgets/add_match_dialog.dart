import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import '../utils/constants.dart';
import './ranking_badge.dart';

class AddMatchDialog extends StatefulWidget {
  AddMatchDialog({
    this.name1,
    this.name2,
    this.ranking2,
    this.ranking1,
  });

  final String name1;
  final String name2;
  final String ranking1;
  final String ranking2;
  @override
  _AddMatchDialogState createState() => _AddMatchDialogState();
}

class _AddMatchDialogState extends State<AddMatchDialog> {
  List<String> result1 = ["1", "1", ""];
  List<String> result2 = ["1", "1", ""];

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

  void addMatch() {
    final List<String> result = [
      result1[2].isEmpty ? result1[0] + "." + result1[1] : result1.join("."),
      result2[2].isEmpty ? result2[0] + "." + result2[1] : result2.join("."),
      "25/05/2020"
    ];
    Navigator.of(context).pop(result);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return AlertDialog(
      title: Text(
        "Agregar Partido",
        style: TITLE_STYLE,
      ),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(BORDER_RADIUS)),
      backgroundColor: MAIN_COLOR,
      content: Container(
        height: 300,
        width: size.width * 0.7,
        child: Column(
          children: <Widget>[
            Container(
              height: 50,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Container(
                    margin: const EdgeInsets.only(right: 10),
                    child: Text(
                      "Resultado:",
                      style: TITLE_STYLE,
                    ),
                  ),
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: "Set 1",
                        hintStyle: TextStyle(color: Colors.white),
                        border: InputBorder.none,
                      ),
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 15, color: ACCENT_COLOR),
                      onChanged: (val) {
                        if (val.contains(".")) {
                          final arr = val.split(".");
                          if (arr[1] != "") {
                            setState(() {
                              result1[0] = arr[0];
                              result2[0] = arr[1];
                            });
                          }
                        }
                      },
                    ),
                  ),
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: "Set 2",
                        hintStyle: TextStyle(color: Colors.white),
                        border: InputBorder.none,
                      ),
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 15, color: ACCENT_COLOR),
                      onChanged: (val) {
                        if (val.contains(".")) {
                          final arr = val.split(".");
                          if (arr[1] != "") {
                            setState(() {
                              result1[1] = arr[0];
                              result2[1] = arr[1];
                            });
                          }
                        }
                      },
                    ),
                  ),
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: "Set 3",
                        hintStyle: TextStyle(color: Colors.white),
                        border: InputBorder.none,
                      ),
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 15, color: ACCENT_COLOR),
                      onChanged: (val) {
                        if (val.contains(".")) {
                          final arr = val.split(".");
                          if (arr[1] != "") {
                            setState(() {
                              result1[2] = arr[0];
                              result2[2] = arr[1];
                            });
                          }
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
            Card(
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
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        Container(
                            height: DRAW_MATCH_HEIGHT * 0.32,
                            child: _buildPlayerName(
                                widget.name1, widget.ranking1, false)),
                        Container(
                            height: DRAW_MATCH_HEIGHT * 0.32,
                            child: _buildPlayerName(
                                widget.name2, widget.ranking2, false)),
                      ],
                    ),
                    Container(
                      height: DRAW_MATCH_HEIGHT * 0.64,
                      width: 80,
                      alignment: Alignment.centerRight,
                      child: Column(
                        children: <Widget>[
                          Container(
                            height: DRAW_MATCH_HEIGHT * 0.32,
                            width: 80,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: result1.map((score) {
                                return score == ""
                                    ? Container()
                                    : Container(
                                        padding: const EdgeInsets.all(5),
                                        child: Text(
                                          score[0],
                                          style: TextStyle(
                                            color: score.length == 2
                                                ? ACCENT_COLOR
                                                : Colors.black,
                                            fontSize: 12,
                                          ),
                                        ),
                                      );
                              }).toList(),
                            ),
                          ),
                          Container(
                            height: DRAW_MATCH_HEIGHT * 0.32,
                            width: 80,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: result2.map((score) {
                                return score == ""
                                    ? Container()
                                    : Container(
                                        padding: const EdgeInsets.all(5),
                                        child: Text(
                                          score[0],
                                          style: TextStyle(
                                            color: score.length == 2
                                                ? ACCENT_COLOR
                                                : Colors.black,
                                            fontSize: 12,
                                          ),
                                        ),
                                      );
                              }).toList(),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      actions: <Widget>[
        FlatButton(
          child: Text(
            "Agregar",
            style: TextStyle(color: ACCENT_COLOR),
          ),
          onPressed: addMatch,
        ),
        FlatButton(
          child: Text(
            "Cancelar",
            style: TextStyle(color: Colors.red),
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ],
    );
  }
}
