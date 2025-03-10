import 'package:flutter/material.dart';
import 'package:mobile/screens/player_screen.dart';
import 'package:mobile/services/get_player_stat.dart';
import '../widgets/stat_cards.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late TextEditingController _playerName;
  bool _isLoading = false;
  bool _playerInfoStatus = false;
  String playerName = "";
  String points = '0.0';
  String rebounds = '0.0';
  String assists = '0.0';
  int id = 0;

  @override
  void initState() {
    super.initState();
    _playerName = TextEditingController();
  }

  @override
  void dispose() {
    _playerName.dispose();
    super.dispose();
  }

  Future<void> _searchPlayer() async {
    if (_playerName.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a player name'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    var playerStat = await GetPlayerStat().fetchPlayerStats(_playerName.text);

    setState(() {
      _isLoading = false;

      if (playerStat is String) {
        _playerInfoStatus = false;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(playerStat),
            behavior: SnackBarBehavior.floating,
          ),
        );
      } else {
        _playerInfoStatus = true;
        playerName = _playerName.text;
        points = playerStat["points"];
        assists = playerStat["assists"];
        rebounds = playerStat["rebounds"];
        id = playerStat['id'];
      }
    });
  }

  void _resetStats() {
    setState(() {
      _playerInfoStatus = false;
      _playerName.clear();
      playerName = "";
      points = '0.0';
      assists = '0.0';
      rebounds = '0.0';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        backgroundColor: Colors.blue.shade700,
        title: const Text(
          "NBA Stats Analyzer",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        elevation: 2,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: _resetStats,
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Search Section
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 20.0,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Find Player Stats",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: _playerName,
                        decoration: InputDecoration(
                          hintText: 'Enter the NBA player\'s full name',
                          filled: true,
                          fillColor: Colors.grey.shade100,
                          suffixIcon: _isLoading
                              ? const Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child:
                                      CircularProgressIndicator(strokeWidth: 2),
                                )
                              : IconButton(
                                  onPressed: _searchPlayer,
                                  icon: const Icon(
                                    Icons.search,
                                    color: Colors.blue,
                                  ),
                                ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: const EdgeInsets.only(
                              left: 12, top: 16, bottom: 16),
                        ),
                        onSubmitted: (_) => _searchPlayer(),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                if (_playerInfoStatus) ...[
                  Container(
                    height: 365,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(100),
                          child: Container(
                            height: 120,
                            width: 120,
                            color: Colors.grey.shade200,
                            child: Image.network(
                              "https://cdn.nba.com/headshots/nba/latest/1040x760/$id.png",
                              fit: BoxFit.cover,
                              errorBuilder: (ctx, error, _) => const Icon(
                                Icons.person,
                                size: 80,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          playerName,
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "2024-25 Season Stats",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade700,
                          ),
                        ),
                        const SizedBox(height: 24),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            StatCards(
                              statTitle: 'PTS',
                              stat: points,
                              cardColor: Colors.blue.shade50,
                            ),
                            StatCards(
                              statTitle: 'AST',
                              stat: assists,
                              cardColor: Colors.green.shade50,
                            ),
                            StatCards(
                              statTitle: 'REB',
                              stat: rebounds,
                              cardColor: Colors.orange.shade50,
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.blue.shade700, Colors.purple.shade700],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.blue.withOpacity(0.3),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.auto_awesome,
                              color: Colors.white,
                              size: 24,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              "AI Sports Analysis",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white.withOpacity(0.95),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        Center(
                          child: ElevatedButton.icon(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => PlayerScreen(
                                      playerName: _playerName.text),
                                ),
                              );
                            },
                            icon: const Icon(Icons.bolt),
                            label: const Text("Generate Analysis"),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: Colors.blue.shade800,
                              disabledBackgroundColor:
                                  Colors.white.withOpacity(0.7),
                              disabledForegroundColor:
                                  Colors.blue.shade800.withOpacity(0.5),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 24, vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ] else ...[
                  Container(
                    height: 365,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.sports_basketball,
                            size: 70,
                            color: Colors.blue.shade300,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            "Search for a player to view season stats",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey.shade700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.blue.shade700,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    padding: const EdgeInsets.all(20.0),
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Leverage AI",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 24,
                          ),
                        ),
                        SizedBox(height: 8),
                        Center(
                          child: Text(
                            "💸 for your 🏀",
                            style: TextStyle(
                              fontStyle: FontStyle.italic,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontSize: 24,
                            ),
                          ),
                        ),
                        SizedBox(height: 8),
                        Align(
                          alignment: Alignment.topRight,
                          child: Text(
                            "NBA sports betting",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
