import '../models/usage_metrics.dart';

abstract class UsageTrackingService {
  Future<UsageMetrics> getUsage();
  Future<UsageMetrics> recordAiOperation();
  Future<UsageMetrics> recordCoverLetter();
  Future<UsageMetrics> recordAtsAnalysis();
  Future<UsageMetrics> recordJobMatch();
  Future<UsageMetrics> checkAndResetIfNewMonth();
}
