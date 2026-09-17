import 'package:flutter/material.dart';
import 'app_locale.dart';
import 'translations_ar.dart';
import 'translations_en.dart';
import 'translations_fr.dart';

class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations) ??
        AppLocalizations(const Locale('en'));
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  static final Map<String, Map<String, String>> _localizedValues = {
    'en': translationsEn,
    'fr': translationsFr,
    'ar': translationsAr,
  };

  String translate(String key) {
    final langCode = locale.languageCode;
    final map = _localizedValues[langCode] ?? _localizedValues['en']!;
    return map[key] ?? key;
  }

  AppLanguage get currentLanguage => AppLanguage.fromCode(locale.languageCode);

  bool get isRtl => currentLanguage.isRtl;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => ['en', 'fr', 'ar'].contains(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) async {
    return AppLocalizations(locale);
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

extension AppLocalizationsX on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this);
  String tr(String key) => AppLocalizations.of(this).translate(key);
}
