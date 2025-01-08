// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';
import 'package:perpustakaan_app/providers/auth_provider.dart';
import 'package:perpustakaan_app/main.dart';

void main() {
  testWidgets('App initialization test', (WidgetTester tester) async {
    // Initialize AuthProvider
    final authProvider = AuthProvider();
    await authProvider.initializeApp();

    // Build our app and trigger a frame
    await tester.pumpWidget(MyApp(authProvider: authProvider));

    // Verify that the login screen is shown initially
    expect(find.text('Login'), findsOneWidget);
  });
}
