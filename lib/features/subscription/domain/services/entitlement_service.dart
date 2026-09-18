import '../models/pricing_plan.dart';
import '../models/subscription_tier.dart';

class EntitlementService {
  const EntitlementService();

  int getCvLimit(SubscriptionTier tier) {
    return PricingPlan.forTier(tier).cvLimit;
  }

  int getAiOperationsLimit(SubscriptionTier tier) {
    return PricingPlan.forTier(tier).aiOperationsLimit;
  }

  bool canCreateAnotherCv({
    required SubscriptionTier tier,
    required int currentCvCount,
  }) {
    final limit = getCvLimit(tier);
    if (limit < 0) return true; // Unlimited
    return currentCvCount < limit;
  }

  bool canUseTemplate({
    required SubscriptionTier userTier,
    required SubscriptionTier requiredTier,
  }) {
    if (requiredTier == SubscriptionTier.free) return true;
    if (requiredTier == SubscriptionTier.pro) return userTier.isProOrHigher;
    if (requiredTier == SubscriptionTier.premium) return userTier.isPremiumOrHigher;
    if (requiredTier == SubscriptionTier.lifetime) return userTier.isProOrHigher;
    return true;
  }

  bool canUseAi({
    required SubscriptionTier tier,
    required int currentUsage,
  }) {
    final limit = getAiOperationsLimit(tier);
    if (limit < 0) return true; // Unlimited
    return currentUsage < limit;
  }

  int getRemainingAiOperations({
    required SubscriptionTier tier,
    required int currentUsage,
  }) {
    final limit = getAiOperationsLimit(tier);
    if (limit < 0) return -1; // Unlimited
    final remaining = limit - currentUsage;
    return remaining < 0 ? 0 : remaining;
  }

  bool canExportDocx(SubscriptionTier tier) => tier.isProOrHigher;

  bool canUseCoverLetter(SubscriptionTier tier) => tier.isProOrHigher;

  bool canUseAtsAnalysis(SubscriptionTier tier) => tier.isProOrHigher;

  bool canUseJobMatching(SubscriptionTier tier) => tier.isProOrHigher;

  bool canUseShareableLink(SubscriptionTier tier) => tier.isProOrHigher;

  bool canUseQrCode(SubscriptionTier tier) => tier.isProOrHigher;

  bool canUseAdvancedAts(SubscriptionTier tier) => tier.isPremiumOrHigher;

  bool canUseInterviewPrep(SubscriptionTier tier) => tier.isPremiumOrHigher;

  bool canUseMultiLangGeneration(SubscriptionTier tier) => tier.isPremiumOrHigher;

  bool canUseAdvancedPhoto(SubscriptionTier tier) => tier.isPremiumOrHigher;

  bool canUseCvAnalytics(SubscriptionTier tier) => tier.isPremiumOrHigher;

  SubscriptionTier getRequiredTierForFeature(String featureKey) {
    switch (featureKey) {
      case 'feature_unlimited_cvs':
      case 'feature_advanced_ats':
      case 'feature_interview_prep':
      case 'feature_multilang_generation':
      case 'feature_advanced_photo':
      case 'feature_cv_analytics':
        return SubscriptionTier.premium;
      case 'feature_docx_export':
      case 'feature_cover_letter':
      case 'feature_ats_analysis':
      case 'feature_job_matching':
      case 'feature_qr_and_sharing':
      default:
        return SubscriptionTier.pro;
    }
  }
}
