import 'package:flutter/material.dart';

import '../models/character_info.dart';
import 'memory_theme.dart';

/// Character portraits from MyAnimeList CDN (via Jikan character IDs).
const MemoryTheme kOnePieceTheme = MemoryTheme(
  id: 'one_piece',
  name: 'One Piece',
  tagline: 'Find your nakama pairs!',
  menuIcon: Icons.sailing,
  cardBackIcon: Icons.sailing,
  primaryColor: Color(0xFFD84315),
  secondaryColor: Color(0xFF1A237E),
  accentColor: Color(0xFFFFAB40),
  winMessage: 'The treasure is yours!',
  catalog: [
    CharacterInfo(
      id: 40,
      name: 'Luffy',
      imageUrl:
          'https://cdn.myanimelist.net/images/characters/9/310307.webp',
    ),
    CharacterInfo(
      id: 62,
      name: 'Zoro',
      imageUrl:
          'https://cdn.myanimelist.net/images/characters/3/100534.webp',
    ),
    CharacterInfo(
      id: 723,
      name: 'Nami',
      imageUrl:
          'https://cdn.myanimelist.net/images/characters/6/59914.webp',
    ),
    CharacterInfo(
      id: 305,
      name: 'Sanji',
      imageUrl:
          'https://cdn.myanimelist.net/images/characters/5/136769.webp',
    ),
    CharacterInfo(
      id: 724,
      name: 'Usopp',
      imageUrl:
          'https://cdn.myanimelist.net/images/characters/16/188076.webp',
    ),
    CharacterInfo(
      id: 309,
      name: 'Chopper',
      imageUrl:
          'https://cdn.myanimelist.net/images/characters/3/100536.webp',
    ),
    CharacterInfo(
      id: 61,
      name: 'Robin',
      imageUrl:
          'https://cdn.myanimelist.net/images/characters/16/363700.webp',
    ),
    CharacterInfo(
      id: 64,
      name: 'Franky',
      imageUrl:
          'https://cdn.myanimelist.net/images/characters/13/210053.webp',
    ),
    CharacterInfo(
      id: 5627,
      name: 'Brook',
      imageUrl:
          'https://cdn.myanimelist.net/images/characters/10/161005.webp',
    ),
    CharacterInfo(
      id: 18938,
      name: 'Jinbe',
      imageUrl:
          'https://cdn.myanimelist.net/images/characters/15/307148.webp',
    ),
    CharacterInfo(
      id: 853,
      name: 'Ace',
      imageUrl:
          'https://cdn.myanimelist.net/images/characters/13/110227.webp',
    ),
    CharacterInfo(
      id: 737,
      name: 'Shanks',
      imageUrl:
          'https://cdn.myanimelist.net/images/characters/3/51226.webp',
    ),
    CharacterInfo(
      id: 4087,
      name: 'Law',
      imageUrl:
          'https://cdn.myanimelist.net/images/characters/16/313771.webp',
    ),
    CharacterInfo(
      id: 1742,
      name: 'Whitebeard',
      imageUrl:
          'https://cdn.myanimelist.net/images/characters/9/316615.webp',
    ),
    CharacterInfo(
      id: 43672,
      name: 'Hancock',
      imageUrl:
          'https://cdn.myanimelist.net/images/characters/9/310308.webp',
    ),
    CharacterInfo(
      id: 45679,
      name: 'Sabo',
      imageUrl:
          'https://cdn.myanimelist.net/images/characters/9/310309.webp',
    ),
  ],
);
