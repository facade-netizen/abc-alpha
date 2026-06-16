import 'package:flutter/material.dart';

import '../../../../reusable/colors.dart';

class TemplateChip extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  const TemplateChip({super.key, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: applyOpacity(grey, 0.1),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: applyOpacity(grey, 0.3)),
        ),
        child: Text(label, style: TextStyle(fontSize: 12, color: applyOpacity(black, 0.8))),
      ),
    );
  }
}

class MarqueeTips extends StatelessWidget {
  const MarqueeTips({super.key, this.width});
  final double? width;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [applyOpacity(green, 0.1), applyOpacity(blue, 0.1)]),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: applyOpacity(green, 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.sports_score, size: 20, color: applyOpacity(green, 0.8)),
              const SizedBox(width: 8),
              Text(
                'Effective Betting Marquee Examples:',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: applyOpacity(green, 0.8)),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            '• ⚽ Premier League: Arsenal vs Chelsea - Match Odds: 2.10 | 3.20 | 2.90\n'
            '• 🏏 IND vs AUS - T20 World Cup: Live betting now! 1.85 | 2.05\n'
            '• 🎾 Wimbledon Final: Murray vs Djokovic - Bet €10 get €20\n'
            '• 🏀 NBA Finals: Lakers vs Celtics - Special odds: 1.95\n'
            '• ⚡ Double Winnings on all accumulator bets today!',
            style: TextStyle(fontSize: 12, color: applyOpacity(black, 0.8), height: 1.6),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: applyOpacity(green, 0.1), borderRadius: BorderRadius.circular(8)),
            child: Row(
              children: [
                Icon(Icons.trending_up, size: 16, color: applyOpacity(green, 0.7)),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Marquees with odds and match names get 40% more clicks',
                    style: TextStyle(fontSize: 11, fontWeight: FontWeight.w500, color: applyOpacity(green, 0.8)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class MarqueeHintCard extends StatelessWidget {
  const MarqueeHintCard({super.key, this.width});
  final double? width;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: applyOpacity(primaryColor, 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: applyOpacity(primaryColor, 0.3)),
      ),
      child: Row(
        children: [
          Icon(Icons.lightbulb, size: 18, color: applyOpacity(primaryColor, 0.9)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Pro Tip:',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: applyOpacity(primaryColor, 0.9)),
                ),
                const SizedBox(height: 2),
                Text('Include match name, odds, and betting prompts for higher engagement', style: TextStyle(fontSize: 11, color: applyOpacity(black, 0.6))),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class MarqueePreviewCard extends StatelessWidget {
  const MarqueePreviewCard({super.key, this.width, required this.preview});
  final double? width;
  final String preview;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [indigo, blue]),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: applyOpacity(blue, 0.3), blurRadius: 8, offset: const Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(color: primaryColor, borderRadius: BorderRadius.circular(4)),
                child: const Text(
                  'LIVE PREVIEW',
                  style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: black),
                ),
              ),
              const SizedBox(width: 8),
              const Icon(Icons.sports_esports, size: 16, color: white70),
              const SizedBox(width: 4),
              const Text('Betting Marquee', style: TextStyle(fontSize: 12, color: white70)),
            ],
          ),
          const SizedBox(height: 12),
          // Animated marquee effect
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  const Icon(Icons.bolt, color: primaryColor, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    preview,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: white, letterSpacing: 0.5),
                  ),
                  const SizedBox(width: 16),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(color: applyOpacity(red, 0.9), borderRadius: BorderRadius.circular(12)),
                    child: const Text(
                      'BET NOW',
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: white),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const Divider(color: white24),
          Row(
            children: [
              const Icon(Icons.info_outline, size: 16, color: white70),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'This marquee appears on home screen & match pages',
                  style: TextStyle(fontSize: 12, color: applyOpacity(white, 0.8), fontStyle: FontStyle.italic),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
