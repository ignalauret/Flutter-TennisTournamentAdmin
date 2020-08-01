import 'package:diagonal_scrollview/diagonal_scrollview.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/tournament.dart';
import '../models/match.dart';
import '../providers/matches.dart';
import '../providers/players.dart';
import '../providers/ranking.dart';
import '../utils/constants.dart';
import '../utils/math_methods.dart';
import '../widgets/DrawMatchCard.dart';

class TournamentDraw extends StatefulWidget {
  static const routeName = "/tournament-draw";

  @override
  _TournamentDrawState createState() => _TournamentDrawState();
}

class _TournamentDrawState extends State<TournamentDraw> {
  Widget _buildMatchCard(
    Match match,
    Players playerData,
    Ranking rankingData,
    double bottomMargin,
  ) {
    final name1 = playerData.getPlayerName(match.idPlayer1);
    final name2 = playerData.getPlayerName(match.idPlayer2);
    return Container(
      height: Constants.kDrawMatchHeight,
      margin: EdgeInsets.only(bottom: bottomMargin),
      alignment: Alignment.center,
      child: DrawMatchCard(
        name1: name1,
        name2: name2,
        ranking1: rankingData.getRankingOf(match.idPlayer1, match.category),
        ranking2: rankingData.getRankingOf(match.idPlayer2, match.category),
        result1: match.getColouredResult(true),
        result2: match.getColouredResult(false),
        isFirstWinner: match.isFirstWinner,
      ),
    );
  }

  Widget _buildByeMatch(
    String idPlayer1,
    String idPlayer2,
    double bottomMargin,
    Ranking rankingData,
    Players playerData,
    String category,
  ) {
    String name1;
    String name2;
    String ranking1;
    String ranking2;
    bool isFirstWinner;
    if (idPlayer1 == "-1") {
      name1 = "Bye";
      name2 = playerData.getPlayerName(idPlayer2);
      ranking1 = "-";
      ranking2 = rankingData.getRankingOf(idPlayer2, category);
      isFirstWinner = false;
    } else {
      name1 = playerData.getPlayerName(idPlayer1);
      name2 = "Bye";
      ranking1 = rankingData.getRankingOf(idPlayer1, category);
      ranking2 = "-";
      isFirstWinner = true;
    }
    return Container(
      height: Constants.kDrawMatchHeight,
      margin: EdgeInsets.only(bottom: bottomMargin),
      alignment: Alignment.center,
      child: DrawMatchCard(
        name1: name1,
        name2: name2,
        ranking1: ranking1,
        ranking2: ranking2,
        result1: [" ", " ", " "],
        result2: [" ", " ", " "],
        isFirstWinner: isFirstWinner,
      ),
    );
  }

  Widget _buildUnplayedMatch(
      String round,
      int matchIndex,
      String tid,
      String selectedCategory,
      String idPlayer1,
      String idPlayer2,
      Players playerData,
      Ranking rankingData,
      double bottomMargin) {
    final name1 = idPlayer1.isEmpty ? "" : playerData.getPlayerName(idPlayer1);
    final name2 = idPlayer2.isEmpty ? "" : playerData.getPlayerName(idPlayer2);
    return Container(
      height: Constants.kDrawMatchHeight,
      margin: EdgeInsets.only(bottom: bottomMargin),
      alignment: Alignment.center,
      child: DrawMatchCard(
        name1: name1,
        name2: name2,
        ranking1: idPlayer1.isEmpty
            ? "-"
            : rankingData.getRankingOf(idPlayer1, selectedCategory),
        ranking2: idPlayer2.isEmpty
            ? "-"
            : rankingData.getRankingOf(idPlayer2, selectedCategory),
        result1: ["  ", "  ", "  "],
        result2: ["  ", "  ", "  "],
        isFirstWinner: false,
        tid: tid,
        matchIndex: matchIndex,
        round: round,
        category: selectedCategory,
        id1: idPlayer1,
        id2: idPlayer2,
      ),
    );
  }

  List<Widget> _buildMatches({
    Tournament tournament,
    String selectedCategory,
    List<String> matches,
    String title,
    Matches matchesData,
    Players playerData,
    Ranking rankingData,
  }) {
    final List<Widget> result = [];
    for (int i = 0; i < matches.length; i++) {
      final data = matches[i].split(",");
      if (data[2] == "")
        result.add(
          _buildUnplayedMatch(
            title,
            getMatchIndex(matches.length, i),
            tournament.id,
            selectedCategory,
            data[0],
            data[1],
            playerData,
            rankingData,
            getMargin(tournament.draws[selectedCategory], matches.length, i),
          ),
        );
      else if (data[2] == "-1")
        result.add(_buildByeMatch(
            data[0],
            data[1],
            getMargin(tournament.draws[selectedCategory], matches.length, i),
            rankingData,
            playerData,
            selectedCategory));
      else
        result.add(
          _buildMatchCard(
            matchesData.getMatchById(data[2]),
            playerData,
            rankingData,
            getMargin(tournament.draws[selectedCategory], matches.length, i),
          ),
        );
    }
    return result;
  }

  Widget _buildRoundColumn({
    Tournament tournament,
    String selectedCategory,
    List<String> matches,
    String title,
    Matches matchesData,
    Players playerData,
    Ranking rankingData,
  }) {
    return Column(
      children: <Widget>[
        Text(
          title,
          style: Constants.kSubtitleStyle,
        ),
        SizedBox(
          height:
              getTopOffset(tournament.draws[selectedCategory], matches.length),
        ),
        ..._buildMatches(
            title: title,
            tournament: tournament,
            selectedCategory: selectedCategory,
            matchesData: matchesData,
            matches: matches,
            playerData: playerData,
            rankingData: rankingData),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final matchesData = Provider.of<Matches>(context);
    final playerData = Provider.of<Players>(context);
    final rankingData = Provider.of<Ranking>(context);
    final args =
        ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
    final selectedCategory = args["category"];
    final Tournament tournament = args["tournament"];
    return Scaffold(
      backgroundColor: Constants.kMainColor,
      appBar: AppBar(
        title: Text(tournament.name + " Categoria " + selectedCategory),
      ),
      body: FutureBuilder(
          future: matchesData.fetchMatches(),
          builder: (context, snapshot) {
            if (snapshot.data == null)
              return Center(
                child: CircularProgressIndicator(),
              );
            return Container(
              child: DiagonalScrollView(
                maxHeight: tournament.draws[selectedCategory].drawHeight + 20,
                maxWidth: 1000,
                child: Container(
                  height: tournament.draws[selectedCategory].drawHeight + 20,
                  width: 1000,
                  margin: const EdgeInsets.all(15),
                  child: Row(
                    children: tournament.draws[selectedCategory]
                        .getSortedDraw()
                        .entries
                        .map(
                          (entry) => _buildRoundColumn(
                            matches: entry.value,
                            title: entry.key,
                            matchesData: matchesData,
                            playerData: playerData,
                            rankingData: rankingData,
                            tournament: tournament,
                            selectedCategory: selectedCategory,
                          ),
                        )
                        .toList(),
                  ),
                ),
              ),
            );
          }),
    );
  }
}
