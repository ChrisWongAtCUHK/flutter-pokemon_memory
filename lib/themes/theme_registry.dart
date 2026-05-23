import 'memory_theme.dart';
import 'naruto_theme.dart';
import 'one_piece_theme.dart';
import 'pokemon_theme.dart';

const List<MemoryTheme> kAllThemes = [
  kPokemonTheme,
  kOnePieceTheme,
  kNarutoTheme,
];

MemoryTheme themeById(String id) {
  return kAllThemes.firstWhere(
    (t) => t.id == id,
    orElse: () => kPokemonTheme,
  );
}
