import 'package:flutter/material.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../domain/models/subscription_tier.dart';
import '../screens/pricing_screen.dart';

class UpgradeDialog extends StatelessWidget {
  final SubscriptionTier requiredTier;
  final String featureKey;
  final String? customDescriptionKey;

  const UpgradeDialog({
    super.key,
    required this.requiredTier,
    required this.featureKey,
    this.customDescriptionKey,
  });

  static Future<void> show(
    BuildContext context, {
    required SubscriptionTier requiredTier,
    required String featureKey,
    String? customDescriptionKey,
  }) {
    return showDialog(
      context: context,
      builder: (ctx) => UpgradeDialog(
        requiredTier: requiredTier,
        featureKey: featureKey,
        customDescriptionKey: customDescriptionKey,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final tierTitle = context.tr(requiredTier.titleKey);
    final featureTitle = context.tr(featureKey);
    final color = requiredTier.badgeColor;

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(
              requiredTier == SubscriptionTier.premium
                  ? Icons.workspace_premium_rounded
                  : Icons.star_rounded,
              color: color,
              size: 24,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              requiredTier == SubscriptionTier.premium
                  ? context.tr('available_with_premium')
                  : context.tr('available_with_pro'),
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
      content: SizedBox(
        width: 440,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              context.tr('upgrade_dialog_desc').replaceAll('{feature}', featureTitle).replaceAll('{tier}', tierTitle),
              style: const TextStyle(fontSize: 14, height: 1.4),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceVariant.withOpacity(0.5),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: color.withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  Icon(Icons.check_circle_outline, color: color, size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      context.tr('${featureKey}_benefit'),
                      style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(context.tr('not_now')),
        ),
        FilledButton.icon(
          style: FilledButton.styleFrom(backgroundColor: color),
          onPressed: () {
            Navigator.of(context).pop();
            Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const PricingScreen()),
            );
          },
          icon: const Icon(Icons.arrow_forward_rounded, size: 18),
          label: Text(context.tr('view_plans')),
        ),
      ],
    );
  }
}
