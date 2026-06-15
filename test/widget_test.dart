import 'package:flutter_test/flutter_test.dart';
import 'package:phone_flutter_ide/main.dart';

void main() {
  testWidgets('shows app title', (tester) async {
    await tester.pumpWidget(const PhoneFlutterIdeApp());
    expect(find.text('手机 Flutter IDE'), findsOneWidget);
  });
}
