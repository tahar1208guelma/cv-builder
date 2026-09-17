import 'package:flutter_test/flutter_test.dart';
import 'package:cv_builder/core/constants/app_constants.dart';
import 'package:cv_builder/core/localization/translations_ar.dart';
import 'package:cv_builder/core/localization/translations_en.dart';
import 'package:cv_builder/core/localization/translations_fr.dart';
import 'package:cv_builder/features/cv/domain/models/cv_model.dart';
import 'package:cv_builder/features/cv/domain/models/education.dart';
import 'package:cv_builder/features/cv/domain/models/experience.dart';
import 'package:cv_builder/features/cv/domain/models/personal_info.dart';
import 'package:cv_builder/features/cv/domain/models/skill.dart';
import 'package:cv_builder/features/pdf_export/services/pdf_generator_service.dart';
import 'package:cv_builder/features/pdf_export/templates/cv_template_registry.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Live CV Preview System Tests', () {
    test('generatePdfWithMeta returns valid bytes and accurate page count', () async {
      final cv = CvModel(
        title: 'Preview Test CV',
        language: AppConstants.langEn,
        personalInfo: const PersonalInfo(
          firstName: 'John',
          lastName: 'Doe',
          jobTitle: 'Software Architect',
          email: 'john.doe@example.com',
          phone: '+1 555 0199',
        ),
        experiences: [
          Experience(
            jobTitle: 'Senior Architect',
            company: 'Tech Innovations Corp',
            startDate: '2020',
            endDate: 'Present',
            isCurrent: true,
          ),
        ],
        educations: [
          Education(
            degree: 'M.Sc. Computer Science',
            institution: 'MIT',
            startDate: '2015',
            endDate: '2017',
          ),
        ],
        skills: [
          Skill(name: 'Flutter', level: 5),
          Skill(name: 'Dart', level: 5),
        ],
      );

      final result = await PdfGeneratorService.generatePdfWithMeta(cv);

      expect(result.bytes.isNotEmpty, isTrue);
      expect(String.fromCharCodes(result.bytes.take(5)), equals('%PDF-'));
      expect(result.pageCount, greaterThanOrEqualTo(1));
    });

    test('Live template switching retains 100% of CV content without data loss', () {
      final initialCv = CvModel(
        id: 'cv-101',
        title: 'Full Data Integrity Test',
        language: AppConstants.langEn,
        personalInfo: const PersonalInfo(
          firstName: 'Sarah',
          lastName: 'Connor',
          jobTitle: 'Lead Engineer',
          email: 'sarah@example.com',
          phone: '+1 555 4321',
          summary: 'Experienced systems engineer specialized in resilient computing.',
          photoBase64: 'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mNk+M9QDwADhgGAWjR9awAAAABJRU5ErkJggg==',
          showPhoto: true,
        ),
        experiences: [
          Experience(
            jobTitle: 'Principal Engineer',
            company: 'Cyberdyne Research',
            startDate: '2021',
            endDate: '2024',
          ),
        ],
        educations: [
          Education(
            degree: 'B.Sc. Engineering',
            institution: 'Caltech',
            startDate: '2016',
            endDate: '2020',
          ),
        ],
        skills: [
          Skill(name: 'System Architecture', level: 5),
        ],
      );

      final primaryTemplates = CvTemplateRegistry.getPrimaryTemplates();
      expect(primaryTemplates.length, equals(4));

      // Switch to each template sequentially and verify zero data loss
      for (final tpl in primaryTemplates) {
        final switchedCv = initialCv.copyWith(
          style: initialCv.style.copyWith(templateId: tpl.id),
        );

        expect(switchedCv.style.templateId, equals(tpl.id));
        expect(switchedCv.personalInfo.fullName, equals('Sarah Connor'));
        expect(switchedCv.personalInfo.email, equals('sarah@example.com'));
        expect(switchedCv.personalInfo.summary, equals('Experienced systems engineer specialized in resilient computing.'));
        expect(switchedCv.personalInfo.photoBase64, isNotNull);
        expect(switchedCv.personalInfo.showPhoto, isTrue);
        expect(switchedCv.experiences.length, equals(1));
        expect(switchedCv.experiences.first.company, equals('Cyberdyne Research'));
        expect(switchedCv.educations.length, equals(1));
        expect(switchedCv.educations.first.institution, equals('Caltech'));
        expect(switchedCv.skills.length, equals(1));
        expect(switchedCv.skills.first.name, equals('System Architecture'));
      }
    });

    test('Photo layout toggle updates showPhoto and hasPhoto without losing photoBase64', () {
      const samplePhoto = 'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mNk+M9QDwADhgGAWjR9awAAAABJRU5ErkJggg==';
      const pWithPhoto = PersonalInfo(
        firstName: 'Alice',
        lastName: 'Wonder',
        photoBase64: samplePhoto,
        showPhoto: true,
      );

      expect(pWithPhoto.hasPhoto, isTrue);
      expect(pWithPhoto.showPhoto, isTrue);

      // Toggle photo OFF
      final pPhotoOff = pWithPhoto.copyWith(showPhoto: false);
      expect(pPhotoOff.showPhoto, isFalse);
      expect(pPhotoOff.hasPhoto, isFalse);
      expect(pPhotoOff.photoBase64, equals(samplePhoto)); // Data preserved!

      // Toggle photo back ON
      final pPhotoOnAgain = pPhotoOff.copyWith(showPhoto: true);
      expect(pPhotoOnAgain.showPhoto, isTrue);
      expect(pPhotoOnAgain.hasPhoto, isTrue);
      expect(pPhotoOnAgain.photoBase64, equals(samplePhoto));
    });

    test('Unified data model shared between preview and PDF generation', () async {
      final cv = CvModel(
        title: 'Unified Architecture Test',
        language: AppConstants.langAr,
        personalInfo: const PersonalInfo(
          firstName: 'طارق',
          lastName: 'المنصور',
          jobTitle: 'مهندس برمجيات أول',
        ),
      );

      // 1. generatePdfBytes for export
      final exportBytes = await PdfGeneratorService.generatePdfBytes(cv);

      // 2. generatePdfWithMeta for live preview
      final previewMeta = await PdfGeneratorService.generatePdfWithMeta(cv);

      // Both must consume the exact same CvModel instance and produce valid matching PDF documents
      expect(previewMeta.bytes.length, equals(exportBytes.length));
      expect(String.fromCharCodes(previewMeta.bytes.take(5)), equals('%PDF-'));
      expect(String.fromCharCodes(exportBytes.take(5)), equals('%PDF-'));
      expect(previewMeta.pageCount, greaterThanOrEqualTo(1));
    });

    test('All preview toolbar translation keys exist and are non-empty in EN, FR, AR', () {
      final previewKeys = [
        'zoom_in',
        'zoom_out',
        'zoom_fit',
        'zoom_reset',
        'page_all',
        'page_single',
        'next_page',
        'prev_page',
        'page_x_of_y',
        'toggle_photo',
        'photo_visible',
        'photo_hidden',
        'switch_template',
        'split_view',
        'hide_preview',
        'show_preview',
        'mobile_tab_edit',
        'mobile_tab_preview',
        'preview_updating',
        'preview_ready',
      ];

      for (final key in previewKeys) {
        expect(translationsEn.containsKey(key), isTrue, reason: 'Missing $key in EN');
        expect(translationsFr.containsKey(key), isTrue, reason: 'Missing $key in FR');
        expect(translationsAr.containsKey(key), isTrue, reason: 'Missing $key in AR');

        expect(translationsEn[key]!.trim().isNotEmpty, isTrue, reason: 'Empty $key in EN');
        expect(translationsFr[key]!.trim().isNotEmpty, isTrue, reason: 'Empty $key in FR');
        expect(translationsAr[key]!.trim().isNotEmpty, isTrue, reason: 'Empty $key in AR');
      }
    });
  });
}
