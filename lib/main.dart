import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './screens/create_player/insert_name_screen.dart';
import './screens/create_player/insert_origin_screen.dart';
import './screens/create_player/select_birth_screen.dart';
import './screens/create_player/select_game_screen.dart';
import './screens/create_tournament/insert_tournament_name_screen.dart';
import './screens/create_tournament/select_categories_screen.dart';
import './screens/create_tournament/select_date_screen.dart';
import './screens/create_tournament/select_tournament_players.dart';
import './screens/player_detail_screen.dart';
import './screens/tournament_detail_screen.dart';
import './screens/tournament_draw_screen.dart';
import './screens/home_screen.dart';
import './screens/player_screen.dart';
import './screens/tournament_screen.dart';
import './providers/players.dart';
import './providers/ranking.dart';
import './providers/matches.dart';
import './providers/tournaments.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<Players>(
          create: (_) => Players(),
        ),
        ChangeNotifierProxyProvider<Players, Tournaments>(
          create: (_) => Tournaments(null, []),
          update: (_, playersData, prevTournaments) =>
              Tournaments(playersData, prevTournaments.tournaments),
        ),
        ChangeNotifierProxyProvider<Tournaments, Matches>(
          create: (_) => Matches(null, []),
          update: (context, tournamentsData, prevMatches) =>
              Matches(tournamentsData, prevMatches.matches),
        ),
        ChangeNotifierProxyProvider<Players, Ranking>(
          create: (ctx) => Ranking(null),
          update: (context, players, prev) => Ranking(players.players),
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: HomeScreen(),
        routes: {
          // Tournament
          TournamentScreen.routeName: (_) => TournamentScreen(),
          TournamentDraw.routeName: (_) => TournamentDraw(),
          TournamentDetailScreen.routeName: (_) => TournamentDetailScreen(),
          // Add Tournament
          InsertTournamentNameScreen.routeName: (_) => InsertTournamentNameScreen(),
          SelectDateScreen.routeName: (_) => SelectDateScreen(),
          SelectCategoriesScreen.routeName: (_) => SelectCategoriesScreen(),
          SelectTournamentPlayers.routeName: (_) => SelectTournamentPlayers(),
          // Players
          PlayerScreen.routeName: (_) => PlayerScreen(),
          PlayerDetailScreen.routeName: (_) => PlayerDetailScreen(),
          // Add players
          InsertNameScreen.routeName: (_) => InsertNameScreen(),
          InsertOriginScreen.routeName: (_) => InsertOriginScreen(),
          SelectBirthScreen.routeName: (_) => SelectBirthScreen(),
          SelectGameScreen.routeName: (_) => SelectGameScreen(),
        },
      ),
    );
  }
}
