import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:completr/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('end-to-end test', () {
    testWidgets('Login', (WidgetTester tester) async {
      app.main();
      await tester.pump(Duration(seconds: 5));
      await tester.pump();
      var textfields = find.byType(TextFormField);
      await tester.enterText(textfields.first, "shakirmustafa58@gmail.com");
      await tester.enterText(textfields.last, "bruh123");
      await tester.pumpAndSettle();
      await tester.tap(find.byType(ElevatedButton).first);
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(EditableText).first, "The Avengers");
      await tester.pump(Duration(seconds: 2));
      await tester.tap(find.byType(ListTile).first);
      await tester.pumpAndSettle();
      await tester.tap(find.byType(InkWell).at(1));
      await tester.pumpAndSettle();
      final NavigatorState navigator = tester.state(find.byType(Navigator));
      navigator.pop();
      await tester.pump();
      await tester.tap(find.byTooltip('Library'));
      await tester.pump(Duration(seconds: 5));
      await tester.pumpAndSettle();
      await tester.tap(find.byType(IconButton).first);
      await tester.pumpAndSettle();
      await tester.tap(find.byTooltip('Profile'));
      await tester.pumpAndSettle();
      await tester.tap(find.byType(ElevatedButton).first);
    });
  });
}
