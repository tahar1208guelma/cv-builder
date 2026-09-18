import 'package:flutter/material.dart';
import '../../../../core/localization/app_localizations.dart';

class UsageProgressIndicator extends StatelessWidget {
  final String label;
  final int currentUsage;
  final int limit; // -1 for unlimited
  final IconData icon;

  const UsageProgressIndicator({
    super.key,
    required this.label,
    required this.currentUsage,
    required this.limit,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isUnlimited = limit < 0;
    final progress = isUnlimited ? 0.0 : (limit == 0 ? 1.0 : (currentUsage / limit).clamp(0.0, 1.0));
    final isNearLimit = !isUnlimited && currentUsage >= limit;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            Icon(icon, size: 16, color: theme.colorScheme.primary),
            const SizedBox(width: 6),
            Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
            ),
            const Spacer(),
            Text(
              isUnlimited
                  ? context.tr('usage_unlimited')
                  : '$currentUsage / $limit',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: isNearLimit ? Colors.amber.shade800 : theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: isUnlimited ? 0.15 : progress,
            minHeight: 6,
            backgroundColor: theme.colorScheme.surfaceVariant,
            valueColor: AlwaysStoppedAnimation<Color>(
              isUnlimited
                  ? Colors.green
                  : (isNearLimit ? Colors.orange.shade700 : theme.colorScheme.primary),
            ),
          ),
        ),
      ],
    );
  }
}
