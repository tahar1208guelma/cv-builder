import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:cv_builder/core/localization/app_localizations.dart';
import 'package:cv_builder/features/subscription/presentation/screens/pricing_screen.dart';
import 'package:cv_builder/features/subscription/presentation/widgets/plan_card.dart';

Widget createTestWidget({Widget? child}) {
  return ProviderScope(
    child: MaterialApp(
      supportedLocales: const [
        Locale('en', ''),
        Locale('fr', ''),
        Locale('ar', ''),
      ],
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      locale: const Locale('en', ''),
      home: child ?? const PricingScreen(),
    ),
  );
}

void main() {
  testWidgets('PricingScreen renders all plans and billing toggles', (tester) async {
    // Set a wide screen size for desktop layout
    tester.view.physicalSize = const Size(1280, 1000);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() => tester.view.resetPhysicalSize());

    await tester.pumpWidget(createTestWidget());
    await tester.pumpAndSettle();

    // Verify header title
    expect(find.text('Invest in Your Career Success'), findsOneWidget);

    // Verify billing period toggles
    expect(find.text('Monthly'), findsWidgets);
    expect(find.text('Yearly'), findsWidgets);

    // Verify all 4 plan cards are rendered
    expect(find.byType(PlanCard), findsNWidgets(4));

    // Tap Yearly toggle and verify re-render
    final yearlyToggle = find.text('Yearly').first;
    await tester.tap(yearlyToggle);
    await tester.pumpAndSettle();

    // Verify plan cards are still rendered
    expect(find.byType(PlanCard), findsNWidgets(4));
  });
}
