import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:cv_builder/core/constants/app_constants.dart';
import 'package:cv_builder/features/cv/data/datasources/cv_local_data_source.dart';
import 'package:cv_builder/features/cv/data/repositories/cv_repository_impl.dart';
import 'package:cv_builder/features/cv/data/sample_cv_factory.dart';
import 'package:cv_builder/features/cv/domain/models/cv_model.dart';
import 'package:cv_builder/features/cv/domain/models/personal_info.dart';

void main() {
  late Directory tempDir;
  late CvLocalDataSource dataSource;
  late CvRepositoryImpl repository;

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp('cv_builder_test_');
    dataSource = CvLocalDataSource(documentsDirectory: tempDir);
    repository = CvRepositoryImpl(dataSource);
  });

  tearDown(() async {
    if (await tempDir.exists()) {
      await tempDir.delete(recursive: true);
    }
  });

  group('CV Local Storage & Repository Tests', () {
    test('saveCv saves a CV file and getCvById retrieves it intact', () async {
      final sample = SampleCvFactory.createEnglishSample();
      await repository.saveCv(sample);

      final retrieved = await repository.getCvById(sample.id);
      expect(retrieved, isNotNull);
      expect(retrieved!.id, equals(sample.id));
      expect(retrieved.title, equals(sample.title));
      expect(retrieved.personalInfo.fullName, equals(sample.personalInfo.fullName));
      expect(retrieved.educations.length, equals(sample.educations.length));
      expect(retrieved.experiences.length, equals(sample.experiences.length));
    });

    test('getAllCvs returns all saved CVs sorted by updatedAt descending', () async {
      final cv1 = CvModel(
        id: 'cv-1',
        title: 'CV 1',
        language: AppConstants.langEn,
        personalInfo: const PersonalInfo(firstName: 'First'),
        createdAt: DateTime(2025, 1, 1),
        updatedAt: DateTime(2025, 1, 1),
      );
      final cv2 = CvModel(
        id: 'cv-2',
        title: 'CV 2',
        language: AppConstants.langFr,
        personalInfo: const PersonalInfo(firstName: 'Second'),
        createdAt: DateTime(2025, 2, 1),
        updatedAt: DateTime(2025, 2, 1),
      );

      await repository.saveCv(cv1);
      await repository.saveCv(cv2);

      final allCvs = await repository.getAllCvs();
      expect(allCvs.length, equals(2));
      expect(allCvs.first.id, equals('cv-2'));
      expect(allCvs.last.id, equals('cv-1'));
    });

    test('deleteCv removes the CV file from local storage', () async {
      final sample = SampleCvFactory.createFrenchSample();
      await repository.saveCv(sample);

      var retrieved = await repository.getCvById(sample.id);
      expect(retrieved, isNotNull);

      await repository.deleteCv(sample.id);
      retrieved = await repository.getCvById(sample.id);
      expect(retrieved, isNull);

      final allCvs = await repository.getAllCvs();
      expect(allCvs.isEmpty, isTrue);
    });

    test('duplicateCv creates a deep copy with new ID and "(Copy)" in title', () async {
      final sample = SampleCvFactory.createArabicSample();
      await repository.saveCv(sample);

      final duplicate = await repository.duplicateCv(sample.id);
      expect(duplicate.id, isNot(equals(sample.id)));
      expect(duplicate.title, contains(sample.title));
      expect(duplicate.isRtl, isTrue);
      expect(duplicate.personalInfo.fullName, equals(sample.personalInfo.fullName));

      final allCvs = await repository.getAllCvs();
      expect(allCvs.length, equals(2));
    });

    test('seedInitialDataIfEmpty populates English, French, and Arabic samples', () async {
      final initial = await repository.getAllCvs();
      expect(initial.isEmpty, isTrue);

      await repository.seedInitialDataIfEmpty();

      final seeded = await repository.getAllCvs();
      expect(seeded.length, equals(3));

      final languages = seeded.map((c) => c.language).toSet();
      expect(languages.contains(AppConstants.langEn), isTrue);
      expect(languages.contains(AppConstants.langFr), isTrue);
      expect(languages.contains(AppConstants.langAr), isTrue);

      await repository.seedInitialDataIfEmpty();
      final afterSecondCall = await repository.getAllCvs();
      expect(afterSecondCall.length, equals(3));
    });

    test('Corrupt JSON files are skipped gracefully without crashing getAllCvs', () async {
      final sample = SampleCvFactory.createEnglishSample();
      await repository.saveCv(sample);

      final corruptFile = File('${tempDir.path}${Platform.pathSeparator}corrupt.json');
      await corruptFile.writeAsString('{ invalid_json: true, ...');

      final cvs = await repository.getAllCvs();
      expect(cvs.length, equals(1));
      expect(cvs.first.id, equals(sample.id));
    });
  });
}
