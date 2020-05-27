import '../models/Draw.dart';

Map<String, List<String>> parsePlayers(Map<String, List> players) {
  final Map<String, List<String>> result = {};
  players.forEach(
    (key, list) => result.addAll(
      {key: []},
    ),
  );
  players.forEach((key, list) {
    list.forEach((player) => result[key].add(player));
  });
  return result;
}

List<String> parseResult(String result) {
  return result.split(".");
}


DateTime parseDate(String date) {
  final list = date.split("/");
  return DateTime(
    int.parse(list[2]),
    int.parse(list[1]),
    int.parse(list[0]),
  );
}

String encodeDate(DateTime date) {
  final year = date.year.toString();
  final month = date.month.toString();
  final day = date.day.toString();
  return "$day/$month/$year";
}


Map<String, Draw> parseDraws(Map<String, List> draws) {
  final Map<String, Draw> result = {};
  draws.forEach((category, matches) {
    result.addAll({category: Draw([])});
    matches.forEach((match) {
      print(match);
      result[category].draw.add(match);
    });
  });
  return result;
}
