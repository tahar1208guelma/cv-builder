import 'package:flutter_test/flutter_test.dart';
import 'package:cv_builder/features/subscription/domain/models/usage_metrics.dart';

void main() {
  group('UsageMetrics Tests', () {
    test('initial values are zero and periodStartDate is set', () {
      final metrics = UsageMetrics.initial();
      expect(metrics.aiOperationsUsed, 0);
      expect(metrics.coverLettersCreated, 0);
      expect(metrics.atsAnalysesRun, 0);
      expect(metrics.jobMatchesRun, 0);
      expect(metrics.periodStartDate.day, 1);
    });

    test('increments track usage correctly', () {
      var metrics = UsageMetrics.initial();
      metrics = metrics.incrementAi();
      metrics = metrics.incrementAi();
      metrics = metrics.incrementCoverLetters();
      metrics = metrics.incrementAts();
      metrics = metrics.incrementJobMatches();

      expect(metrics.aiOperationsUsed, 2);
      expect(metrics.coverLettersCreated, 1);
      expect(metrics.atsAnalysesRun, 1);
      expect(metrics.jobMatchesRun, 1);
    });

    test('isNewMonth correctly detects new calendar month', () {
      final lastMonth = DateTime(2025, 1, 1);
      final metrics = UsageMetrics(
        aiOperationsUsed: 10,
        coverLettersCreated: 2,
        atsAnalysesRun: 3,
        jobMatchesRun: 1,
        periodStartDate: lastMonth,
      );

      // Same month
      expect(metrics.isNewMonth(DateTime(2025, 1, 15)), isFalse);
      // Next month
      expect(metrics.isNewMonth(DateTime(2025, 2, 1)), isTrue);
      // Next year
      expect(metrics.isNewMonth(DateTime(2026, 1, 1)), isTrue);
    });

    test('resetForNewPeriod resets counters and sets new date', () {
      final oldMetrics = UsageMetrics(
        aiOperationsUsed: 25,
        coverLettersCreated: 4,
        atsAnalysesRun: 6,
        jobMatchesRun: 3,
        periodStartDate: DateTime(2025, 1, 1),
      );

      final nextMonth = DateTime(2025, 2, 1);
      final resetMetrics = oldMetrics.resetForNewPeriod(nextMonth);

      expect(resetMetrics.aiOperationsUsed, 0);
      expect(resetMetrics.coverLettersCreated, 0);
      expect(resetMetrics.atsAnalysesRun, 0);
      expect(resetMetrics.jobMatchesRun, 0);
      expect(resetMetrics.periodStartDate.year, 2025);
      expect(resetMetrics.periodStartDate.month, 2);
      expect(resetMetrics.periodStartDate.day, 1);
    });

    test('json serialization roundtrip', () {
      final metrics = UsageMetrics(
        aiOperationsUsed: 7,
        coverLettersCreated: 3,
        atsAnalysesRun: 2,
        jobMatchesRun: 1,
        periodStartDate: DateTime(2025, 3, 1),
      );

      final json = metrics.toJson();
      final recovered = UsageMetrics.fromJson(json);

      expect(recovered.aiOperationsUsed, 7);
      expect(recovered.coverLettersCreated, 3);
      expect(recovered.atsAnalysesRun, 2);
      expect(recovered.jobMatchesRun, 1);
      expect(recovered.periodStartDate.year, 2025);
      expect(recovered.periodStartDate.month, 3);
    });
  });
}
