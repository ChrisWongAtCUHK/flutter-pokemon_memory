class PokemonInfo {
  const PokemonInfo({required this.id, required this.name});

  final int id;
  final String name;

  String get spriteUrl =>
      'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/$id.png';
}

/// Curated list — sprites download once, then load from on-device cache.
const List<PokemonInfo> kPokemonCatalog = [
  PokemonInfo(id: 1, name: 'Bulbasaur'),
  PokemonInfo(id: 4, name: 'Charmander'),
  PokemonInfo(id: 7, name: 'Squirtle'),
  PokemonInfo(id: 25, name: 'Pikachu'),
  PokemonInfo(id: 39, name: 'Jigglypuff'),
  PokemonInfo(id: 54, name: 'Psyduck'),
  PokemonInfo(id: 63, name: 'Abra'),
  PokemonInfo(id: 92, name: 'Gastly'),
  PokemonInfo(id: 133, name: 'Eevee'),
  PokemonInfo(id: 143, name: 'Snorlax'),
  PokemonInfo(id: 150, name: 'Mewtwo'),
  PokemonInfo(id: 152, name: 'Chikorita'),
  PokemonInfo(id: 155, name: 'Cyndaquil'),
  PokemonInfo(id: 158, name: 'Totodile'),
  PokemonInfo(id: 172, name: 'Pichu'),
  PokemonInfo(id: 196, name: 'Espeon'),
];
