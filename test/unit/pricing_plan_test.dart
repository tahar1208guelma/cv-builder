import 'package:flutter_test/flutter_test.dart';
import 'package:cv_builder/features/subscription/domain/models/pricing_plan.dart';
import 'package:cv_builder/features/subscription/domain/models/subscription_tier.dart';

void main() {
  group('PricingPlan Tests', () {
    test('all 4 tiers are configured with correct DZD pricing', () {
      expect(PricingPlan.allPlans.length, 4);

      const free = PricingPlan.free;
      expect(free.tier, SubscriptionTier.free);
      expect(free.monthlyPrice.amountDzd, 0);
      expect(free.monthlyPrice.formattedPrice, '0 DZD');
      expect(free.cvLimit, 2);
      expect(free.aiOperationsLimit, 3);

      const pro = PricingPlan.pro;
      expect(pro.tier, SubscriptionTier.pro);
      expect(pro.monthlyPrice.amountDzd, 299);
      expect(pro.yearlyPrice.amountDzd, 2490);
      expect(pro.monthlyPrice.formattedPrice, '299 DZD');
      expect(pro.yearlyPrice.formattedPrice, '2490 DZD');
      expect(pro.isPopular, isTrue);
      expect(pro.cvLimit, 10);
      expect(pro.aiOperationsLimit, 30);

      const premium = PricingPlan.premium;
      expect(premium.tier, SubscriptionTier.premium);
      expect(premium.monthlyPrice.amountDzd, 499);
      expect(premium.yearlyPrice.amountDzd, 3990);
      expect(premium.cvLimit, -1);
      expect(premium.aiOperationsLimit, -1);

      const lifetime = PricingPlan.lifetime;
      expect(lifetime.tier, SubscriptionTier.lifetime);
      expect(lifetime.oneTimePrice?.amountDzd, 7900);
      expect(lifetime.oneTimePrice?.formattedPrice, '7900 DZD');
    });

    test('PricingPlan.forTier returns matching plan for each tier', () {
      expect(PricingPlan.forTier(SubscriptionTier.free).tier, SubscriptionTier.free);
      expect(PricingPlan.forTier(SubscriptionTier.pro).tier, SubscriptionTier.pro);
      expect(PricingPlan.forTier(SubscriptionTier.premium).tier, SubscriptionTier.premium);
      expect(PricingPlan.forTier(SubscriptionTier.lifetime).tier, SubscriptionTier.lifetime);
    });

    test('Free plan features include no watermark PDF and core templates', () {
      const free = PricingPlan.free;
      expect(free.featureKeys, contains('feature_pdf_export_no_watermark'));
      expect(free.featureKeys, contains('feature_core_templates'));
      expect(free.featureKeys, contains('feature_languages_rtl'));
    });
  });
}
