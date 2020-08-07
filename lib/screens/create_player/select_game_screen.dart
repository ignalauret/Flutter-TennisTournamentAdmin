import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tennistournamentadmin/providers/players.dart';
import 'package:tennistournamentadmin/utils/constants.dart';
import 'package:tennistournamentadmin/widgets/buttons/action_button.dart';
import 'package:tennistournamentadmin/widgets/inputs/categories_chips.dart';

import '../player_screen.dart';

class SelectGameScreen extends StatefulWidget {
  static const routeName = "/player-game";
  @override
  _SelectGameScreenState createState() => _SelectGameScreenState();
}

class _SelectGameScreenState extends State<SelectGameScreen> {
  bool rightHanded = false;
  bool oneHanded = false;

  void onTapA() {
    setState(() {
      rightHanded = !rightHanded;
    });
  }

  void onTapB() {
    setState(() {
      oneHanded = !oneHanded;
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
                        "Ingrese el estilo de juego",
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
                                  rightHanded, onTapA, "Derecho"),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: CategoriesChips(
                                  oneHanded, onTapB, "Una mano"),
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
              "Finalizar",
                  () {
                final playersData = Provider.of<Players>(context, listen: false);
                playersData.newPlayerRightHanded = rightHanded;
                playersData.newPlayerOneHanded = oneHanded;
                playersData.createPlayer();
                Navigator.of(context).popUntil(
                  ModalRoute.withName(PlayerScreen.routeName),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
