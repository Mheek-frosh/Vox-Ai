import 'package:flutter_test/flutter_test.dart';
import 'package:vox_ai/main.dart';

void main() {
  testWidgets('Splash screen shows smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const VoxAiApp());

    // Verify that our app name is present.
    expect(find.text('Vox AI'), findsOneWidget);
  });
}
