import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:composition_md/main.dart';

void main() {
  testWidgets('shows the app bar and the drama list', (tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('Drama Vault'), findsOneWidget);
    expect(find.text('Queen of Tears'), findsOneWidget);
  });

  testWidgets('shows empty state with icon, message and action',
          (tester) async {
        await tester.pumpWidget(const MyApp());

        await tester.enterText(find.byType(TextField), 'zzzz');
        await tester.pump();

        expect(find.byIcon(Icons.movie_filter_outlined), findsOneWidget);
        expect(find.text('No drama found'), findsOneWidget);
        expect(find.text('Reset filters'), findsOneWidget);

        await tester.ensureVisible(find.text('Reset filters'));
        await tester.pumpAndSettle();
        await tester.tap(find.text('Reset filters'));
        await tester.pumpAndSettle();
        await tester.pump();

        expect(find.text('Queen of Tears'), findsOneWidget);
      });

  testWidgets('no overflow on a 320 dp wide phone', (tester) async {
    tester.view.physicalSize = const Size(320, 568);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const MyApp());

    // Overflow di Flutter dilaporkan sebagai exception saat tes.
    expect(tester.takeException(), isNull);
  });
}