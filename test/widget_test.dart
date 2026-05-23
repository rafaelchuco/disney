import 'package:disney/app/app.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  testWidgets('Landing renders Disney title', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: DisneyApp(),
      ),
    );

    await tester.pump();

    expect(find.text('Disney+'), findsWidgets);
    expect(find.text('SUSCRIBIRME AHORA'), findsWidgets);
  });
}
