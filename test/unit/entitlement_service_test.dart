import 'package:flutter_test/flutter_test.dart';
import 'package:cv_builder/features/subscription/domain/models/subscription_tier.dart';
import 'package:cv_builder/features/subscription/domain/services/entitlement_service.dart';

void main() {
  group('EntitlementService Tests', () {
    const entitlement = EntitlementService();

    group('Free Tier Entitlements', () {
      const tier = SubscriptionTier.free;

      test('CV limits and creation checks', () {
        expect(entitlement.getCvLimit(tier), 2);
        expect(entitlement.canCreateAnotherCv(tier: tier, currentCvCount: 0), isTrue);
        expect(entitlement.canCreateAnotherCv(tier: tier, currentCvCount: 1), isTrue);
        expect(entitlement.canCreateAnotherCv(tier: tier, currentCvCount: 2), isFalse);
        expect(entitlement.canCreateAnotherCv(tier: tier, currentCvCount: 5), isFalse);
      });

      test('AI operations quota', () {
        expect(entitlement.getAiOperationsLimit(tier), 3);
        expect(entitlement.canUseAi(tier: tier, currentUsage: 0), isTrue);
        expect(entitlement.canUseAi(tier: tier, currentUsage: 2), isTrue);
        expect(entitlement.canUseAi(tier: tier, currentUsage: 3), isFalse);
        expect(entitlement.canUseAi(tier: tier, currentUsage: 4), isFalse);
        expect(entitlement.getRemainingAiOperations(tier: tier, currentUsage: 1), 2);
        expect(entitlement.getRemainingAiOperations(tier: tier, currentUsage: 3), 0);
      });

      test('Template access gating', () {
        expect(entitlement.canUseTemplate(userTier: tier, requiredTier: SubscriptionTier.free), isTrue);
        expect(entitlement.canUseTemplate(userTier: tier, requiredTier: SubscriptionTier.pro), isFalse);
        expect(entitlement.canUseTemplate(userTier: tier, requiredTier: SubscriptionTier.premium), isFalse);
      });

      test('Feature access permissions', () {
        expect(entitlement.canExportDocx(tier), isFalse);
        expect(entitlement.canUseCoverLetter(tier), isFalse);
        expect(entitlement.canUseAtsAnalysis(tier), isFalse);
        expect(entitlement.canUseJobMatching(tier), isFalse);
        expect(entitlement.canUseAdvancedAts(tier), isFalse);
        expect(entitlement.canUseInterviewPrep(tier), isFalse);
      });
    });

    group('Pro Tier Entitlements', () {
      const tier = SubscriptionTier.pro;

      test('CV limits and creation checks', () {
        expect(entitlement.getCvLimit(tier), 10);
        expect(entitlement.canCreateAnotherCv(tier: tier, currentCvCount: 5), isTrue);
        expect(entitlement.canCreateAnotherCv(tier: tier, currentCvCount: 9), isTrue);
        expect(entitlement.canCreateAnotherCv(tier: tier, currentCvCount: 10), isFalse);
      });

      test('AI operations quota', () {
        expect(entitlement.getAiOperationsLimit(tier), 30);
        expect(entitlement.canUseAi(tier: tier, currentUsage: 29), isTrue);
        expect(entitlement.canUseAi(tier: tier, currentUsage: 30), isFalse);
        expect(entitlement.getRemainingAiOperations(tier: tier, currentUsage: 10), 20);
      });

      test('Template access gating', () {
        expect(entitlement.canUseTemplate(userTier: tier, requiredTier: SubscriptionTier.free), isTrue);
        expect(entitlement.canUseTemplate(userTier: tier, requiredTier: SubscriptionTier.pro), isTrue);
        expect(entitlement.canUseTemplate(userTier: tier, requiredTier: SubscriptionTier.premium), isFalse);
      });

      test('Feature access permissions', () {
        expect(entitlement.canExportDocx(tier), isTrue);
        expect(entitlement.canUseCoverLetter(tier), isTrue);
        expect(entitlement.canUseAtsAnalysis(tier), isTrue);
        expect(entitlement.canUseJobMatching(tier), isTrue);
        expect(entitlement.canUseShareableLink(tier), isTrue);
        expect(entitlement.canUseQrCode(tier), isTrue);
        // Premium features should be locked for Pro
        expect(entitlement.canUseAdvancedAts(tier), isFalse);
        expect(entitlement.canUseInterviewPrep(tier), isFalse);
        expect(entitlement.canUseMultiLangGeneration(tier), isFalse);
      });
    });

    group('Premium Tier Entitlements', () {
      const tier = SubscriptionTier.premium;

      test('CV limits and creation checks (Unlimited)', () {
        expect(entitlement.getCvLimit(tier), -1);
        expect(entitlement.canCreateAnotherCv(tier: tier, currentCvCount: 0), isTrue);
        expect(entitlement.canCreateAnotherCv(tier: tier, currentCvCount: 100), isTrue);
      });

      test('AI operations quota (Unlimited)', () {
        expect(entitlement.getAiOperationsLimit(tier), -1);
        expect(entitlement.canUseAi(tier: tier, currentUsage: 1000), isTrue);
        expect(entitlement.getRemainingAiOperations(tier: tier, currentUsage: 50), -1);
      });

      test('Template access gating', () {
        expect(entitlement.canUseTemplate(userTier: tier, requiredTier: SubscriptionTier.free), isTrue);
        expect(entitlement.canUseTemplate(userTier: tier, requiredTier: SubscriptionTier.pro), isTrue);
        expect(entitlement.canUseTemplate(userTier: tier, requiredTier: SubscriptionTier.premium), isTrue);
      });

      test('Feature access permissions', () {
        expect(entitlement.canExportDocx(tier), isTrue);
        expect(entitlement.canUseCoverLetter(tier), isTrue);
        expect(entitlement.canUseAtsAnalysis(tier), isTrue);
        expect(entitlement.canUseJobMatching(tier), isTrue);
        expect(entitlement.canUseAdvancedAts(tier), isTrue);
        expect(entitlement.canUseInterviewPrep(tier), isTrue);
        expect(entitlement.canUseMultiLangGeneration(tier), isTrue);
        expect(entitlement.canUseAdvancedPhoto(tier), isTrue);
        expect(entitlement.canUseCvAnalytics(tier), isTrue);
      });
    });

    group('Lifetime Pro Tier Entitlements', () {
      const tier = SubscriptionTier.lifetime;

      test('Inherits Pro features and allows template access', () {
        expect(tier.isLifetime, isTrue);
        expect(tier.isPaid, isTrue);
        expect(tier.isProOrHigher, isTrue);
        expect(entitlement.canExportDocx(tier), isTrue);
        expect(entitlement.canUseAtsAnalysis(tier), isTrue);
        expect(entitlement.canUseTemplate(userTier: tier, requiredTier: SubscriptionTier.free), isTrue);
        expect(entitlement.canUseTemplate(userTier: tier, requiredTier: SubscriptionTier.pro), isTrue);
      });
    });
  });
}
