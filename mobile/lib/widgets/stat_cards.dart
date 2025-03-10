import 'package:flutter/material.dart';

class StatCards extends StatelessWidget {
  final String statTitle;
  final String stat;
  final Color? cardColor;

  const StatCards({
    super.key,
    required this.statTitle,
    required this.stat,
    this.cardColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120,
      width: 100,
      decoration: BoxDecoration(
        color: cardColor ?? Colors.blue.shade50,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 8),
          Text(
            statTitle,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: Colors.blue.shade800,
            ),
          ),
          const SizedBox(height: 10),
          Container(
            height: 62,
            width: 72,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.blue.withOpacity(0.2),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Center(
              child: Text(
                stat,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue.shade700,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
