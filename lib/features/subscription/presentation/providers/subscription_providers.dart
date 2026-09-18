import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/datasources/subscription_local_data_source.dart';
import '../../data/repositories/subscription_repository_impl.dart';
import '../../data/services/mock_ai_service.dart';
import '../../data/services/mock_payment_service.dart';
import '../../domain/models/subscription_status.dart';
import '../../domain/models/subscription_tier.dart';
import '../../domain/models/usage_metrics.dart';
import '../../domain/repositories/subscription_repository.dart';
import '../../domain/services/ai_service.dart';
import '../../domain/services/entitlement_service.dart';
import '../../domain/services/payment_service.dart';

final subscriptionLocalDataSourceProvider = Provider<SubscriptionLocalDataSource>((ref) {
  return SubscriptionLocalDataSource();
});

final subscriptionRepositoryProvider = Provider<SubscriptionRepository>((ref) {
  final dataSource = ref.watch(subscriptionLocalDataSourceProvider);
  return SubscriptionRepositoryImpl(dataSource);
});

final entitlementServiceProvider = Provider<EntitlementService>((ref) {
  return const EntitlementService();
});

final aiServiceProvider = Provider<AiService>((ref) {
  return const MockAiService();
});

final paymentServiceProvider = Provider<PaymentService>((ref) {
  final repo = ref.watch(subscriptionRepositoryProvider);
  return MockPaymentService(repo);
});

// StateNotifier for SubscriptionStatus
class SubscriptionStatusNotifier extends StateNotifier<SubscriptionStatus> {
  final SubscriptionRepository _repository;

  SubscriptionStatusNotifier(this._repository)
      : super(SubscriptionStatus.free()) {
    loadStatus();
  }

  Future<void> loadStatus() async {
    final status = await _repository.getSubscriptionStatus();
    state = status;
  }

  Future<void> setTier(SubscriptionTier tier) async {
    await _repository.setDevelopmentTier(tier);
    final status = await _repository.getSubscriptionStatus();
    state = status;
  }

  Future<void> updateStatus(SubscriptionStatus status) async {
    await _repository.saveSubscriptionStatus(status);
    state = status;
  }
}

final subscriptionStatusProvider =
    StateNotifierProvider<SubscriptionStatusNotifier, SubscriptionStatus>((ref) {
  final repo = ref.watch(subscriptionRepositoryProvider);
  return SubscriptionStatusNotifier(repo);
});

// StateNotifier for UsageMetrics
class UsageMetricsNotifier extends StateNotifier<UsageMetrics> {
  final SubscriptionRepository _repository;

  UsageMetricsNotifier(this._repository) : super(UsageMetrics.initial()) {
    loadUsage();
  }

  Future<void> loadUsage() async {
    final metrics = await _repository.getUsageMetrics();
    state = metrics;
  }

  Future<void> recordAi() async {
    final updated = await _repository.recordAiOperation();
    state = updated;
  }

  Future<void> recordCoverLetter() async {
    final updated = await _repository.recordCoverLetter();
    state = updated;
  }

  Future<void> recordAts() async {
    final updated = await _repository.recordAtsAnalysis();
    state = updated;
  }

  Future<void> recordJobMatch() async {
    final updated = await _repository.recordJobMatch();
    state = updated;
  }
}

final usageMetricsProvider =
    StateNotifierProvider<UsageMetricsNotifier, UsageMetrics>((ref) {
  final repo = ref.watch(subscriptionRepositoryProvider);
  return UsageMetricsNotifier(repo);
});
