import 'package:flutter/material.dart';

enum SubscriptionTier {
  free,
  pro,
  premium,
  lifetime;

  bool get isPaid => this != SubscriptionTier.free;

  bool get isProOrHigher =>
      this == SubscriptionTier.pro ||
      this == SubscriptionTier.premium ||
      this == SubscriptionTier.lifetime;

  bool get isPremiumOrHigher =>
      this == SubscriptionTier.premium ||
      this == SubscriptionTier.lifetime;

  bool get isLifetime => this == SubscriptionTier.lifetime;

  bool get isUnlimitedAi => isPremiumOrHigher;

  String get titleKey {
    switch (this) {
      case SubscriptionTier.free:
        return 'tier_free';
      case SubscriptionTier.pro:
        return 'tier_pro';
      case SubscriptionTier.premium:
        return 'tier_premium';
      case SubscriptionTier.lifetime:
        return 'tier_lifetime';
    }
  }

  Color get badgeColor {
    switch (this) {
      case SubscriptionTier.free:
        return const Color(0xFF78909C); // Slate / Blue Grey
      case SubscriptionTier.pro:
        return const Color(0xFF1E88E5); // Bright Blue
      case SubscriptionTier.premium:
        return const Color(0xFF7B1FA2); // Royal Purple
      case SubscriptionTier.lifetime:
        return const Color(0xFFFF8F00); // Amber / Gold
    }
  }
}
