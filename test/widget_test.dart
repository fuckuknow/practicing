import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_application_4/main.dart';

void main() {
  testWidgets('shows scrollable blank home tiles', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    final scaffold = tester.widget<Scaffold>(find.byType(Scaffold));
    expect(scaffold.backgroundColor, Colors.white);
    expect(find.byType(ListView), findsOneWidget);
    expect(find.byType(Container), findsWidgets);
    expect(find.byType(Text), findsNothing);
  });
}
