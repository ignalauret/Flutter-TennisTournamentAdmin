import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:tennistournamentadmin/utils/parsers.dart';
import '../models/player.dart';
import 'package:http/http.dart' as http;

class Players extends ChangeNotifier {
  List<Player> _players = [];

  String _newPlayerName;
  String _newPlayerClub;
  String _newPlayerNationality;
  String _newPlayerBirth;
  String _newPlayerImageUrl;
  bool _newPlayerRightHanded;
  bool _newPlayerOneHanded;

  /* CRUD Functions */
  Future<List<Player>> fetchPlayers() async {
    if (_players.isNotEmpty) return [..._players];
    final List<Player> temp = [];
    final response = await http
        .get("https://tennis-tournament-4990d.firebaseio.com/players.json");
    final responseData = json.decode(response.body) as List<dynamic>;
    for (int i = 0; i < responseData.length; i++) {
      final Map<String, dynamic> playerData = responseData[i];
      temp.add(Player.fromJson(i.toString(), playerData));
    }
    _players = temp.toList();
    notifyListeners();
    return [..._players];
  }

  void addPlayer(Player player) {
    _players.add(player);
    notifyListeners();
  }

  Future<void> createPlayer() async {
    final players = await http
        .get("https://tennis-tournament-4990d.firebaseio.com/players.json");
    final playersList = json.decode(players.body) as List;
    final playersCount = playersList == null ? 0 : playersList.length;
    final player = Player(
      name: _newPlayerName,
      club: _newPlayerClub,
      nationality: _newPlayerNationality,
      backhand: _newPlayerOneHanded ? Backhand.OneHanded : Backhand.TwoHanded,
      handed: _newPlayerRightHanded ? Handed.Right : Handed.Left,
      birth: parseDate(_newPlayerBirth),
      id: playersCount.toString(),
      profileUrl: "assets/img/ignacio_lauret_profile.png",
      imageUrl: "assets/img/ignacio_lauret_image.png",
      bestRankings: {"A": 1000, "B": 1000, "C": 1000},
      bestRankingsDates: {"A": " ", "B": " ", "C": " "},
      points: {"A": 0, "B": 0, "C": 0},
    );
    // Add player to local memory.
    addPlayer(player);
    // Add player to DB.
    http.put(
        "https://tennis-tournament-4990d.firebaseio.com/players/$playersCount.json",
        body: player.toJson());
  }

  Future<void> deletePlayer(String playerId) async {
    // Remove from local memory.
    _players.removeWhere((player) => player.id == playerId);
    // Remove from db.
    http.delete(
        "https://tennis-tournament-4990d.firebaseio.com/players/$playerId.json");
    notifyListeners();
  }

  Future<void> addPointsToPlayer(String id, int points, String category) async {
    // Add points in local memory.
    final newPoints = _addPlayerPoints(id, category, points);
    // Add points in db.
    http.put(
      "https://tennis-tournament-4990d.firebaseio.com/players/$id/points/$category.json",
      body: json.encode(newPoints),
    );
    notifyListeners();
  }

  int _addPlayerPoints(String id, String category, int points) {
    return getPlayerById(id).points.update(category, (prev) => prev + points);
  }

  /* Getters */
  List<Player> get players {
    return [..._players];
  }

  String getPlayerName(String id) {
    return getPlayerById(id).name;
  }

  int getPlayerPoints(String id, String category) {
    return getPlayerById(id).points[category];
  }

  String getPlayerImage(String id) {
    return getPlayerById(id).profileUrl;
  }

  Player getPlayerById(String id) {
    return _players.firstWhere((player) => player.id == id);
  }

  /* Setters */
  set newPlayerName(String value) {
    _newPlayerName = value;
  }

  set newPlayerClub(String value) {
    _newPlayerClub = value;
  }

  set newPlayerNationality(String value) {
    _newPlayerNationality = value;
  }

  set newPlayerBirth(String value) {
    _newPlayerBirth = value;
  }

  set newPlayerImageUrl(String value) {
    _newPlayerImageUrl = value;
  }

  set newPlayerRightHanded(bool value) {
    _newPlayerRightHanded = value;
  }

  set newPlayerOneHanded(bool value) {
    _newPlayerOneHanded = value;
  }
}
