import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../data/pokemon_catalog.dart';
import '../services/sprite_cache_service.dart';

class CachedPokemonSprite extends StatelessWidget {
  const CachedPokemonSprite({
    super.key,
    required this.pokemon,
  });

  final PokemonInfo pokemon;

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: pokemon.spriteUrl,
      cacheKey: 'pokemon_${pokemon.id}',
      cacheManager: PokemonSpriteCacheManager.instance,
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
