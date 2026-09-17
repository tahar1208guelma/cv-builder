import 'package:flutter_test/flutter_test.dart';
import 'package:cv_builder/core/constants/app_constants.dart';
import 'package:cv_builder/features/cv/data/sample_cv_factory.dart';

void main() {
  group('SampleCvFactory Tests', () {
    test('English sample has valid structure and content', () {
      final sample = SampleCvFactory.createEnglishSample();

      expect(sample.language, AppConstants.langEn);
      expect(sample.isRtl, false);
      expect(sample.personalInfo.fullName.isNotEmpty, true);
      expect(sample.personalInfo.email.contains('@'), true);
      expect(sample.personalInfo.summary.isNotEmpty, true);
      expect(sample.experiences.length, greaterThanOrEqualTo(2));
      expect(sample.educations.length, greaterThanOrEqualTo(2));
      expect(sample.skills.length, greaterThanOrEqualTo(4));
      expect(sample.languages.length, greaterThanOrEqualTo(2));
      expect(sample.projects.length, greaterThanOrEqualTo(1));
      expect(sample.certifications.length, greaterThanOrEqualTo(1));
    });

    test('French sample has valid structure and content', () {
      final sample = SampleCvFactory.createFrenchSample();

      expect(sample.language, AppConstants.langFr);
      expect(sample.isRtl, false);
      expect(sample.personalInfo.fullName.isNotEmpty, true);
      expect(sample.personalInfo.email.contains('@'), true);
      expect(sample.personalInfo.summary.isNotEmpty, true);
      expect(sample.experiences.length, greaterThanOrEqualTo(2));
      expect(sample.educations.length, greaterThanOrEqualTo(2));
      expect(sample.skills.length, greaterThanOrEqualTo(3));
      expect(sample.languages.length, greaterThanOrEqualTo(2));
    });

    test('Arabic sample has valid structure, content, and RTL', () {
      final sample = SampleCvFactory.createArabicSample();

      expect(sample.language, AppConstants.langAr);
      expect(sample.isRtl, true);
      expect(sample.style.fontFamily, 'Cairo');
      expect(sample.personalInfo.fullName.isNotEmpty, true);
      expect(sample.personalInfo.email.contains('@'), true);
      expect(sample.personalInfo.summary.isNotEmpty, true);
      expect(sample.experiences.length, greaterThanOrEqualTo(2));
      expect(sample.educations.length, greaterThanOrEqualTo(2));
      expect(sample.skills.length, greaterThanOrEqualTo(3));
      expect(sample.languages.length, greaterThanOrEqualTo(2));
    });
  });
}
