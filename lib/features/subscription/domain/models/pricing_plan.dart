import 'subscription_tier.dart';

enum BillingPeriod {
  monthly,
  yearly,
  oneTime;

  String get labelKey {
    switch (this) {
      case BillingPeriod.monthly:
        return 'period_monthly';
      case BillingPeriod.yearly:
        return 'period_yearly';
      case BillingPeriod.oneTime:
        return 'period_one_time';
    }
  }
}

class PlanPrice {
  final int amountDzd;
  final BillingPeriod period;

  const PlanPrice({
    required this.amountDzd,
    required this.period,
  });

  String get formattedPrice => '$amountDzd DZD';
}

class PricingPlan {
  final SubscriptionTier tier;
  final String titleKey;
  final String subtitleKey;
  final PlanPrice monthlyPrice;
  final PlanPrice yearlyPrice;
  final PlanPrice? oneTimePrice;
  final List<String> featureKeys;
  final bool isPopular;
  final int cvLimit; // -1 for unlimited
  final int aiOperationsLimit; // -1 for unlimited

  const PricingPlan({
    required this.tier,
    required this.titleKey,
    required this.subtitleKey,
    required this.monthlyPrice,
    required this.yearlyPrice,
    this.oneTimePrice,
    required this.featureKeys,
    this.isPopular = false,
    required this.cvLimit,
    required this.aiOperationsLimit,
  });

  static const PricingPlan free = PricingPlan(
    tier: SubscriptionTier.free,
    titleKey: 'tier_free',
    subtitleKey: 'tier_free_subtitle',
    monthlyPrice: PlanPrice(amountDzd: 0, period: BillingPeriod.monthly),
    yearlyPrice: PlanPrice(amountDzd: 0, period: BillingPeriod.yearly),
    cvLimit: 2,
    aiOperationsLimit: 3,
    featureKeys: [
      'feature_cv_limit_2',
      'feature_core_templates',
      'feature_pdf_export_no_watermark',
      'feature_languages_rtl',
      'feature_all_sections',
      'feature_offline_storage',
      'feature_ai_free',
    ],
  );

  static const PricingPlan pro = PricingPlan(
    tier: SubscriptionTier.pro,
    titleKey: 'tier_pro',
    subtitleKey: 'tier_pro_subtitle',
    monthlyPrice: PlanPrice(amountDzd: 299, period: BillingPeriod.monthly),
    yearlyPrice: PlanPrice(amountDzd: 2490, period: BillingPeriod.yearly),
    isPopular: true,
    cvLimit: 10,
    aiOperationsLimit: 30,
    featureKeys: [
      'feature_cv_limit_10',
      'feature_all_templates',
      'feature_unlimited_pdf',
      'feature_docx_export',
      'feature_cover_letter',
      'feature_ai_pro_30',
      'feature_ats_analysis',
      'feature_job_matching',
      'feature_qr_and_sharing',
    ],
  );

  static const PricingPlan premium = PricingPlan(
    tier: SubscriptionTier.premium,
    titleKey: 'tier_premium',
    subtitleKey: 'tier_premium_subtitle',
    monthlyPrice: PlanPrice(amountDzd: 499, period: BillingPeriod.monthly),
    yearlyPrice: PlanPrice(amountDzd: 3990, period: BillingPeriod.yearly),
    cvLimit: -1,
    aiOperationsLimit: -1,
    featureKeys: [
      'feature_unlimited_cvs',
      'feature_all_pro_features',
      'feature_premium_templates',
      'feature_unlimited_ai',
      'feature_advanced_ats',
      'feature_interview_prep',
      'feature_multilang_generation',
      'feature_advanced_photo',
      'feature_cv_analytics',
      'feature_priority_support',
    ],
  );

  static const PricingPlan lifetime = PricingPlan(
    tier: SubscriptionTier.lifetime,
    titleKey: 'tier_lifetime',
    subtitleKey: 'tier_lifetime_subtitle',
    monthlyPrice: PlanPrice(amountDzd: 7900, period: BillingPeriod.oneTime),
    yearlyPrice: PlanPrice(amountDzd: 7900, period: BillingPeriod.oneTime),
    oneTimePrice: PlanPrice(amountDzd: 7900, period: BillingPeriod.oneTime),
    cvLimit: 10,
    aiOperationsLimit: 30,
    featureKeys: [
      'feature_permanent_access',
      'feature_one_time_payment',
      'feature_all_pro_features',
      'feature_no_recurring_fees',
      'feature_future_pro_updates',
    ],
  );

  static List<PricingPlan> get allPlans => [free, pro, premium, lifetime];

  static PricingPlan forTier(SubscriptionTier tier) {
    switch (tier) {
      case SubscriptionTier.free:
        return free;
      case SubscriptionTier.pro:
        return pro;
      case SubscriptionTier.premium:
        return premium;
      case SubscriptionTier.lifetime:
        return lifetime;
    }
  }
}
