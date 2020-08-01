import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tennistournamentadmin/providers/players.dart';
import 'package:tennistournamentadmin/providers/ranking.dart';
import 'package:tennistournamentadmin/screens/player_screen.dart';
import 'package:tennistournamentadmin/screens/tournament_screen.dart';
import 'package:tennistournamentadmin/utils/constants.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    Provider.of<Players>(context, listen: false).fetchPlayers();
    Provider.of<Ranking>(context, listen: false).fetchRanking("A");
    super.initState();
  }

  Widget _buildRouteCard(
    String title,
    String description,
    String route,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: InkWell(
        onTap: () {
          Navigator.of(context).pushNamed(route);
        },
        child: Card(
          elevation: 6,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(Constants.kCardBorderRadius),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: <Widget>[
                Text(
                  title,
                  style: Constants.kTitleStyle,
                ),
                SizedBox(height: 20),
                Text(
                  description,
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 15,
                  ),
                ),
                Spacer(),
                Container(
                  height: 30,
                  width: double.infinity,
                  alignment: Alignment.bottomRight,
                  child: FlatButton(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Text("Ir a $title"),
                        Icon(Icons.arrow_forward),
                      ],
                    ),
                    onPressed: () {
                      Navigator.of(context).pushNamed(route);
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home"),
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Expanded(
              child: _buildRouteCard(
                "Torneos",
                "Crea o elimina torneos, agrega partidos a tus torneos o solo mira como van los cuadros de tus torneos.",
                TournamentScreen.routeName,
              ),
            ),
            Expanded(
              child: _buildRouteCard(
                "Jugadores",
                "Mira todos los jugadores, agrega nuevos, edita los existentes o elimina los jugadores que no participen más del circuito.",
                PlayerScreen.routeName,
              ),
            ),Expanded(
              child: _buildRouteCard(
                "Cuenta",
                "Administra tu cuenta, cambia el nombre de tu club o la foto de este.",
                TournamentScreen.routeName,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
