import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models/subscription_tier.dart';
import '../providers/subscription_providers.dart';

class DeveloperTierSelector extends ConsumerWidget {
  const DeveloperTierSelector({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (!kDebugMode) return const SizedBox.shrink();

    final currentStatus = ref.watch(subscriptionStatusProvider);

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.amber.withOpacity(0.12),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.amber.shade700, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Icon(Icons.developer_mode_rounded, size: 18, color: Colors.amber.shade800),
              const SizedBox(width: 8),
              Text(
                'DEV MODE: Test Subscription Tiers',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: Colors.amber.shade900,
                ),
              ),
              const Spacer(),
              Text(
                'Active: ${currentStatus.tier.name.toUpperCase()}',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: currentStatus.tier.badgeColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 6,
            children: SubscriptionTier.values.map((tier) {
              final isSelected = currentStatus.tier == tier;
              return ChoiceChip(
                label: Text(tier.name.toUpperCase()),
                selected: isSelected,
                selectedColor: tier.badgeColor.withOpacity(0.2),
                labelStyle: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: isSelected ? tier.badgeColor : null,
                ),
                onSelected: (selected) {
                  if (selected) {
                    ref.read(subscriptionStatusProvider.notifier).setTier(tier);
                  }
                },
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
