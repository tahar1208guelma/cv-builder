import '../models/subscription_status.dart';
import '../models/subscription_tier.dart';

enum PurchaseResultStatus {
  success,
  cancelled,
  pending,
  error;

  bool get isSuccess => this == PurchaseResultStatus.success;
}

class PurchaseResult {
  final PurchaseResultStatus status;
  final SubscriptionStatus? updatedStatus;
  final String? errorMessage;

  const PurchaseResult({
    required this.status,
    this.updatedStatus,
    this.errorMessage,
  });

  bool get isSuccess => status.isSuccess;

  factory PurchaseResult.success(SubscriptionStatus status) {
    return PurchaseResult(
      status: PurchaseResultStatus.success,
      updatedStatus: status,
    );
  }

  factory PurchaseResult.cancelled() {
    return const PurchaseResult(status: PurchaseResultStatus.cancelled);
  }

  factory PurchaseResult.error(String message) {
    return PurchaseResult(
      status: PurchaseResultStatus.error,
      errorMessage: message,
    );
  }
}

abstract class PaymentService {
  Future<PurchaseResult> purchaseMonthlyPro();
  Future<PurchaseResult> purchaseYearlyPro();
  Future<PurchaseResult> purchaseMonthlyPremium();
  Future<PurchaseResult> purchaseYearlyPremium();
  Future<PurchaseResult> purchaseLifetimePro();
  Future<PurchaseResult> purchasePlan(SubscriptionTier tier, {bool isYearly = false});
  Future<PurchaseResult> restorePurchases();
}
