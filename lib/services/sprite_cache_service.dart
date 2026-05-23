import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

import '../models/character_info.dart';
import '../themes/memory_theme.dart';
import '../themes/pokemon_theme.dart';

/// MyAnimeList CDN sometimes rejects requests without a User-Agent.
const Map<String, String> kImageDownloadHeaders = {
  'User-Agent': 'AnimeMemory/1.0 (Flutter; memory game)',
  'Accept': 'image/webp,image/apng,image/*,*/*;q=0.8',
};

class ThemeSpriteCacheManager extends CacheManager {
  ThemeSpriteCacheManager._()
      : super(
          Config(
            'theme_sprite_cache_v3',
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

  static const int _minImageFileBytes = 80;

  static final SpriteCacheService instance = SpriteCacheService();

  @visibleForTesting
  static bool skipWarmupInTests = false;

  MemoryTheme get theme => _theme;

  void setTheme(MemoryTheme theme) {
    _theme = theme;
  }

  String _cacheKey(CharacterInfo character) =>
      '${_theme.id}_${character.id}';

  bool _hasImageMagicBytes(List<int> header) {
    if (header.length < 3) return false;
    // PNG: 89 50 4E 47
    if (header.length >= 4 &&
        header[0] == 0x89 &&
        header[1] == 0x50 &&
        header[2] == 0x4E &&
        header[3] == 0x47) {
      return true;
    }
    // JPEG: FF D8
    if (header[0] == 0xFF && header[1] == 0xD8) return true;
    // WebP: RIFF....WEBP
    if (header.length >= 12 &&
        header[0] == 0x52 &&
        header[1] == 0x49 &&
        header[2] == 0x46 &&
        header[3] == 0x46 &&
        header[8] == 0x57 &&
        header[9] == 0x45 &&
        header[10] == 0x42 &&
        header[11] == 0x50) {
      return true;
    }
    return false;
  }

  Future<bool> _isValidCachedFile(File? file) async {
    if (file == null || !file.existsSync()) return false;
    try {
      if (file.lengthSync() < _minImageFileBytes) return false;
      final raf = await file.open();
      try {
        final header = await raf.read(12);
        return _hasImageMagicBytes(header);
      } finally {
        await raf.close();
      }
    } catch (_) {
      return false;
    }
  }

  Future<bool> isCached(CharacterInfo character) async {
    final info = await _cache.getFileFromCache(_cacheKey(character));
    if (info == null) return false;
    return _isValidCachedFile(info.file);
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

  /// Clears disk cache for the current theme so Retry re-downloads everything.
  Future<void> clearThemeCache() async {
    for (final character in _theme.catalog) {
      await _cache.removeFile(_cacheKey(character));
    }
  }

  Future<void> _downloadCharacter(CharacterInfo character) async {
    Object? lastError;
    for (var attempt = 0; attempt < 3; attempt++) {
      try {
        if (attempt > 0) {
          await Future<void>.delayed(Duration(milliseconds: 500 * attempt));
          await _cache.removeFile(_cacheKey(character));
        }
        await _cache.downloadFile(
          character.imageUrl,
          key: _cacheKey(character),
          authHeaders: kImageDownloadHeaders,
        );
        final info = await _cache.getFileFromCache(_cacheKey(character));
        if (await _isValidCachedFile(info?.file)) return;
        await _cache.removeFile(_cacheKey(character));
        lastError = 'Invalid image bytes';
      } catch (e) {
        lastError = e;
        await _cache.removeFile(_cacheKey(character));
      }
    }
    throw HttpException('Failed to cache ${character.name}: $lastError');
  }

  Stream<CacheWarmProgress> warmCache({bool forceRefresh = false}) async* {
    if (skipWarmupInTests) {
      yield CacheWarmProgress(
        completed: _theme.catalog.length,
        total: _theme.catalog.length,
        failed: 0,
      );
      return;
    }

    if (forceRefresh) {
      await clearThemeCache();
    }

    var completed = 0;
    var failed = 0;
    final total = _theme.catalog.length;

    for (final character in _theme.catalog) {
      try {
        if (!forceRefresh && await isCached(character)) {
          completed++;
        } else {
          await _downloadCharacter(character);
          completed++;
        }
      } catch (_) {
        failed++;
        completed++;
        await _cache.removeFile(_cacheKey(character));
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
      if (await _isValidCachedFile(cached?.file)) {
        return cached!.file;
      }

      final file = await _cache.getSingleFile(
        character.imageUrl,
        key: _cacheKey(character),
        headers: kImageDownloadHeaders,
      );
      if (await _isValidCachedFile(file)) return file;
      await _cache.removeFile(_cacheKey(character));
      return null;
    } catch (_) {
      return null;
    }
  }
}
