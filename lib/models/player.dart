import 'dart:convert';

import 'package:flutter/material.dart';
import '../utils/parsers.dart';

enum Backhand { OneHanded, TwoHanded }
enum Handed { Right, Left }

class Player {
  Player({
    @required this.id,
    @required this.name,
    @required this.birth,
    @required this.points,
    @required this.nationality,
    @required this.club,
    @required this.bestRankings,
    @required this.bestRankingsDates,
    this.profileUrl,
    this.imageUrl,
    this.backhand = Backhand.TwoHanded,
    this.handed = Handed.Right,
  });

  final String id;
  final String name;
  final DateTime birth;
  final Map<String, int> points;
  final String profileUrl;
  final String imageUrl;
  final Backhand backhand;
  final Handed handed;
  final String nationality;
  final String club;
  final Map<String, int> bestRankings;
  final Map<String, String> bestRankingsDates;

  /* Getters */
  int get age {
    final now = DateTime.now();
    final years = now.year - birth.year;
    if (now.month < birth.month) return years - 1;
    if (now.month == birth.month && now.day < birth.day) return years - 1;
    return years;
  }

  String get backhandType {
    return backhand == Backhand.OneHanded ? "Una mano" : "Dos manos";
  }

  String get hand {
    return handed == Handed.Right ? "Derecha" : "Izquierda";
  }

  int getPointsOfCategory(String category) {
    return points[category];
  }

  bool playsCategory(String category) {
    return points[category] != 0;
  }

  String getParsedHand() {
    return handed == Handed.Right ? "r" : "l";
  }

  int getParsedBackhand() {
    return backhand == Backhand.OneHanded ? 1 : 2;
  }

  /* Parsers */
  Player.fromJson(String id, Map<String, dynamic> playerData)
      : id = id,
        name = playerData["name"],
        birth = parseDate(playerData["birth"]),
        nationality = playerData["nationality"],
        club = playerData["club"],
        profileUrl = playerData["profileUrl"],
        imageUrl = playerData["coverUrl"],
        handed = playerData["handed"] == "r" ? Handed.Right : Handed.Left,
        backhand = playerData["backhand"] == 1
            ? Backhand.OneHanded
            : Backhand.TwoHanded,
        points = Map<String, int>.from(playerData["points"]),
        bestRankings = Map<String, int>.from(playerData["bestRankings"]),
        bestRankingsDates =
        Map<String, String>.from(playerData["bestRankingsDates"]);

  String toJson() {
    return json.encode({
      "name": name,
      "club": club,
      "nationality": nationality,
      "backhand": getParsedBackhand(),
      "handed": getParsedHand(),
      "birth": encodeDate(birth),
      "bestRankings": bestRankings,
      "bestRankingsDates": bestRankingsDates,
      "points": points,
      "coverUrl": imageUrl,
      "profileUrl": profileUrl,
    });
  }
}
