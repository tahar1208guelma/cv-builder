import 'package:flutter/material.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../domain/models/pricing_plan.dart';
import '../../domain/models/subscription_tier.dart';

class PlanCard extends StatelessWidget {
  final PricingPlan plan;
  final SubscriptionTier currentTier;
  final BillingPeriod selectedPeriod;
  final VoidCallback onSelectPlan;

  const PlanCard({
    super.key,
    required this.plan,
    required this.currentTier,
    required this.selectedPeriod,
    required this.onSelectPlan,
  });

  bool get isCurrentPlan => currentTier == plan.tier;

  String _getPriceDisplay(BuildContext context) {
    if (plan.tier == SubscriptionTier.free) {
      return '0 DZD';
    }
    if (plan.tier == SubscriptionTier.lifetime) {
      return '7,900 DZD';
    }
    if (selectedPeriod == BillingPeriod.yearly) {
      return '${plan.yearlyPrice.amountDzd} DZD';
    }
    return '${plan.monthlyPrice.amountDzd} DZD';
  }

  String _getPeriodDisplay(BuildContext context) {
    if (plan.tier == SubscriptionTier.free) {
      return context.tr('period_free_forever');
    }
    if (plan.tier == SubscriptionTier.lifetime) {
      return context.tr('period_one_time');
    }
    if (selectedPeriod == BillingPeriod.yearly) {
      return context.tr('per_year');
    }
    return context.tr('per_month');
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = plan.tier.badgeColor;

    return Card(
      elevation: plan.isPopular ? 4 : 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: isCurrentPlan
              ? color
              : (plan.isPopular ? color.withOpacity(0.5) : Colors.transparent),
          width: isCurrentPlan ? 2 : 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    context.tr(plan.titleKey),
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: plan.tier.isPaid ? color : null,
                    ),
                  ),
                ),
                if (plan.isPopular)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      context.tr('popular_choice'),
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: color,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              context.tr(plan.subtitleKey),
              style: TextStyle(
                fontSize: 13,
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 16),
            Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: 6,
              runSpacing: 4,
              children: [
                Text(
                  _getPriceDisplay(context),
                  style: const TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                Text(
                  _getPeriodDisplay(context),
                  style: TextStyle(
                    fontSize: 13,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
            if (selectedPeriod == BillingPeriod.yearly &&
                plan.tier != SubscriptionTier.free &&
                plan.tier != SubscriptionTier.lifetime) ...[
              const SizedBox(height: 4),
              Text(
                context.tr('save_yearly_badge'),
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
            ],
            const Divider(height: 28),
            Expanded(
              child: ListView(
                physics: const NeverScrollableScrollPhysics(),
                padding: EdgeInsets.zero,
                children: plan.featureKeys.map((fKey) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.check_circle_rounded,
                          size: 18,
                          color: color,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            context.tr(fKey),
                            style: const TextStyle(fontSize: 13),
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: isCurrentPlan
                  ? OutlinedButton(
                      onPressed: null,
                      style: OutlinedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: Text(context.tr('current_plan')),
                    )
                  : FilledButton(
                      onPressed: onSelectPlan,
                      style: FilledButton.styleFrom(
                        backgroundColor: color,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: Text(
                        plan.tier == SubscriptionTier.free
                            ? context.tr('use_free_plan')
                            : context.tr('select_plan'),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
