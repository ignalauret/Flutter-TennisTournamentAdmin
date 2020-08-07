import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tennistournamentadmin/providers/players.dart';
import 'package:tennistournamentadmin/screens/create_player/insert_origin_screen.dart';
import 'package:tennistournamentadmin/utils/constants.dart';
import 'package:tennistournamentadmin/widgets/buttons/action_button.dart';
import 'package:tennistournamentadmin/widgets/inputs/input_card.dart';

class InsertNameScreen extends StatelessWidget {
  static const routeName = "/add-player";
  final nameController = TextEditingController();

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
                      "Ingrese el nombre completo",
                      style: Constants.kTitleStyle,
                    ),
                    SizedBox(
                      height: 100,
                    ),
                    InputCard(
                      nameController,
                      "Nombre",
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
                    .newPlayerName = nameController.text;
                Navigator.of(context).pushNamed(InsertOriginScreen.routeName);
              },
            ),
          ),
        ],
      ),
    );
  }
}
