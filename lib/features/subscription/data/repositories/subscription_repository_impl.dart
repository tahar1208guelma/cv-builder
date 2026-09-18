import 'package:flutter/foundation.dart';
import '../../domain/models/subscription_status.dart';
import '../../domain/models/subscription_tier.dart';
import '../../domain/models/usage_metrics.dart';
import '../../domain/repositories/subscription_repository.dart';
import '../datasources/subscription_local_data_source.dart';

class SubscriptionRepositoryImpl implements SubscriptionRepository {
  final SubscriptionLocalDataSource _dataSource;

  SubscriptionRepositoryImpl(this._dataSource);

  @override
  Future<SubscriptionStatus> getSubscriptionStatus() async {
    if (kDebugMode) {
      final devTier = await _dataSource.getDevelopmentTier();
      if (devTier != null) {
        return SubscriptionStatus.development(devTier);
      }
    }
    return _dataSource.getSubscriptionStatus();
  }

  @override
  Future<void> saveSubscriptionStatus(SubscriptionStatus status) async {
    await _dataSource.saveSubscriptionStatus(status);
  }

  @override
  Future<void> setDevelopmentTier(SubscriptionTier tier) async {
    if (kDebugMode) {
      await _dataSource.setDevelopmentTier(tier);
    }
  }

  @override
  Future<UsageMetrics> getUsageMetrics() async {
    final metrics = await _dataSource.getUsageMetrics();
    return _maybeResetUsage(metrics);
  }

  @override
  Future<void> saveUsageMetrics(UsageMetrics metrics) async {
    await _dataSource.saveUsageMetrics(metrics);
  }

  @override
  Future<UsageMetrics> recordAiOperation() async {
    final current = await getUsageMetrics();
    final updated = current.incrementAi();
    await _dataSource.saveUsageMetrics(updated);
    return updated;
  }

  @override
  Future<UsageMetrics> recordCoverLetter() async {
    final current = await getUsageMetrics();
    final updated = current.incrementCoverLetters();
    await _dataSource.saveUsageMetrics(updated);
    return updated;
  }

  @override
  Future<UsageMetrics> recordAtsAnalysis() async {
    final current = await getUsageMetrics();
    final updated = current.incrementAts();
    await _dataSource.saveUsageMetrics(updated);
    return updated;
  }

  @override
  Future<UsageMetrics> recordJobMatch() async {
    final current = await getUsageMetrics();
    final updated = current.incrementJobMatches();
    await _dataSource.saveUsageMetrics(updated);
    return updated;
  }

  @override
  Future<UsageMetrics> checkAndResetIfNewMonth() async {
    final current = await _dataSource.getUsageMetrics();
    return _maybeResetUsage(current);
  }

  Future<UsageMetrics> _maybeResetUsage(UsageMetrics metrics) async {
    final now = DateTime.now();
    if (metrics.isNewMonth(now)) {
      final reset = metrics.resetForNewPeriod(now);
      await _dataSource.saveUsageMetrics(reset);
      return reset;
    }
    return metrics;
  }
}
