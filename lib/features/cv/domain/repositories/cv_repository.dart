import '../models/cv_model.dart';

abstract class CvRepository {
  Future<List<CvModel>> getAllCvs();
  Future<CvModel?> getCvById(String id);
  Future<void> saveCv(CvModel cv);
  Future<void> deleteCv(String id);
  Future<CvModel> duplicateCv(String id);
  Future<void> seedInitialDataIfEmpty();
}
