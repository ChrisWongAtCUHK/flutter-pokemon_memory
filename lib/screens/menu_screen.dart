import 'package:flutter/material.dart';

import '../services/sprite_cache_service.dart';
import '../themes/memory_theme.dart';
import '../themes/theme_registry.dart';
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
  MemoryTheme _selectedTheme = kAllThemes.first;
  bool _cacheReady = false;
  bool _warming = false;
  double _progress = 0;
  int _failedDownloads = 0;
  String _cacheStatus = 'Checking cache…';

  @override
  void initState() {
    super.initState();
    _cache = widget.cacheService ?? SpriteCacheService.instance;
    _cache.setTheme(_selectedTheme);
    _prepareCache();
  }

  Future<void> _onThemeSelected(MemoryTheme theme) async {
    if (_selectedTheme.id == theme.id || _warming) return;
    setState(() => _selectedTheme = theme);
    _cache.setTheme(theme);
    await _prepareCache();
  }

  Future<void> _prepareCache() async {
    if (await _cache.isFullyCached()) {
      if (!mounted) return;
      setState(() {
        _cacheReady = true;
        _cacheStatus =
            'Offline ready · ${_selectedTheme.catalog.length} ${_selectedTheme.name} images';
      });
      return;
    }
    await _warmCache();
  }

  Future<void> _warmCache({bool forceRefresh = false}) async {
    setState(() {
      _warming = true;
      _cacheReady = false;
      _progress = 0;
      _failedDownloads = 0;
      _cacheStatus = forceRefresh
          ? 'Retrying ${_selectedTheme.name} downloads…'
          : 'Downloading ${_selectedTheme.name} images…';
    });

    await for (final progress in _cache.warmCache(forceRefresh: forceRefresh)) {
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
        _cacheStatus =
            'Offline ready · ${_selectedTheme.catalog.length} ${_selectedTheme.name} images';
      } else if (_failedDownloads > 0) {
        _cacheReady = cached >= _selectedTheme.catalog.length ~/ 2;
        _cacheStatus =
            '$cached/${_selectedTheme.catalog.length} cached · connect to retry';
      } else {
        _cacheReady = true;
        _cacheStatus = 'Images cached';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final canPlay = _cacheReady && !_warming;
    final theme = _selectedTheme;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [theme.secondaryColor, theme.secondaryColor.withValues(alpha: 0.92)],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                const SizedBox(height: 24),
                Icon(theme.menuIcon, size: 64, color: theme.accentColor),
                const SizedBox(height: 12),
                Text(
                  'Anime Memory',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  theme.tagline,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.white70,
                      ),
                ),
                const SizedBox(height: 20),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Choose theme',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: Colors.white70,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ),
                const SizedBox(height: 10),
                _ThemePicker(
                  themes: kAllThemes,
                  selected: _selectedTheme,
                  onSelected: _onThemeSelected,
                  enabled: !_warming,
                ),
                const SizedBox(height: 20),
                _CacheStatusBanner(
                  status: _cacheStatus,
                  warming: _warming,
                  progress: _progress,
                  accent: theme.accentColor,
                  onRetry: !_warming ? () => _warmCache(forceRefresh: true) : null,
                ),
                const SizedBox(height: 20),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Difficulty',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: Colors.white70,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ),
                const SizedBox(height: 10),
                ...GameDifficulty.values.map(
                  (d) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: _DifficultyButton(
                      difficulty: d,
                      theme: theme,
                      enabled: canPlay,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  'Each theme caches separately · play offline after download',
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

class _ThemePicker extends StatelessWidget {
  const _ThemePicker({
    required this.themes,
    required this.selected,
    required this.onSelected,
    required this.enabled,
  });

  final List<MemoryTheme> themes;
  final MemoryTheme selected;
  final ValueChanged<MemoryTheme> onSelected;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: themes.map((theme) {
        final isSelected = theme.id == selected.id;
        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(
              right: theme.id != themes.last.id ? 8 : 0,
            ),
            child: Material(
              color: isSelected
                  ? theme.primaryColor
                  : Colors.white.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(12),
              child: InkWell(
                onTap: enabled || isSelected
                    ? () => onSelected(theme)
                    : null,
                borderRadius: BorderRadius.circular(12),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Column(
                    children: [
                      Icon(
                        theme.menuIcon,
                        color: isSelected ? Colors.white : Colors.white70,
                        size: 26,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        theme.name,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: isSelected ? Colors.white : Colors.white70,
                          fontSize: 12,
                          fontWeight:
                              isSelected ? FontWeight.bold : FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

class _CacheStatusBanner extends StatelessWidget {
  const _CacheStatusBanner({
    required this.status,
    required this.warming,
    required this.progress,
    required this.accent,
    this.onRetry,
  });

  final String status;
  final bool warming;
  final double progress;
  final Color accent;
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
                color: accent,
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
                  style: TextButton.styleFrom(foregroundColor: accent),
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
                color: accent,
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
    required this.theme,
    required this.enabled,
  });

  final GameDifficulty difficulty;
  final MemoryTheme theme;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: FilledButton(
        style: FilledButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: theme.primaryColor,
          disabledBackgroundColor: Colors.white38,
          disabledForegroundColor: Colors.blueGrey,
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        ),
        onPressed: enabled
            ? () {
                Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (_) => GameScreen(
                      theme: theme,
                      difficulty: difficulty,
                    ),
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
                      color: theme.primaryColor.withValues(alpha: 0.75),
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
