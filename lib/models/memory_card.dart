import 'character_info.dart';

class MemoryCard {
  MemoryCard({
    required this.pairId,
    required this.character,
    this.isFaceUp = false,
    this.isMatched = false,
  });

  final int pairId;
  final CharacterInfo character;
  bool isFaceUp;
  bool isMatched;
}
