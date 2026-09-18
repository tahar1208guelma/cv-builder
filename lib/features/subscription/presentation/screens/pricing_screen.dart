import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../domain/models/pricing_plan.dart';
import '../../domain/models/subscription_tier.dart';
import '../providers/subscription_providers.dart';
import '../widgets/developer_tier_selector.dart';
import '../widgets/plan_card.dart';
import '../widgets/subscription_badge.dart';

class PricingScreen extends ConsumerStatefulWidget {
  const PricingScreen({super.key});

  @override
  ConsumerState<PricingScreen> createState() => _PricingScreenState();
}

class _PricingScreenState extends ConsumerState<PricingScreen> {
  BillingPeriod _selectedPeriod = BillingPeriod.monthly;
  bool _isProcessing = false;

  Future<void> _handleSelectPlan(PricingPlan plan) async {
    final statusNotifier = ref.read(subscriptionStatusProvider.notifier);
    final paymentService = ref.read(paymentServiceProvider);

    setState(() => _isProcessing = true);
    try {
      if (plan.tier == SubscriptionTier.free) {
        await statusNotifier.setTier(SubscriptionTier.free);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(context.tr('plan_switched_free'))),
          );
        }
      } else {
        final result = await paymentService.purchasePlan(
          plan.tier,
          isYearly: _selectedPeriod == BillingPeriod.yearly,
        );

        if (result.isSuccess && result.updatedStatus != null) {
          await statusNotifier.updateStatus(result.updatedStatus!);
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  context.tr('plan_upgrade_success').replaceAll(
                        '{plan}',
                        context.tr(plan.titleKey),
                      ),
                ),
                backgroundColor: plan.tier.badgeColor,
              ),
            );
          }
        } else if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(result.errorMessage ?? context.tr('purchase_cancelled'))),
          );
        }
      }
    } finally {
      if (mounted) {
        setState(() => _isProcessing = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final status = ref.watch(subscriptionStatusProvider);
    final theme = Theme.of(context);
    final plans = PricingPlan.allPlans;

    return Scaffold(
      appBar: AppBar(
        title: Text(context.tr('pricing_and_plans')),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Center(
              child: SubscriptionBadge(tier: status.tier),
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1200),
                child: Column(
                  children: [
                    Text(
                      context.tr('pricing_header_title'),
                      textAlign: TextAlign.center,
                      style: theme.textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      context.tr('pricing_header_desc'),
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Billing Period Toggle (Monthly vs Yearly)
                    SegmentedButton<BillingPeriod>(
                      segments: [
                        ButtonSegment(
                          value: BillingPeriod.monthly,
                          label: Text(context.tr('period_monthly')),
                          icon: const Icon(Icons.calendar_view_month_rounded),
                        ),
                        ButtonSegment(
                          value: BillingPeriod.yearly,
                          label: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(context.tr('period_yearly')),
                              const SizedBox(width: 6),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: Colors.green.shade100,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  context.tr('save_up_to_33'),
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.green.shade900,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          icon: const Icon(Icons.calendar_today_rounded),
                        ),
                      ],
                      selected: {_selectedPeriod},
                      onSelectionChanged: (set) {
                        setState(() => _selectedPeriod = set.first);
                      },
                    ),

                    const SizedBox(height: 32),

                    // Responsive Plan Cards Layout
                    LayoutBuilder(
                      builder: (context, constraints) {
                        if (constraints.maxWidth > 1150) {
                          // Desktop / Large screen: 4 columns
                          return GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 4,
                              crossAxisSpacing: 16,
                              mainAxisSpacing: 16,
                              mainAxisExtent: 660,
                            ),
                            itemCount: plans.length,
                            itemBuilder: (context, index) {
                              return PlanCard(
                                plan: plans[index],
                                currentTier: status.tier,
                                selectedPeriod: _selectedPeriod,
                                onSelectPlan: () => _handleSelectPlan(plans[index]),
                              );
                            },
                          );
                        } else if (constraints.maxWidth > 600) {
                          // Tablet: 2 columns
                          return GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 16,
                              mainAxisSpacing: 16,
                              mainAxisExtent: 640,
                            ),
                            itemCount: plans.length,
                            itemBuilder: (context, index) {
                              return PlanCard(
                                plan: plans[index],
                                currentTier: status.tier,
                                selectedPeriod: _selectedPeriod,
                                onSelectPlan: () => _handleSelectPlan(plans[index]),
                              );
                            },
                          );
                        } else {
                          // Mobile: vertical list
                          return ListView.separated(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: plans.length,
                            separatorBuilder: (_, __) => const SizedBox(height: 16),
                            itemBuilder: (context, index) {
                              return SizedBox(
                                height: 580,
                                child: PlanCard(
                                  plan: plans[index],
                                  currentTier: status.tier,
                                  selectedPeriod: _selectedPeriod,
                                  onSelectPlan: () => _handleSelectPlan(plans[index]),
                                ),
                              );
                            },
                          );
                        }
                      },
                    ),

                    const SizedBox(height: 32),

                    // Debug Developer Tier Selector
                    if (kDebugMode) const DeveloperTierSelector(),

                    const SizedBox(height: 24),
                    Text(
                      context.tr('pricing_disclaimer'),
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (_isProcessing)
            Container(
              color: Colors.black.withOpacity(0.3),
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
        ],
      ),
    );
  }
}
