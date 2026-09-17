import 'package:flutter_test/flutter_test.dart';
import 'package:cv_builder/core/constants/app_constants.dart';
import 'package:cv_builder/features/cv/data/sample_cv_factory.dart';
import 'package:cv_builder/features/cv/domain/models/cv_style.dart';
import 'package:cv_builder/features/cv/domain/models/publication.dart';
import 'package:cv_builder/features/pdf_export/services/pdf_font_manager.dart';
import 'package:cv_builder/features/pdf_export/services/pdf_generator_service.dart';
import 'package:cv_builder/features/pdf_export/templates/academic_template.dart';
import 'package:cv_builder/features/pdf_export/templates/ats_friendly_template.dart';
import 'package:cv_builder/features/pdf_export/templates/classic_template.dart';
import 'package:cv_builder/features/pdf_export/templates/cv_template_registry.dart';
import 'package:cv_builder/features/pdf_export/templates/executive_template.dart';
import 'package:cv_builder/features/pdf_export/templates/minimalist_template.dart';
import 'package:cv_builder/features/pdf_export/templates/modern_template.dart';
import 'package:cv_builder/features/pdf_export/templates/professional_template.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('CV Template Registry Tests', () {
    setUp(() {
      CvTemplateRegistry.initialize();
    });

    test('Registry registers all 4 primary templates', () {
      final primary = CvTemplateRegistry.getPrimaryTemplates();
      expect(primary.length, 4);

      final ids = primary.map((t) => t.id).toSet();
      expect(ids.contains(AppConstants.templateProfessional), true);
      expect(ids.contains(AppConstants.templateModern), true);
      expect(ids.contains(AppConstants.templateAcademic), true);
      expect(ids.contains(AppConstants.templateAts), true);
    });

    test('Registry contains all 7 templates including legacy backward compatibility', () {
      final all = CvTemplateRegistry.getAllTemplates();
      expect(all.length, greaterThanOrEqualTo(7));

      final ids = all.map((t) => t.id).toSet();
      expect(ids.contains(AppConstants.templateClassic), true);
      expect(ids.contains(AppConstants.templateMinimalist), true);
      expect(ids.contains(AppConstants.templateExecutive), true);
    });

    test('createTemplate returns correct template instance for each id', () async {
      final sample = SampleCvFactory.createEnglishSample();
      final fonts = await PdfFontManager.getLatinFont();

      final prof = CvTemplateRegistry.createTemplate(
        AppConstants.templateProfessional,
        cv: sample,
        fonts: fonts,
      );
      expect(prof, isA<ProfessionalTemplate>());

      final mod = CvTemplateRegistry.createTemplate(
        AppConstants.templateModern,
        cv: sample,
        fonts: fonts,
      );
      expect(mod, isA<ModernTemplate>());

      final acad = CvTemplateRegistry.createTemplate(
        AppConstants.templateAcademic,
        cv: sample,
        fonts: fonts,
      );
      expect(acad, isA<AcademicTemplate>());

      final ats = CvTemplateRegistry.createTemplate(
        AppConstants.templateAts,
        cv: sample,
        fonts: fonts,
      );
      expect(ats, isA<AtsFriendlyTemplate>());

      final classic = CvTemplateRegistry.createTemplate(
        AppConstants.templateClassic,
        cv: sample,
        fonts: fonts,
      );
      expect(classic, isA<ClassicTemplate>());

      final min = CvTemplateRegistry.createTemplate(
        AppConstants.templateMinimalist,
        cv: sample,
        fonts: fonts,
      );
      expect(min, isA<MinimalistTemplate>());

      final exec = CvTemplateRegistry.createTemplate(
        AppConstants.templateExecutive,
        cv: sample,
        fonts: fonts,
      );
      expect(exec, isA<ExecutiveTemplate>());

      // Unknown template falls back to ModernTemplate
      final unknown = CvTemplateRegistry.createTemplate(
        'non_existent_template',
        cv: sample,
        fonts: fonts,
      );
      expect(unknown, isA<ModernTemplate>());
    });
  });

  group('CV Template PDF Generation Tests', () {
    // 1x1 transparent PNG data for testing photo rendering
    const dummyPngBase64 =
        'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mNk+M9QDwADhgGAWjR9awAAAABJRU5ErkJggg==';

    test('Professional Template generates valid PDF (English & French & Arabic)', () async {
      // English without photo
      final enCv = SampleCvFactory.createEnglishSample().copyWith(
        style: const CvStyle(templateId: AppConstants.templateProfessional),
      );
      final enBytes = await PdfGeneratorService.generatePdfBytes(enCv);
      expect(enBytes.isNotEmpty, true);
      expect(String.fromCharCodes(enBytes.take(5)), '%PDF-');

      // French with photo
      final frCv = SampleCvFactory.createFrenchSample().copyWith(
        style: const CvStyle(templateId: AppConstants.templateProfessional),
        personalInfo: SampleCvFactory.createFrenchSample().personalInfo.copyWith(
          photoBase64: dummyPngBase64,
          showPhoto: true,
        ),
      );
      final frBytes = await PdfGeneratorService.generatePdfBytes(frCv);
      expect(frBytes.isNotEmpty, true);
      expect(String.fromCharCodes(frBytes.take(5)), '%PDF-');

      // Arabic RTL
      final arCv = SampleCvFactory.createArabicSample().copyWith(
        style: const CvStyle(templateId: AppConstants.templateProfessional),
      );
      final arBytes = await PdfGeneratorService.generatePdfBytes(arCv);
      expect(arBytes.isNotEmpty, true);
      expect(String.fromCharCodes(arBytes.take(5)), '%PDF-');
    });

    test('Modern Template generates valid PDF (English & Arabic RTL)', () async {
      final enCv = SampleCvFactory.createEnglishSample().copyWith(
        style: const CvStyle(templateId: AppConstants.templateModern),
      );
      final enBytes = await PdfGeneratorService.generatePdfBytes(enCv);
      expect(enBytes.isNotEmpty, true);
      expect(String.fromCharCodes(enBytes.take(5)), '%PDF-');

      final arCv = SampleCvFactory.createArabicSample().copyWith(
        style: const CvStyle(templateId: AppConstants.templateModern),
      );
      final arBytes = await PdfGeneratorService.generatePdfBytes(arCv);
      expect(arBytes.isNotEmpty, true);
      expect(String.fromCharCodes(arBytes.take(5)), '%PDF-');
    });

    test('Academic Template generates valid PDF with research & publication fields', () async {
      final academicCv = SampleCvFactory.createEnglishSample().copyWith(
        style: const CvStyle(templateId: AppConstants.templateAcademic),
        publications: [
          Publication(
            id: 'pub1',
            title: 'Neural Architecture Search for Multi-Scale Dense Feature Representation',
            publisher: 'IEEE Transactions on Pattern Analysis and Machine Intelligence (TPAMI)',
            date: '2024',
            authors: 'Tahar B., Smith J., Taylor R.',
            url: 'https://doi.org/10.1109/TPAMI.2024.123456',
          ),
          Publication(
            id: 'pub2',
            title: 'Deep Transfer Learning in Medical Imaging Diagnosis',
            publisher: 'NeurIPS Proceedings',
            date: '2023',
            authors: 'Tahar B., Davis A.',
          ),
        ],
      );

      final bytes = await PdfGeneratorService.generatePdfBytes(academicCv);
      expect(bytes.isNotEmpty, true);
      expect(String.fromCharCodes(bytes.take(5)), '%PDF-');

      // Test Arabic Academic CV
      final arAcademicCv = SampleCvFactory.createArabicSample().copyWith(
        style: const CvStyle(templateId: AppConstants.templateAcademic),
      );
      final arBytes = await PdfGeneratorService.generatePdfBytes(arAcademicCv);
      expect(arBytes.isNotEmpty, true);
      expect(String.fromCharCodes(arBytes.take(5)), '%PDF-');
    });

    test('ATS-Friendly Template generates text-oriented PDF without graphics', () async {
      final atsCv = SampleCvFactory.createEnglishSample().copyWith(
        style: const CvStyle(templateId: AppConstants.templateAts),
      );

      final bytes = await PdfGeneratorService.generatePdfBytes(atsCv);
      expect(bytes.isNotEmpty, true);
      expect(String.fromCharCodes(bytes.take(5)), '%PDF-');

      // Test Arabic ATS CV
      final arAtsCv = SampleCvFactory.createArabicSample().copyWith(
        style: const CvStyle(templateId: AppConstants.templateAts),
      );
      final arBytes = await PdfGeneratorService.generatePdfBytes(arAtsCv);
      expect(arBytes.isNotEmpty, true);
      expect(String.fromCharCodes(arBytes.take(5)), '%PDF-');
    });
  });
}
