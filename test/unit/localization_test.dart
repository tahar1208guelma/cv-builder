import 'package:flutter_test/flutter_test.dart';
import 'package:cv_builder/core/localization/app_locale.dart';
import 'package:cv_builder/core/localization/cv_translations.dart';
import 'package:cv_builder/core/localization/translations_ar.dart';
import 'package:cv_builder/core/localization/translations_en.dart';
import 'package:cv_builder/core/localization/translations_fr.dart';

void main() {
  group('Localization Tests', () {
    test('English, French, and Arabic translation maps have consistent keys', () {
      final enKeys = translationsEn.keys.toSet();
      final frKeys = translationsFr.keys.toSet();
      final arKeys = translationsAr.keys.toSet();

      // Check key completeness
      expect(enKeys.isNotEmpty, true);
      expect(frKeys.isNotEmpty, true);
      expect(arKeys.isNotEmpty, true);

      final missingInFr = enKeys.difference(frKeys);
      final missingInAr = enKeys.difference(arKeys);

      expect(missingInFr, isEmpty, reason: 'Missing keys in French translations');
      expect(missingInAr, isEmpty, reason: 'Missing keys in Arabic translations');
    });

    test('AppLanguage enum properties', () {
      expect(AppLanguage.english.code, 'en');
      expect(AppLanguage.english.isRtl, false);

      expect(AppLanguage.french.code, 'fr');
      expect(AppLanguage.french.isRtl, false);

      expect(AppLanguage.arabic.code, 'ar');
      expect(AppLanguage.arabic.isRtl, true);
    });

    test('AppLanguage.fromCode fallback', () {
      expect(AppLanguage.fromCode('en'), AppLanguage.english);
      expect(AppLanguage.fromCode('fr'), AppLanguage.french);
      expect(AppLanguage.fromCode('ar'), AppLanguage.arabic);
      expect(AppLanguage.fromCode('unknown'), AppLanguage.english);
    });

    test('CvTranslations returns correct localized section titles', () {
      expect(CvTranslations.get('en', 'experience'), 'Work Experience');
      expect(CvTranslations.get('fr', 'experience'), 'Expérience Professionnelle');
      expect(CvTranslations.get('ar', 'experience'), 'الخبرات المهنية');

      expect(CvTranslations.get('en', 'education'), 'Education');
      expect(CvTranslations.get('fr', 'education'), 'Formation & Diplômes');
      expect(CvTranslations.get('ar', 'education'), 'المؤهلات التعليمية');
    });
  });
}
