import 'package:flutter/material.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../domain/models/subscription_tier.dart';

class SubscriptionBadge extends StatelessWidget {
  final SubscriptionTier tier;
  final bool showIcon;
  final double fontSize;
  final VoidCallback? onTap;

  const SubscriptionBadge({
    super.key,
    required this.tier,
    this.showIcon = true,
    this.fontSize = 12,
    this.onTap,
  });

  IconData get _icon {
    switch (tier) {
      case SubscriptionTier.free:
        return Icons.person_outline;
      case SubscriptionTier.pro:
        return Icons.star_rounded;
      case SubscriptionTier.premium:
        return Icons.workspace_premium_rounded;
      case SubscriptionTier.lifetime:
        return Icons.all_inclusive_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = tier.badgeColor;

    final badge = Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.4), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (showIcon) ...[
            Icon(_icon, size: fontSize + 2, color: color),
            const SizedBox(width: 4),
          ],
          Text(
            context.tr(tier.titleKey),
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );

    if (onTap != null) {
      return InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: badge,
      );
    }

    return badge;
  }
}
