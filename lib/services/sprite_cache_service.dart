import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

import '../data/pokemon_catalog.dart';

/// Disk cache for PokeAPI sprites — survives app restarts and works offline.
class PokemonSpriteCacheManager extends CacheManager {
  PokemonSpriteCacheManager._()
      : super(
          Config(
            'pokemon_sprite_cache',
            stalePeriod: const Duration(days: 365),
            maxNrOfCacheObjects: 64,
          ),
        );

  static final PokemonSpriteCacheManager instance = PokemonSpriteCacheManager._();
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
  SpriteCacheService({CacheManager? cacheManager})
      : _cache = cacheManager ?? PokemonSpriteCacheManager.instance;

  final CacheManager _cache;

  static final SpriteCacheService instance = SpriteCacheService();

  @visibleForTesting
  static bool skipWarmupInTests = false;

  String _cacheKey(PokemonInfo pokemon) => 'pokemon_${pokemon.id}';

  Future<bool> isCached(PokemonInfo pokemon) async {
    final file = await _cache.getFileFromCache(_cacheKey(pokemon));
    return file != null;
  }

  Future<bool> isFullyCached() async {
    for (final pokemon in kPokemonCatalog) {
      if (!await isCached(pokemon)) return false;
    }
    return true;
  }

  Future<int> cachedCount() async {
    var count = 0;
    for (final pokemon in kPokemonCatalog) {
      if (await isCached(pokemon)) count++;
    }
    return count;
  }

  /// Downloads any missing sprites. Yields progress after each Pokémon.
  Stream<CacheWarmProgress> warmCache() async* {
    if (skipWarmupInTests) {
      yield CacheWarmProgress(
        completed: kPokemonCatalog.length,
        total: kPokemonCatalog.length,
        failed: 0,
      );
      return;
    }

    var completed = 0;
    var failed = 0;
    final total = kPokemonCatalog.length;

    for (final pokemon in kPokemonCatalog) {
      try {
        if (await isCached(pokemon)) {
          completed++;
        } else {
          await _cache.downloadFile(
            pokemon.spriteUrl,
            key: _cacheKey(pokemon),
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

  Future<File?> getCachedFile(PokemonInfo pokemon) async {
    try {
      final cached = await _cache.getFileFromCache(_cacheKey(pokemon));
      if (cached != null) return cached.file;

      return (await _cache.getSingleFile(
        pokemon.spriteUrl,
        key: _cacheKey(pokemon),
      ));
    } catch (_) {
      return null;
    }
  }
}
