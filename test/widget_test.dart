import 'package:flutter_test/flutter_test.dart';
import 'package:pokemon_memory/main.dart';
import 'package:pokemon_memory/services/sprite_cache_service.dart';

void main() {
  setUp(() => SpriteCacheService.skipWarmupInTests = true);
  tearDown(() => SpriteCacheService.skipWarmupInTests = false);

  testWidgets('shows title on menu', (tester) async {
    await tester.pumpWidget(const PokemonMemoryApp());
    await tester.pumpAndSettle();
    expect(find.text('Pokémon Memory'), findsOneWidget);
    expect(find.text('Easy'), findsOneWidget);
  });
}
