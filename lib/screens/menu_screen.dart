import 'package:flutter/material.dart';

import '../data/pokemon_catalog.dart';
import '../services/sprite_cache_service.dart';
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

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key, this.cacheService});

  final SpriteCacheService? cacheService;

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  late final SpriteCacheService _cache;
  bool _cacheReady = false;
  bool _warming = false;
  double _progress = 0;
  int _failedDownloads = 0;
  String _cacheStatus = 'Checking cache…';

  @override
  void initState() {
    super.initState();
    _cache = widget.cacheService ?? SpriteCacheService.instance;
    _prepareCache();
  }

  Future<void> _prepareCache() async {
    if (await _cache.isFullyCached()) {
      if (!mounted) return;
      setState(() {
        _cacheReady = true;
        _cacheStatus = 'Offline ready · ${kPokemonCatalog.length} sprites cached';
      });
      return;
    }
    await _warmCache();
  }

  Future<void> _warmCache() async {
    setState(() {
      _warming = true;
      _cacheReady = false;
      _progress = 0;
      _failedDownloads = 0;
      _cacheStatus = 'Downloading sprites for offline play…';
    });

    await for (final progress in _cache.warmCache()) {
      if (!mounted) return;
      setState(() {
        _progress = progress.fraction;
        _failedDownloads = progress.failed;
      });
    }

    if (!mounted) return;
    final ready = await _cache.isFullyCached();
    final cached = await _cache.cachedCount();
    if (!mounted) return;
    setState(() {
      _warming = false;
      if (ready) {
        _cacheReady = true;
        _cacheStatus = 'Offline ready · ${kPokemonCatalog.length} sprites cached';
      } else if (_failedDownloads > 0) {
        _cacheReady = cached >= kPokemonCatalog.length ~/ 2;
        _cacheStatus =
            '$cached/${kPokemonCatalog.length} cached · connect to retry';
      } else {
        _cacheReady = true;
        _cacheStatus = 'Sprites cached';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final canPlay = _cacheReady && !_warming;

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
                const SizedBox(height: 24),
                _CacheStatusBanner(
                  status: _cacheStatus,
                  warming: _warming,
                  progress: _progress,
                  onRetry: _failedDownloads > 0 && !_warming ? _warmCache : null,
                ),
                const SizedBox(height: 24),
                ...GameDifficulty.values.map(
                  (d) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: _DifficultyButton(
                      difficulty: d,
                      enabled: canPlay,
                    ),
                  ),
                ),
                const Spacer(),
                Text(
                  'Sprites cached on device · no network needed after download',
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

class _CacheStatusBanner extends StatelessWidget {
  const _CacheStatusBanner({
    required this.status,
    required this.warming,
    required this.progress,
    this.onRetry,
  });

  final String status;
  final bool warming;
  final double progress;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                warming
                    ? Icons.cloud_download_outlined
                    : Icons.offline_pin_outlined,
                color: Colors.amber,
                size: 20,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  status,
                  style: const TextStyle(color: Colors.white, fontSize: 13),
                ),
              ),
              if (onRetry != null)
                TextButton(
                  onPressed: onRetry,
                  style: TextButton.styleFrom(foregroundColor: Colors.amber),
                  child: const Text('Retry'),
                ),
            ],
          ),
          if (warming) ...[
            const SizedBox(height: 10),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: progress > 0 ? progress : null,
                minHeight: 6,
                backgroundColor: Colors.white24,
                color: Colors.amber,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _DifficultyButton extends StatelessWidget {
  const _DifficultyButton({
    required this.difficulty,
    required this.enabled,
  });

  final GameDifficulty difficulty;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: FilledButton(
        style: FilledButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: const Color(0xFF1565C0),
          disabledBackgroundColor: Colors.white38,
          disabledForegroundColor: Colors.blueGrey,
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        ),
        onPressed: enabled
            ? () {
                Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (_) => GameScreen(difficulty: difficulty),
                  ),
                );
              }
            : null,
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
