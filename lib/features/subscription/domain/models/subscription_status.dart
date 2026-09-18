import 'subscription_tier.dart';

class SubscriptionStatus {
  final SubscriptionTier tier;
  final DateTime? expirationDate;
  final bool isAutoRenew;
  final String purchaseSource;
  final bool isLifetime;
  final bool isDevelopment;

  const SubscriptionStatus({
    required this.tier,
    this.expirationDate,
    this.isAutoRenew = false,
    this.purchaseSource = 'local',
    this.isLifetime = false,
    this.isDevelopment = false,
  });

  factory SubscriptionStatus.free() {
    return const SubscriptionStatus(
      tier: SubscriptionTier.free,
      expirationDate: null,
      isAutoRenew: false,
      purchaseSource: 'default',
      isLifetime: false,
      isDevelopment: false,
    );
  }

  factory SubscriptionStatus.development(SubscriptionTier tier) {
    return SubscriptionStatus(
      tier: tier,
      expirationDate: tier == SubscriptionTier.free
          ? null
          : DateTime.now().add(const Duration(days: 365)),
      isAutoRenew: tier != SubscriptionTier.free && tier != SubscriptionTier.lifetime,
      purchaseSource: 'development_override',
      isLifetime: tier == SubscriptionTier.lifetime,
      isDevelopment: true,
    );
  }

  bool get isActive {
    if (tier == SubscriptionTier.free) return true;
    if (isLifetime || tier == SubscriptionTier.lifetime) return true;
    if (expirationDate == null) return true;
    return expirationDate!.isAfter(DateTime.now());
  }

  SubscriptionStatus copyWith({
    SubscriptionTier? tier,
    DateTime? expirationDate,
    bool? isAutoRenew,
    String? purchaseSource,
    bool? isLifetime,
    bool? isDevelopment,
  }) {
    return SubscriptionStatus(
      tier: tier ?? this.tier,
      expirationDate: expirationDate ?? this.expirationDate,
      isAutoRenew: isAutoRenew ?? this.isAutoRenew,
      purchaseSource: purchaseSource ?? this.purchaseSource,
      isLifetime: isLifetime ?? this.isLifetime,
      isDevelopment: isDevelopment ?? this.isDevelopment,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'tier': tier.name,
      'expiration_date': expirationDate?.toIso8601String(),
      'is_auto_renew': isAutoRenew,
      'purchase_source': purchaseSource,
      'is_lifetime': isLifetime,
      'is_development': isDevelopment,
    };
  }

  factory SubscriptionStatus.fromJson(Map<String, dynamic> json) {
    final tierName = json['tier'] as String? ?? 'free';
    final tier = SubscriptionTier.values.firstWhere(
      (t) => t.name == tierName,
      orElse: () => SubscriptionTier.free,
    );

    return SubscriptionStatus(
      tier: tier,
      expirationDate: json['expiration_date'] != null
          ? DateTime.tryParse(json['expiration_date'] as String)
          : null,
      isAutoRenew: json['is_auto_renew'] as bool? ?? false,
      purchaseSource: json['purchase_source'] as String? ?? 'local',
      isLifetime: json['is_lifetime'] as bool? ?? (tier == SubscriptionTier.lifetime),
      isDevelopment: json['is_development'] as bool? ?? false,
    );
  }
}
