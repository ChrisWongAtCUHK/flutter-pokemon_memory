import 'package:flutter_test/flutter_test.dart';
import 'package:pokemon_memory/main.dart';

void main() {
  testWidgets('shows title on menu', (tester) async {
    await tester.pumpWidget(const PokemonMemoryApp());
    expect(find.text('Pokémon Memory'), findsOneWidget);
    expect(find.text('Easy'), findsOneWidget);
  });
}
