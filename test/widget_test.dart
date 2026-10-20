
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_app/main.dart';

void main() {
  testWidgets('Agami Life app opens', (WidgetTester tester) async {
    await tester.pumpWidget(const AgamiLifeApp());

    expect(find.text('Agami Life'), findsOneWidget);
    expect(find.text('Never Miss What Matters.'), findsOneWidget);
  });
}
