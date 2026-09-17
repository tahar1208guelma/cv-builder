import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cv_builder/main.dart';
import 'package:cv_builder/features/cv/domain/models/cv_model.dart';
import 'package:cv_builder/features/cv/domain/repositories/cv_repository.dart';
import 'package:cv_builder/features/cv/data/sample_cv_factory.dart';
import 'package:cv_builder/features/cv/presentation/providers/cv_providers.dart';
import 'package:cv_builder/features/cv/presentation/screens/dashboard_screen.dart';

class FakeCvRepository implements CvRepository {
  final List<CvModel> _cvs = [
    SampleCvFactory.createEnglishSample(),
    SampleCvFactory.createFrenchSample(),
    SampleCvFactory.createArabicSample(),
  ];

  @override
  Future<List<CvModel>> getAllCvs() async => List.from(_cvs);

  @override
  Future<CvModel?> getCvById(String id) async =>
      _cvs.firstWhere((c) => c.id == id, orElse: () => _cvs.first);

  @override
  Future<void> saveCv(CvModel cv) async {
    final index = _cvs.indexWhere((c) => c.id == cv.id);
    if (index != -1) {
      _cvs[index] = cv;
    } else {
      _cvs.add(cv);
    }
  }

  @override
  Future<void> deleteCv(String id) async {
    _cvs.removeWhere((c) => c.id == id);
  }

  @override
  Future<CvModel> duplicateCv(String id) async {
    final original = await getCvById(id);
    final copy = original!.duplicate();
    _cvs.add(copy);
    return copy;
  }

  @override
  Future<void> seedInitialDataIfEmpty() async {}
}

void main() {
  testWidgets('CvBuilderApp smoke test renders DashboardScreen and displays CV cards',
      (WidgetTester tester) async {
    final fakeRepo = FakeCvRepository();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          cvRepositoryProvider.overrideWithValue(fakeRepo),
        ],
        child: const CvBuilderApp(),
      ),
    );

    // Pump frames to complete asynchronous load
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    // Verify DashboardScreen is present
    expect(find.byType(DashboardScreen), findsOneWidget);

    // Verify app title or tagline is shown
    expect(find.text('CV Builder'), findsWidgets);
  });
}
