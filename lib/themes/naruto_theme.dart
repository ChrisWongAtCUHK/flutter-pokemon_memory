import 'package:flutter/material.dart';

import '../models/character_info.dart';
import 'memory_theme.dart';

/// Character portraits from MyAnimeList CDN (via Jikan character IDs).
const MemoryTheme kNarutoTheme = MemoryTheme(
  id: 'naruto',
  name: 'Naruto',
  tagline: 'Believe it — find every pair!',
  menuIcon: Icons.whatshot,
  cardBackIcon: Icons.whatshot,
  primaryColor: Color(0xFFFF6F00),
  secondaryColor: Color(0xFF4E342E),
  accentColor: Color(0xFFFFD54F),
  winMessage: 'You became Hokage of memory!',
  catalog: [
    CharacterInfo(
      id: 17,
      name: 'Naruto',
      imageUrl:
          'https://cdn.myanimelist.net/images/characters/2/284121.webp',
    ),
    CharacterInfo(
      id: 13,
      name: 'Sasuke',
      imageUrl:
          'https://cdn.myanimelist.net/images/characters/9/131317.webp',
    ),
    CharacterInfo(
      id: 145,
      name: 'Sakura',
      imageUrl:
          'https://cdn.myanimelist.net/images/characters/9/69275.webp',
    ),
    CharacterInfo(
      id: 85,
      name: 'Kakashi',
      imageUrl:
          'https://cdn.myanimelist.net/images/characters/7/284129.webp',
    ),
    CharacterInfo(
      id: 14,
      name: 'Itachi',
      imageUrl:
          'https://cdn.myanimelist.net/images/characters/9/284122.webp',
    ),
    CharacterInfo(
      id: 1555,
      name: 'Hinata',
      imageUrl:
          'https://cdn.myanimelist.net/images/characters/6/278736.webp',
    ),
    CharacterInfo(
      id: 2007,
      name: 'Shikamaru',
      imageUrl:
          'https://cdn.myanimelist.net/images/characters/3/131315.webp',
    ),
    CharacterInfo(
      id: 306,
      name: 'Rock Lee',
      imageUrl:
          'https://cdn.myanimelist.net/images/characters/13/433353.webp',
    ),
    CharacterInfo(
      id: 1694,
      name: 'Neji',
      imageUrl:
          'https://cdn.myanimelist.net/images/characters/2/105538.webp',
    ),
    CharacterInfo(
      id: 1662,
      name: 'Gaara',
      imageUrl:
          'https://cdn.myanimelist.net/images/characters/10/293375.webp',
    ),
    CharacterInfo(
      id: 2423,
      name: 'Jiraiya',
      imageUrl:
          'https://cdn.myanimelist.net/images/characters/15/68618.webp',
    ),
    CharacterInfo(
      id: 2535,
      name: 'Minato',
      imageUrl:
          'https://cdn.myanimelist.net/images/characters/14/128074.webp',
    ),
    CharacterInfo(
      id: 1902,
      name: 'Deidara',
      imageUrl:
          'https://cdn.myanimelist.net/images/characters/9/131319.webp',
    ),
    CharacterInfo(
      id: 18911,
      name: 'Pain',
      imageUrl:
          'https://cdn.myanimelist.net/images/characters/7/42114.webp',
    ),
    CharacterInfo(
      id: 53901,
      name: 'Madara',
      imageUrl:
          'https://cdn.myanimelist.net/images/characters/12/450359.webp',
    ),
    CharacterInfo(
      id: 2424,
      name: 'Orochimaru',
      imageUrl:
          'https://cdn.myanimelist.net/images/characters/9/284123.webp',
    ),
  ],
);
