import '../../domain/models/subscription_status.dart';
import '../../domain/models/subscription_tier.dart';
import '../../domain/repositories/subscription_repository.dart';
import '../../domain/services/payment_service.dart';

class MockPaymentService implements PaymentService {
  final SubscriptionRepository _repository;

  MockPaymentService(this._repository);

  @override
  Future<PurchaseResult> purchaseMonthlyPro() {
    return purchasePlan(SubscriptionTier.pro, isYearly: false);
  }

  @override
  Future<PurchaseResult> purchaseYearlyPro() {
    return purchasePlan(SubscriptionTier.pro, isYearly: true);
  }

  @override
  Future<PurchaseResult> purchaseMonthlyPremium() {
    return purchasePlan(SubscriptionTier.premium, isYearly: false);
  }

  @override
  Future<PurchaseResult> purchaseYearlyPremium() {
    return purchasePlan(SubscriptionTier.premium, isYearly: true);
  }

  @override
  Future<PurchaseResult> purchaseLifetimePro() {
    return purchasePlan(SubscriptionTier.lifetime);
  }

  @override
  Future<PurchaseResult> purchasePlan(SubscriptionTier tier, {bool isYearly = false}) async {
    await Future.delayed(const Duration(milliseconds: 500));

    final now = DateTime.now();
    DateTime? expirationDate;
    bool isLifetime = false;

    if (tier == SubscriptionTier.lifetime) {
      isLifetime = true;
      expirationDate = null;
    } else if (isYearly) {
      expirationDate = DateTime(now.year + 1, now.month, now.day);
    } else {
      expirationDate = DateTime(now.year, now.month + 1, now.day);
    }

    final newStatus = SubscriptionStatus(
      tier: tier,
      expirationDate: expirationDate,
      isAutoRenew: !isLifetime && tier != SubscriptionTier.free,
      purchaseSource: 'mock_payment_sandbox',
      isLifetime: isLifetime,
      isDevelopment: true,
    );

    await _repository.saveSubscriptionStatus(newStatus);
    return PurchaseResult.success(newStatus);
  }

  @override
  Future<PurchaseResult> restorePurchases() async {
    await Future.delayed(const Duration(milliseconds: 400));
    final status = await _repository.getSubscriptionStatus();
    return PurchaseResult.success(status);
  }
}
