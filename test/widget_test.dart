import 'package:flutter_test/flutter_test.dart';
import 'package:pokemon_memory/main.dart';
import 'package:pokemon_memory/services/sprite_cache_service.dart';

void main() {
  setUp(() => SpriteCacheService.skipWarmupInTests = true);
  tearDown(() => SpriteCacheService.skipWarmupInTests = false);

  testWidgets('shows title and themes on menu', (tester) async {
    await tester.pumpWidget(const AnimeMemoryApp());
    await tester.pumpAndSettle();
    expect(find.text('Anime Memory'), findsOneWidget);
    expect(find.text('Pokémon'), findsOneWidget);
    expect(find.text('One Piece'), findsOneWidget);
    expect(find.text('Naruto'), findsOneWidget);
    expect(find.text('Easy'), findsOneWidget);
  });
}
