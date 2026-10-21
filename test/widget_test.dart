import 'package:flutter_test/flutter_test.dart';
import 'package:political_advisory/src/app.dart';

void main() {
  testWidgets('dashboard starts and shows overview metrics', (tester) async {
    await tester.pumpWidget(const PoliticalAdvisoryApp());

    expect(find.text('Political Advisory'), findsOneWidget);
    expect(find.text('Good to see you'), findsOneWidget);
    expect(find.text('Active campaigns'), findsOneWidget);
    expect(find.text('Booths mapped'), findsOneWidget);
  });

  testWidgets('navigation opens campaigns placeholder', (tester) async {
    await tester.pumpWidget(const PoliticalAdvisoryApp());

    await tester.tap(find.text('Campaigns').first);
    await tester.pumpAndSettle();

    expect(find.text('This section is scaffolded in the navigation.'), findsOneWidget);
  });
}
