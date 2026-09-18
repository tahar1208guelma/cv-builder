import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/constants/app_constants.dart';
import '../../domain/models/subscription_status.dart';
import '../../domain/models/subscription_tier.dart';
import '../../domain/models/usage_metrics.dart';

class SubscriptionLocalDataSource {
  Future<SubscriptionStatus> getSubscriptionStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonStr = prefs.getString(AppConstants.prefsSubscriptionStatusKey);
    if (jsonStr == null || jsonStr.isEmpty) {
      return SubscriptionStatus.free();
    }
    try {
      final json = jsonDecode(jsonStr) as Map<String, dynamic>;
      return SubscriptionStatus.fromJson(json);
    } catch (_) {
      return SubscriptionStatus.free();
    }
  }

  Future<void> saveSubscriptionStatus(SubscriptionStatus status) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      AppConstants.prefsSubscriptionStatusKey,
      jsonEncode(status.toJson()),
    );
  }

  Future<SubscriptionTier?> getDevelopmentTier() async {
    final prefs = await SharedPreferences.getInstance();
    final tierName = prefs.getString(AppConstants.prefsDevTierKey);
    if (tierName == null || tierName.isEmpty) return null;
    try {
      return SubscriptionTier.values.firstWhere((t) => t.name == tierName);
    } catch (_) {
      return null;
    }
  }

  Future<void> setDevelopmentTier(SubscriptionTier tier) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(AppConstants.prefsDevTierKey, tier.name);
  }

  Future<void> clearDevelopmentTier() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(AppConstants.prefsDevTierKey);
  }

  Future<UsageMetrics> getUsageMetrics() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonStr = prefs.getString(AppConstants.prefsUsageMetricsKey);
    if (jsonStr == null || jsonStr.isEmpty) {
      return UsageMetrics.initial();
    }
    try {
      final json = jsonDecode(jsonStr) as Map<String, dynamic>;
      return UsageMetrics.fromJson(json);
    } catch (_) {
      return UsageMetrics.initial();
    }
  }

  Future<void> saveUsageMetrics(UsageMetrics metrics) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      AppConstants.prefsUsageMetricsKey,
      jsonEncode(metrics.toJson()),
    );
  }
}
