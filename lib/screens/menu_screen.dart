import 'package:flutter/material.dart';

import 'game_screen.dart';

enum GameDifficulty { easy, medium, hard }

extension GameDifficultyX on GameDifficulty {
  String get label {
    switch (this) {
      case GameDifficulty.easy:
        return 'Easy';
      case GameDifficulty.medium:
        return 'Medium';
      case GameDifficulty.hard:
        return 'Hard';
    }
  }

  String get subtitle {
    switch (this) {
      case GameDifficulty.easy:
        return '6 pairs · 4×3 grid';
      case GameDifficulty.medium:
        return '8 pairs · 4×4 grid';
      case GameDifficulty.hard:
        return '10 pairs · 5×4 grid';
    }
  }

  int get pairCount {
    switch (this) {
      case GameDifficulty.easy:
        return 6;
      case GameDifficulty.medium:
        return 8;
      case GameDifficulty.hard:
        return 10;
    }
  }

  int get columnCount {
    switch (this) {
      case GameDifficulty.easy:
        return 4;
      case GameDifficulty.medium:
        return 4;
      case GameDifficulty.hard:
        return 5;
    }
  }
}

class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF1565C0), Color(0xFF0D47A1)],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                const SizedBox(height: 32),
                const Icon(Icons.catching_pokemon, size: 72, color: Colors.amber),
                const SizedBox(height: 12),
                Text(
                  'Pokémon Memory',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Flip cards and find matching pairs',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.white70,
                      ),
                ),
                const SizedBox(height: 40),
                ...GameDifficulty.values.map(
                  (d) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: _DifficultyButton(difficulty: d),
                  ),
                ),
                const Spacer(),
                Text(
                  'Sprites from PokeAPI · Optimized for mid-range phones',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.white54,
                      ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _DifficultyButton extends StatelessWidget {
  const _DifficultyButton({required this.difficulty});

  final GameDifficulty difficulty;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: FilledButton(
        style: FilledButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: const Color(0xFF1565C0),
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        ),
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute<void>(
              builder: (_) => GameScreen(difficulty: difficulty),
            ),
          );
        },
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    difficulty.label,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    difficulty.subtitle,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.blue.shade700.withValues(alpha: 0.8),
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.play_arrow_rounded, size: 28),
          ],
        ),
      ),
    );
  }
}
