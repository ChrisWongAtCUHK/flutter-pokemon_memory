import 'package:flutter/material.dart';

import '../models/character_info.dart';
import 'memory_theme.dart';

const MemoryTheme kPokemonTheme = MemoryTheme(
  id: 'pokemon',
  name: 'Pokémon',
  tagline: 'Gotta match \'em all!',
  menuIcon: Icons.catching_pokemon,
  cardBackIcon: Icons.catching_pokemon,
  primaryColor: Color(0xFFE53935),
  secondaryColor: Color(0xFF1565C0),
  accentColor: Color(0xFFFFD54F),
  winMessage: 'You caught them all!',
  catalog: [
    CharacterInfo(
      id: 1,
      name: 'Bulbasaur',
      imageUrl:
          'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/1.png',
    ),
    CharacterInfo(
      id: 4,
      name: 'Charmander',
      imageUrl:
          'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/4.png',
    ),
    CharacterInfo(
      id: 7,
      name: 'Squirtle',
      imageUrl:
          'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/7.png',
    ),
    CharacterInfo(
      id: 25,
      name: 'Pikachu',
      imageUrl:
          'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/25.png',
    ),
    CharacterInfo(
      id: 39,
      name: 'Jigglypuff',
      imageUrl:
          'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/39.png',
    ),
    CharacterInfo(
      id: 54,
      name: 'Psyduck',
      imageUrl:
          'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/54.png',
    ),
    CharacterInfo(
      id: 63,
      name: 'Abra',
      imageUrl:
          'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/63.png',
    ),
    CharacterInfo(
      id: 92,
      name: 'Gastly',
      imageUrl:
          'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/92.png',
    ),
    CharacterInfo(
      id: 133,
      name: 'Eevee',
      imageUrl:
          'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/133.png',
    ),
    CharacterInfo(
      id: 143,
      name: 'Snorlax',
      imageUrl:
          'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/143.png',
    ),
    CharacterInfo(
      id: 150,
      name: 'Mewtwo',
      imageUrl:
          'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/150.png',
    ),
    CharacterInfo(
      id: 152,
      name: 'Chikorita',
      imageUrl:
          'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/152.png',
    ),
    CharacterInfo(
      id: 155,
      name: 'Cyndaquil',
      imageUrl:
          'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/155.png',
    ),
    CharacterInfo(
      id: 158,
      name: 'Totodile',
      imageUrl:
          'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/158.png',
    ),
    CharacterInfo(
      id: 172,
      name: 'Pichu',
      imageUrl:
          'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/172.png',
    ),
    CharacterInfo(
      id: 196,
      name: 'Espeon',
      imageUrl:
          'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/196.png',
    ),
  ],
);
