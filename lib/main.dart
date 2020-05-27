import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tennistournamentadmin/screens/add_player_screen.dart';
import 'package:tennistournamentadmin/screens/add_tournament_screen.dart';
import 'package:tennistournamentadmin/screens/tournament_detail_screen.dart';
import 'package:tennistournamentadmin/screens/tournament_draw_screen.dart';
import './screens/home_screen.dart';
import './screens/player_screen.dart';
import './screens/tournament_screen.dart';
import './providers/players.dart';
import './providers/ranking.dart';
import './providers/matches.dart';
import './providers/tournaments.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<Players>(
          create: (_) => Players(),
        ),
        ChangeNotifierProvider<Tournaments>(
          create: (_) => Tournaments(),
        ),
        ChangeNotifierProxyProvider<Tournaments, Matches>(
          create: (_) => Matches(null, []),
          update: (context, tournamentsData, prevMatches) => Matches(tournamentsData, prevMatches.matches),
        ),
        ChangeNotifierProxyProvider<Players, Ranking>(
          create: (ctx) => Ranking(null),
          update: (context, players, prev) => Ranking(players.players),
        ),

      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          // This is the theme of your application.
          //
          // Try running your application with "flutter run". You'll see the
          // application has a blue toolbar. Then, without quitting the app, try
          // changing the primarySwatch below to Colors.green and then invoke
          // "hot reload" (press "r" in the console where you ran "flutter run",
          // or simply save your changes to "hot reload" in a Flutter IDE).
          // Notice that the counter didn't reset back to zero; the application
          // is not restarted.
          primarySwatch: Colors.blue,
        ),
        home: HomeScreen(),
        routes: {
          TournamentScren.routeName: (_) => TournamentScren(),
          PlayerScreen.routeName: (_) => PlayerScreen(),
          AddPlayerScreen.routeName: (_) => AddPlayerScreen(),
          TournamentDraw.routeName: (_) => TournamentDraw(),
          TournamentDetailScreen.routeName: (_) => TournamentDetailScreen(),
          AddTournamentsScreen.routeName: (_) => AddTournamentsScreen(),
        },
      ),
    );
  }
}
