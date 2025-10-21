// test/widget_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:alquiler_autos_app/main.dart';
import 'package:alquiler_autos_app/data/repositories/memory_store.dart';
import 'package:alquiler_autos_app/data/repositories/reservation_repository.dart';

void main() {
  testWidgets('app smoke test', (WidgetTester tester) async {
    final store = MemoryStore();
    final resRepo = ReservationRepository(store);

    await tester.pumpWidget(MyApp(store: store, resRepo: resRepo));

    // Verifica que cargó el Home
    expect(find.text('Alquiler de autos'), findsOneWidget);
  });
}
