import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tennistournamentadmin/providers/tournaments.dart';
import 'package:tennistournamentadmin/screens/create_tournament/select_tournament_players.dart';
import 'package:tennistournamentadmin/utils/constants.dart';
import 'package:tennistournamentadmin/widgets/buttons/action_button.dart';
import 'package:tennistournamentadmin/widgets/inputs/categories_chips.dart';

class SelectCategoriesScreen extends StatefulWidget {
  static const routeName = "select-categories";
  @override
  _SelectCategoriesScreenState createState() => _SelectCategoriesScreenState();
}

class _SelectCategoriesScreenState extends State<SelectCategoriesScreen> {
  bool selectedCategoryA = false;
  bool selectedCategoryB = false;
  bool selectedCategoryC = false;

  void onTapA() {
    setState(() {
      selectedCategoryA = !selectedCategoryA;
    });
  }

  void onTapB() {
    setState(() {
      selectedCategoryB = !selectedCategoryB;
    });
  }

  void onTapC() {
    setState(() {
      selectedCategoryC = !selectedCategoryC;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Crear Torneo"),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(30.0),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    SizedBox(
                      height: 80,
                    ),
                    Container(
                      width: double.infinity,
                      alignment: Alignment.center,
                      child: Text(
                        "Seleccione las categorías",
                        style: Constants.kTitleStyle,
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height - 400,
                      child: Column(
                        children: <Widget>[
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: CategoriesChips(
                                  selectedCategoryA, onTapA, "Categoría A"),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: CategoriesChips(
                                  selectedCategoryB, onTapB, "Categoría B"),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: CategoriesChips(
                                  selectedCategoryC, onTapC, "Categoría C"),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.all(30),
            child: ActionButton(
              "Siguiente",
              () {
                final tournamentData = Provider.of<Tournaments>(context, listen: false);
                tournamentData.newTournamentCategory(0, selectedCategoryA);
                tournamentData.newTournamentCategory(1, selectedCategoryB);
                tournamentData.newTournamentCategory(2, selectedCategoryC);
                if(selectedCategoryA) {
                  Navigator.of(context).pushNamed(SelectTournamentPlayers.routeName, arguments: "A");
                } else if(selectedCategoryB) {
                  Navigator.of(context).pushNamed(SelectTournamentPlayers.routeName, arguments: "B");
                } else if(selectedCategoryC) {
                  Navigator.of(context).pushNamed(SelectTournamentPlayers.routeName, arguments: "C");
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
