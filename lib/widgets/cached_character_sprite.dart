import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../models/character_info.dart';
import '../services/sprite_cache_service.dart';
import '../themes/memory_theme.dart';

class CachedCharacterSprite extends StatelessWidget {
  const CachedCharacterSprite({
    super.key,
    required this.character,
    required this.theme,
  });

  final CharacterInfo character;
  final MemoryTheme theme;

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: character.imageUrl,
      cacheKey: '${theme.id}_${character.id}',
      cacheManager: ThemeSpriteCacheManager.instance,
      fit: BoxFit.contain,
      memCacheWidth: 180,
      placeholder: (context, url) => const Center(
        child: SizedBox(
          width: 24,
          height: 24,
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
      ),
      errorWidget: (context, url, error) => const Icon(
        Icons.image_not_supported,
        size: 40,
        color: Colors.grey,
      ),
    );
  }
}
