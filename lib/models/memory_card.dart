import '../data/pokemon_catalog.dart';

class MemoryCard {
  MemoryCard({
    required this.pairId,
    required this.pokemon,
    this.isFaceUp = false,
    this.isMatched = false,
  });

  final int pairId;
  final PokemonInfo pokemon;
  bool isFaceUp;
  bool isMatched;
}
