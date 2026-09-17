import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cv_builder/core/constants/app_constants.dart';
import 'package:cv_builder/core/localization/app_locale.dart';
import 'package:cv_builder/core/localization/cv_translations.dart';
import 'package:cv_builder/core/localization/translations_ar.dart';
import 'package:cv_builder/core/localization/translations_en.dart';
import 'package:cv_builder/core/localization/translations_fr.dart';
import 'package:cv_builder/features/cv/domain/models/cv_model.dart';
import 'package:cv_builder/features/cv/domain/models/cv_style.dart';
import 'package:cv_builder/features/cv/presentation/providers/settings_provider.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Internationalization & Decoupling Tests', () {
    test('Translation key synchronicity across EN, FR, AR', () {
      final enKeys = translationsEn.keys.toSet();
      final frKeys = translationsFr.keys.toSet();
      final arKeys = translationsAr.keys.toSet();

      expect(enKeys.length, equals(frKeys.length),
          reason: 'Key count difference between English and French');
      expect(enKeys.length, equals(arKeys.length),
          reason: 'Key count difference between English and Arabic');

      final missingInFr = enKeys.difference(frKeys);
      final missingInAr = enKeys.difference(arKeys);

      expect(missingInFr, isEmpty, reason: 'Missing keys in FR: $missingInFr');
      expect(missingInAr, isEmpty, reason: 'Missing keys in AR: $missingInAr');

      // Ensure no empty string values
      for (final key in enKeys) {
        expect(translationsEn[key]!.trim().isNotEmpty, true, reason: 'Empty EN value for $key');
        expect(translationsFr[key]!.trim().isNotEmpty, true, reason: 'Empty FR value for $key');
        expect(translationsAr[key]!.trim().isNotEmpty, true, reason: 'Empty AR value for $key');
      }
    });

    test('All 9 UI x CV language combinations maintain independent directionality and typography', () {
      const uiLangs = [AppLanguage.english, AppLanguage.french, AppLanguage.arabic];
      const cvLangs = ['en', 'fr', 'ar'];

      int combinationCount = 0;

      for (final uiLang in uiLangs) {
        for (final cvLang in cvLangs) {
          combinationCount++;

          // 1. Verify UI properties
          final uiIsRtl = uiLang == AppLanguage.arabic;
          expect(uiLang.isRtl, equals(uiIsRtl));
          expect(
            uiLang.textDirection,
            equals(uiIsRtl ? TextDirection.rtl : TextDirection.ltr),
          );

          // 2. Create CV Model with this language
          final cvFont = cvLang == 'ar' ? 'Cairo' : 'Roboto';
          final cv = CvModel(
            id: 'test-$combinationCount',
            language: cvLang,
            style: CvStyle(
              fontFamily: cvFont,
              templateId: 'professional',
            ),
          );

          // 3. Verify CV properties
          final cvIsRtl = cvLang == 'ar';
          expect(cv.isRtl, equals(cvIsRtl));
          expect(cv.style.fontFamily, equals(cvFont));

          // 4. Decoupling assertion: UI RTL state must NOT affect CV RTL state
          if (uiLang == AppLanguage.arabic && cvLang == 'en') {
            // THE USER'S EXACT SPECIFIED EXAMPLE:
            // Interface language = Arabic (RTL)
            // CV language = English (LTR)
            expect(uiLang.textDirection, equals(TextDirection.rtl));
            expect(cv.isRtl, isFalse);
            expect(cv.style.fontFamily, equals('Roboto'));
            expect(CvTranslations.get(cv.language, 'experience'), equals('Work Experience'));
          }

          if (uiLang == AppLanguage.english && cvLang == 'ar') {
            // Inverted case:
            // Interface language = English (LTR)
            // CV language = Arabic (RTL)
            expect(uiLang.textDirection, equals(TextDirection.ltr));
            expect(cv.isRtl, isTrue);
            expect(cv.style.fontFamily, equals('Cairo'));
            expect(CvTranslations.get(cv.language, 'experience'), equals('الخبرات المهنية'));
          }

          if (uiLang == AppLanguage.french && cvLang == 'ar') {
            // French UI (LTR) + Arabic CV (RTL)
            expect(uiLang.textDirection, equals(TextDirection.ltr));
            expect(cv.isRtl, isTrue);
            expect(cv.style.fontFamily, equals('Cairo'));
            expect(CvTranslations.get(cv.language, 'education'), equals('المؤهلات التعليمية'));
          }
        }
      }

      expect(combinationCount, equals(9), reason: 'All 3x3=9 combinations must be tested');
    });

    test('CvTranslations returns correct section titles and labels across languages', () {
      final sections = [
        'personal_details',
        'summary',
        'education',
        'experience',
        'skills',
        'languages',
        'certifications',
        'projects',
        'publications',
        'awards',
        'volunteering',
        'references',
      ];

      for (final section in sections) {
        final enTitle = CvTranslations.get('en', section);
        final frTitle = CvTranslations.get('fr', section);
        final arTitle = CvTranslations.get('ar', section);

        expect(enTitle.isNotEmpty, true, reason: 'EN title missing for $section');
        expect(frTitle.isNotEmpty, true, reason: 'FR title missing for $section');
        expect(arTitle.isNotEmpty, true, reason: 'AR title missing for $section');

        // Verify distinct translations between Latin and Arabic scripts
        expect(enTitle != arTitle, true);
        expect(frTitle != arTitle, true);
      }
    });

    test('CvDateFormatter formats dates and ranges accurately in all 3 languages', () {
      // 1. Single Date (abbreviated month + year)
      expect(CvDateFormatter.formatCvDate('2023-01', 'en'), equals('Jan 2023'));
      expect(CvDateFormatter.formatCvDate('2023-01', 'fr'), equals('janv. 2023'));
      expect(CvDateFormatter.formatCvDate('2023-01', 'ar'), equals('يناير 2023'));

      expect(CvDateFormatter.formatCvDate('2022-07', 'en'), equals('Jul 2022'));
      expect(CvDateFormatter.formatCvDate('2022-07', 'fr'), equals('juil. 2022'));
      expect(CvDateFormatter.formatCvDate('2022-07', 'ar'), equals('يوليو 2022'));

      // Plain year fallback
      expect(CvDateFormatter.formatCvDate('2021', 'ar'), equals('2021'));
      expect(CvDateFormatter.formatCvDate('2021', 'fr'), equals('2021'));

      // 2. Date Ranges (Non-current)
      final rangeEn = CvDateFormatter.formatDateRange(
        startDate: '2020-01',
        endDate: '2023-05',
        isCurrent: false,
        langCode: 'en',
      );
      expect(rangeEn, equals('Jan 2020 \u2013 May 2023'));

      final rangeFr = CvDateFormatter.formatDateRange(
        startDate: '2020-01',
        endDate: '2023-05',
        isCurrent: false,
        langCode: 'fr',
      );
      expect(rangeFr, equals('janv. 2020 \u2013 mai 2023'));

      final rangeAr = CvDateFormatter.formatDateRange(
        startDate: '2020-01',
        endDate: '2023-05',
        isCurrent: false,
        langCode: 'ar',
      );
      expect(rangeAr, equals('يناير 2020 \u2013 مايو 2023'));

      // 3. Date Ranges (Currently active / Present)
      final currEn = CvDateFormatter.formatDateRange(
        startDate: '2021-03',
        endDate: '',
        isCurrent: true,
        langCode: 'en',
      );
      expect(currEn, equals('Mar 2021 \u2013 Present'));

      final currFr = CvDateFormatter.formatDateRange(
        startDate: '2021-03',
        endDate: '',
        isCurrent: true,
        langCode: 'fr',
      );
      expect(currFr, equals('mars 2021 \u2013 Présent'));

      final currAr = CvDateFormatter.formatDateRange(
        startDate: '2021-03',
        endDate: '',
        isCurrent: true,
        langCode: 'ar',
      );
      expect(currAr, equals('مارس 2021 \u2013 حتى الآن'));
    });

    test('SettingsNotifier persists UI language and default CV language', () async {
      SharedPreferences.setMockInitialValues({
        AppConstants.prefsAppLangKey: 'fr',
        AppConstants.prefsDefaultCvLangKey: 'ar',
      });

      final notifier = SettingsNotifier();
      await Future.delayed(const Duration(milliseconds: 50));

      // Verify loaded values from preferences
      expect(notifier.state.appLanguage, equals(AppLanguage.french));
      expect(notifier.state.defaultCvLanguage, equals('ar'));

      // Change UI language to Arabic and default CV language to English
      await notifier.setLanguage(AppLanguage.arabic);
      expect(notifier.state.appLanguage, equals(AppLanguage.arabic));
      expect(notifier.state.appLanguage.isRtl, isTrue);

      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getString(AppConstants.prefsAppLangKey), equals('ar'));

      await notifier.setDefaultCvLanguage('en');
      expect(notifier.state.defaultCvLanguage, equals('en'));
      expect(prefs.getString(AppConstants.prefsDefaultCvLangKey), equals('en'));
    });
  });
}
