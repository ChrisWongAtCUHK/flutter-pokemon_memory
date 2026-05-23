import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

import '../models/character_info.dart';
import '../themes/memory_theme.dart';
import '../themes/pokemon_theme.dart';

class ThemeSpriteCacheManager extends CacheManager {
  ThemeSpriteCacheManager._()
      : super(
          Config(
            'theme_sprite_cache',
            stalePeriod: const Duration(days: 365),
            maxNrOfCacheObjects: 200,
          ),
        );

  static final ThemeSpriteCacheManager instance = ThemeSpriteCacheManager._();
}

class CacheWarmProgress {
  const CacheWarmProgress({
    required this.completed,
    required this.total,
    required this.failed,
  });

  final int completed;
  final int total;
  final int failed;

  double get fraction => total == 0 ? 1 : completed / total;
  bool get isComplete => completed >= total;
}

class SpriteCacheService {
  SpriteCacheService({
    CacheManager? cacheManager,
    MemoryTheme? theme,
  })  : _cache = cacheManager ?? ThemeSpriteCacheManager.instance,
        _theme = theme ?? kPokemonTheme;

  final CacheManager _cache;
  MemoryTheme _theme;

  static final SpriteCacheService instance = SpriteCacheService();

  @visibleForTesting
  static bool skipWarmupInTests = false;

  MemoryTheme get theme => _theme;

  void setTheme(MemoryTheme theme) {
    _theme = theme;
  }

  String _cacheKey(CharacterInfo character) =>
      '${_theme.id}_${character.id}';

  Future<bool> isCached(CharacterInfo character) async {
    final file = await _cache.getFileFromCache(_cacheKey(character));
    return file != null;
  }

  Future<bool> isFullyCached() async {
    for (final character in _theme.catalog) {
      if (!await isCached(character)) return false;
    }
    return true;
  }

  Future<int> cachedCount() async {
    var count = 0;
    for (final character in _theme.catalog) {
      if (await isCached(character)) count++;
    }
    return count;
  }

  Stream<CacheWarmProgress> warmCache() async* {
    if (skipWarmupInTests) {
      yield CacheWarmProgress(
        completed: _theme.catalog.length,
        total: _theme.catalog.length,
        failed: 0,
      );
      return;
    }

    var completed = 0;
    var failed = 0;
    final total = _theme.catalog.length;

    for (final character in _theme.catalog) {
      try {
        if (await isCached(character)) {
          completed++;
        } else {
          await _cache.downloadFile(
            character.imageUrl,
            key: _cacheKey(character),
          );
          completed++;
        }
      } catch (_) {
        failed++;
        completed++;
      }
      yield CacheWarmProgress(
        completed: completed,
        total: total,
        failed: failed,
      );
    }
  }

  Future<File?> getCachedFile(CharacterInfo character) async {
    try {
      final cached = await _cache.getFileFromCache(_cacheKey(character));
      if (cached != null) return cached.file;

      return (await _cache.getSingleFile(
        character.imageUrl,
        key: _cacheKey(character),
      ));
    } catch (_) {
      return null;
    }
  }
}
