// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';

import 'package:weather_check/main.dart';

void main() {
  testWidgets('Weather Check app smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const WeatherCheckApp());

    // Verify that the app title is displayed.
    expect(find.text('Weather Check'), findsOneWidget);

    // Verify that the subtitle is displayed.
    expect(find.text('Cek cuaca sebelum berangkat sekolah'), findsOneWidget);

    // Verify that the city dropdown is displayed.
    expect(find.text('Pilih Kota'), findsOneWidget);

    // Verify that Jakarta is the default city in dropdown.
    expect(find.text('Jakarta'), findsOneWidget);
  });
}
