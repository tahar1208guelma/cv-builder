import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/constants/app_constants.dart';
import 'core/localization/app_locale.dart';
import 'core/localization/app_localizations.dart';
import 'core/theme/app_theme.dart';
import 'features/cv/presentation/providers/settings_provider.dart';
import 'features/cv/presentation/screens/dashboard_screen.dart';
import 'features/pdf_export/services/pdf_font_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Preload offline fonts in background
  try {
    await PdfFontManager.preloadFonts();
  } catch (_) {
    // Fonts will load on demand if assets are still initializing
  }

  runApp(
    const ProviderScope(
      child: CvBuilderApp(),
    ),
  );
}

class CvBuilderApp extends ConsumerWidget {
  const CvBuilderApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);

    return MaterialApp(
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: settings.themeMode,
      locale: settings.appLanguage.locale,
      supportedLocales: AppLanguage.values.map((l) => l.locale).toList(),
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      builder: (context, child) {
        return Directionality(
          textDirection: settings.appLanguage.textDirection,
          child: child ?? const SizedBox.shrink(),
        );
      },
      home: const DashboardScreen(),
    );
  }
}
