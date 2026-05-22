import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

typedef LaunchApp = Future<void> Function();

Future<void> registerAndTakeScreenshot({
  required WidgetTester tester,
  required IntegrationTestWidgetsFlutterBinding binding,
  required String name,
  required LaunchApp launchApp,
  Duration settleTimeout = const Duration(seconds: 5),
}) async {
  await launchApp();
  await tester.pumpAndSettle(settleTimeout);
  await binding.takeScreenshot(name);
}
