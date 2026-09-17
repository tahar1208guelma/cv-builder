import '../../domain/models/cv_model.dart';
import '../../domain/repositories/cv_repository.dart';
import '../datasources/cv_local_data_source.dart';
import '../sample_cv_factory.dart';

class CvRepositoryImpl implements CvRepository {
  final CvLocalDataSource _localDataSource;

  CvRepositoryImpl(this._localDataSource);

  @override
  Future<List<CvModel>> getAllCvs() async {
    return _localDataSource.getAllCvs();
  }

  @override
  Future<CvModel?> getCvById(String id) async {
    return _localDataSource.getCvById(id);
  }

  @override
  Future<void> saveCv(CvModel cv) async {
    await _localDataSource.saveCv(cv);
  }

  @override
  Future<void> deleteCv(String id) async {
    await _localDataSource.deleteCv(id);
  }

  @override
  Future<CvModel> duplicateCv(String id) async {
    final original = await getCvById(id);
    if (original == null) {
      throw Exception('CV with ID $id not found');
    }
    final duplicate = original.duplicate();
    await saveCv(duplicate);
    return duplicate;
  }

  @override
  Future<void> seedInitialDataIfEmpty() async {
    final currentCvs = await getAllCvs();
    if (currentCvs.isEmpty) {
      // Seed with initial high-quality samples in English, French, and Arabic
      final sampleEn = SampleCvFactory.createEnglishSample();
      final sampleFr = SampleCvFactory.createFrenchSample();
      final sampleAr = SampleCvFactory.createArabicSample();

      await saveCv(sampleEn);
      await saveCv(sampleFr);
      await saveCv(sampleAr);
    }
  }
}
