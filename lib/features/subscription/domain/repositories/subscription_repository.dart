import '../models/subscription_status.dart';
import '../models/subscription_tier.dart';
import '../models/usage_metrics.dart';

abstract class SubscriptionRepository {
  Future<SubscriptionStatus> getSubscriptionStatus();
  Future<void> saveSubscriptionStatus(SubscriptionStatus status);
  Future<void> setDevelopmentTier(SubscriptionTier tier);
  Future<UsageMetrics> getUsageMetrics();
  Future<void> saveUsageMetrics(UsageMetrics metrics);
  Future<UsageMetrics> recordAiOperation();
  Future<UsageMetrics> recordCoverLetter();
  Future<UsageMetrics> recordAtsAnalysis();
  Future<UsageMetrics> recordJobMatch();
  Future<UsageMetrics> checkAndResetIfNewMonth();
}
