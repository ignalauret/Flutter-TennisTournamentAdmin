import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tennistournamentadmin/providers/players.dart';
import 'package:tennistournamentadmin/screens/create_player/select_birth_screen.dart';
import 'package:tennistournamentadmin/utils/constants.dart';
import 'package:tennistournamentadmin/widgets/buttons/action_button.dart';
import 'package:tennistournamentadmin/widgets/inputs/input_card.dart';

class InsertOriginScreen extends StatelessWidget {
  static const routeName = "/player-origin";
  final clubController = TextEditingController();
  final nationalityController = TextEditingController(text: "Córdoba, Argentina");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Agregar Jugador"),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(30.0),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                      height: 80,
                    ),
                    Text(
                      "Ingrese el origen de jugador",
                      style: Constants.kTitleStyle,
                    ),
                    SizedBox(
                      height: 100,
                    ),
                    InputCard(
                      clubController,
                      "Club",
                    ),
                    SizedBox(height: 30,),
                    InputCard(
                      nationalityController,
                      "Nacionalidad",
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
                Provider.of<Players>(context, listen: false)
                    .newPlayerClub = clubController.text;
                Provider.of<Players>(context, listen: false)
                    .newPlayerNationality = nationalityController.text;
                Navigator.of(context).pushNamed(SelectBirthScreen.routeName);
              },
            ),
          ),
        ],
      ),
    );
  }
}
