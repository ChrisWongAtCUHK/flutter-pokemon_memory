import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../data/pokemon_catalog.dart';
import '../models/memory_card.dart';
import '../widgets/flippable_card.dart';
import 'menu_screen.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key, required this.difficulty});

  final GameDifficulty difficulty;

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  final _random = Random();
  late List<MemoryCard> _cards;
  final List<int> _flippedIndices = [];
  int _moves = 0;
  int _matchedPairs = 0;
  bool _busy = false;
  Timer? _timer;
  int _elapsedSeconds = 0;

  @override
  void initState() {
    super.initState();
    _startNewGame();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) setState(() => _elapsedSeconds++);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startNewGame() {
    final pairCount = widget.difficulty.pairCount;
    final pool = List<PokemonInfo>.from(kPokemonCatalog)..shuffle(_random);
    final selected = pool.take(pairCount).toList();

    final deck = <MemoryCard>[];
    for (var i = 0; i < selected.length; i++) {
      final pokemon = selected[i];
      deck.add(MemoryCard(pairId: i, pokemon: pokemon));
      deck.add(MemoryCard(pairId: i, pokemon: pokemon));
    }
    deck.shuffle(_random);

    setState(() {
      _cards = deck;
      _flippedIndices.clear();
      _moves = 0;
      _matchedPairs = 0;
      _busy = false;
      _elapsedSeconds = 0;
    });
  }

  Future<void> _onCardTap(int index) async {
    final card = _cards[index];
    if (_busy || card.isMatched || card.isFaceUp) return;

    HapticFeedback.lightImpact();
    setState(() {
      card.isFaceUp = true;
      _flippedIndices.add(index);
    });

    if (_flippedIndices.length < 2) return;

    setState(() => _busy = true);
    _moves++;

    final a = _cards[_flippedIndices[0]];
    final b = _cards[_flippedIndices[1]];

    if (a.pairId == b.pairId) {
      await Future<void>.delayed(const Duration(milliseconds: 400));
      if (!mounted) return;
      setState(() {
        a.isMatched = true;
        b.isMatched = true;
        _matchedPairs++;
        _flippedIndices.clear();
        _busy = false;
      });
      if (_matchedPairs == widget.difficulty.pairCount) {
        _timer?.cancel();
        _showWinDialog();
      }
    } else {
      await Future<void>.delayed(const Duration(milliseconds: 750));
      if (!mounted) return;
      setState(() {
        a.isFaceUp = false;
        b.isFaceUp = false;
        _flippedIndices.clear();
        _busy = false;
      });
    }
  }

  Future<void> _showWinDialog() async {
    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('You caught them all!'),
        content: Text(
          'Moves: $_moves\nTime: ${_formatTime(_elapsedSeconds)}',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            },
            child: const Text('Menu'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.of(context).pop();
              _timer?.cancel();
              _timer = Timer.periodic(const Duration(seconds: 1), (_) {
                if (mounted) setState(() => _elapsedSeconds++);
              });
              _startNewGame();
            },
            child: const Text('Play again'),
          ),
        ],
      ),
    );
  }

  String _formatTime(int seconds) {
    final m = seconds ~/ 60;
    final s = seconds % 60;
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final columns = widget.difficulty.columnCount;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: Text(widget.difficulty.label),
        backgroundColor: const Color(0xFFE53935),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            tooltip: 'Restart',
            onPressed: _busy ? null : _startNewGame,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _StatChip(
                    icon: Icons.touch_app,
                    label: 'Moves',
                    value: '$_moves',
                  ),
                  _StatChip(
                    icon: Icons.timer_outlined,
                    label: 'Time',
                    value: _formatTime(_elapsedSeconds),
                  ),
                  _StatChip(
                    icon: Icons.check_circle_outline,
                    label: 'Pairs',
                    value: '$_matchedPairs/${widget.difficulty.pairCount}',
                  ),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                child: GridView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: columns,
                    mainAxisSpacing: 8,
                    crossAxisSpacing: 8,
                    childAspectRatio: columns >= 5 ? 0.72 : 0.78,
                  ),
                  itemCount: _cards.length,
                  itemBuilder: (context, index) {
                    return FlippableCard(
                      card: _cards[index],
                      enabled: !_busy,
                      onTap: () => _onCardTap(index),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  const _StatChip({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(color: Color(0x15000000), blurRadius: 4, offset: Offset(0, 2)),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, size: 18, color: const Color(0xFFE53935)),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          Text(label, style: const TextStyle(fontSize: 11, color: Colors.grey)),
        ],
      ),
    );
  }
}
