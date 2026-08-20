import 'package:flutter_test/flutter_test.dart';
import 'package:sanayi_mobil_app/core/constants/app_strings.dart';
import 'package:sanayi_mobil_app/core/di/service_locator.dart';
import 'package:sanayi_mobil_app/main.dart';

void main() {
  testWidgets('Sanayi App initial load and bottom navigation smoke test', (WidgetTester tester) async {
    await setupServiceLocator();
    await tester.pumpWidget(const SanayiApp());
    await tester.pump(const Duration(milliseconds: 500));
    await tester.pumpAndSettle();

    // Verify key bottom navigation items exist
    expect(find.text(AppStrings.navHome), findsWidgets);
    expect(find.text(AppStrings.navGarage), findsWidgets);
    expect(find.text(AppStrings.navCampaign), findsWidgets);
    expect(find.text(AppStrings.navSupport), findsWidgets);
  });
}
