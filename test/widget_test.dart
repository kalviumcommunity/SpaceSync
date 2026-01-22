// This is a basic Flutter widget test.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:spacesync/main.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    // Since Firebase.initializeApp() isn't mocked here, it might fail or we need to setup mocks properly.
    // For now, testing that the App widget builds is enough for a smoke test.
    await tester.pumpWidget(const SpaceSyncApp());

    // Verify critical UI elements are present (e.g., App Title)
    // Note: Since main() logic isn't run, we might need to rely on what gets rendered initially.
    // The initial render is a StreamBuilder waiting for a connection or snapshot.
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });
}
