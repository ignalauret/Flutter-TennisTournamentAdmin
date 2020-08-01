import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tennistournamentadmin/providers/tournaments.dart';
import 'package:tennistournamentadmin/screens/create_tournament/select_categories_screen.dart';
import 'package:tennistournamentadmin/utils/constants.dart';
import 'package:tennistournamentadmin/widgets/buttons/action_button.dart';
import 'package:tennistournamentadmin/widgets/inputs/input_card.dart';

class SelectDateScreen extends StatefulWidget {
  static const routeName = "/select-date";
  @override
  _SelectDateScreenState createState() => _SelectDateScreenState();
}

class _SelectDateScreenState extends State<SelectDateScreen> {
  final startController = TextEditingController();
  final endController = TextEditingController();

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
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                      height: 80,
                    ),
                    Text(
                      "Seleccione las fechas",
                      style: Constants.kTitleStyle,
                    ),
                    SizedBox(
                      height: 100,
                    ),
                    InputCard(
                      startController,
                      "Inicio",
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    InputCard(
                      endController,
                      "Final esperado",
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
                tournamentData.newTournamentStart = startController.text;
                tournamentData.newTournamentEnd = endController.text;
                Navigator.of(context).pushNamed(SelectCategoriesScreen.routeName);
              },
            ),
          ),
        ],
      ),
    );
  }
}
