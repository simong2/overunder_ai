import 'dart:convert';

import 'package:http/http.dart' as http;

class GetPlayerStat {
  Future fetchPlayerStats(String playerName) async {
    final res = await http.get(
      Uri.parse('http://127.0.0.1:8000/player_stats/$playerName'),
    );

    if (res.statusCode == 200) {
      final resDecoded = jsonDecode(res.body);

      return resDecoded["result"];
    } else {
      return "Failed to fetch player's stat";
    }
  }
}
