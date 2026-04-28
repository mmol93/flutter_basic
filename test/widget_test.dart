import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flutter_basic/main.dart';

void main() {
  testWidgets('Entry page opens todo page and renders list', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const ProviderScope(child: MyApp()));

    expect(find.text('Architecture Playground'), findsOneWidget);
    expect(find.text('Todo Page'), findsOneWidget);

    await tester.tap(find.text('Todo Page'));
    await tester.pumpAndSettle();

    expect(find.text('Riverpod UI Demo'), findsOneWidget);

    expect(find.text('Study Flutter'), findsOneWidget);
    expect(find.text('Grocery Shopping'), findsOneWidget);
  });
}
