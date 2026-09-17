import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import '../../../../core/constants/app_constants.dart';
import '../../domain/models/cv_model.dart';

class CvLocalDataSource {
  Directory? _documentsDirectory;

  Future<Directory> _getStorageDirectory() async {
    if (_documentsDirectory != null) return _documentsDirectory!;
    final appDir = await getApplicationDocumentsDirectory();
    final cvDir = Directory('${appDir.path}${Platform.pathSeparator}${AppConstants.cvStorageDir}');
    if (!await cvDir.exists()) {
      await cvDir.create(recursive: true);
    }
    _documentsDirectory = cvDir;
    return cvDir;
  }

  File _getCvFile(Directory dir, String id) {
    return File('${dir.path}${Platform.pathSeparator}$id.json');
  }

  Future<List<CvModel>> getAllCvs() async {
    final dir = await _getStorageDirectory();
    final List<CvModel> cvs = [];

    final entities = await dir.list().toList();
    for (final entity in entities) {
      if (entity is File && entity.path.endsWith('.json') && !entity.path.endsWith('.tmp')) {
        try {
          final content = await entity.readAsString();
          final json = jsonDecode(content) as Map<String, dynamic>;
          cvs.add(CvModel.fromJson(json));
        } catch (e) {
          // Ignore corrupt individual files safely
        }
      }
    }

    // Sort by last updated descending
    cvs.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
    return cvs;
  }

  Future<CvModel?> getCvById(String id) async {
    final dir = await _getStorageDirectory();
    final file = _getCvFile(dir, id);
    if (!await file.exists()) return null;

    try {
      final content = await file.readAsString();
      final json = jsonDecode(content) as Map<String, dynamic>;
      return CvModel.fromJson(json);
    } catch (_) {
      return null;
    }
  }

  Future<void> saveCv(CvModel cv) async {
    final dir = await _getStorageDirectory();
    final file = _getCvFile(dir, cv.id);
    final tempFile = File('${file.path}.tmp');

    final jsonString = jsonEncode(cv.toJson());

    // Atomic write pattern: write to tmp file then rename
    await tempFile.writeAsString(jsonString, flush: true);
    if (await file.exists()) {
      await file.delete();
    }
    await tempFile.rename(file.path);
  }

  Future<void> deleteCv(String id) async {
    final dir = await _getStorageDirectory();
    final file = _getCvFile(dir, id);
    if (await file.exists()) {
      await file.delete();
    }
  }
}
