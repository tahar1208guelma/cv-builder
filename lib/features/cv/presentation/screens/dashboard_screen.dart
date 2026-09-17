import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../domain/models/cv_model.dart';
import '../providers/cv_providers.dart';
import '../providers/settings_provider.dart';
import '../widgets/common/confirm_dialog.dart';
import '../widgets/common/language_selector_dialog.dart';
import 'cv_editor_screen.dart';
import 'cv_preview_screen.dart';
import 'settings_screen.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  void _showNewCvDialog(BuildContext context, WidgetRef ref) {
    final defaultTitle = context.tr('default_cv_title');
    final titleCtrl = TextEditingController(text: defaultTitle);
    String selectedLang = ref.read(settingsProvider).defaultCvLanguage;
    bool prefill = true;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: Row(
            children: [
              const Icon(Icons.add_circle_outline),
              const SizedBox(width: 8),
              Text(context.tr('new_cv_title')),
            ],
          ),
          content: SizedBox(
            width: 480,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: titleCtrl,
                  decoration: InputDecoration(
                    labelText: context.tr('cv_title_label'),
                    hintText: context.tr('cv_title_hint'),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  context.tr('cv_language_label'),
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                ),
                const SizedBox(height: 4),
                Text(
                  context.tr('cv_language_help'),
                  style: TextStyle(fontSize: 12, color: Theme.of(context).colorScheme.onSurfaceVariant),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    _buildLangChoice(
                      label: 'English (LTR)',
                      code: AppConstants.langEn,
                      selected: selectedLang,
                      onTap: () => setState(() => selectedLang = AppConstants.langEn),
                    ),
                    const SizedBox(width: 8),
                    _buildLangChoice(
                      label: 'Français (LTR)',
                      code: AppConstants.langFr,
                      selected: selectedLang,
                      onTap: () => setState(() => selectedLang = AppConstants.langFr),
                    ),
                    const SizedBox(width: 8),
                    _buildLangChoice(
                      label: 'العربية (RTL)',
                      code: AppConstants.langAr,
                      selected: selectedLang,
                      onTap: () => setState(() => selectedLang = AppConstants.langAr),
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                Text(
                  context.tr('start_mode'),
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                ),
                RadioListTile<bool>(
                  value: true,
                  groupValue: prefill,
                  title: Text(context.tr('prefilled_template')),
                  subtitle: Text(context.tr('prefilled_subtitle')),
                  onChanged: (val) => setState(() => prefill = val ?? true),
                  contentPadding: EdgeInsets.zero,
                  dense: true,
                ),
                RadioListTile<bool>(
                  value: false,
                  groupValue: prefill,
                  title: Text(context.tr('blank_cv')),
                  subtitle: Text(context.tr('blank_subtitle')),
                  onChanged: (val) => setState(() => prefill = val ?? false),
                  contentPadding: EdgeInsets.zero,
                  dense: true,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: Text(context.tr('cancel')),
            ),
            ElevatedButton(
              onPressed: () async {
                final title = titleCtrl.text.trim().isEmpty ? context.tr('default_cv_title') : titleCtrl.text.trim();
                Navigator.of(ctx).pop();
                final newCv = await ref.read(cvListProvider.notifier).createNewCv(
                      title: title,
                      language: selectedLang,
                      prefillSample: prefill,
                    );
                if (context.mounted) {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => CvEditorScreen(initialCv: newCv),
                    ),
                  );
                }
              },
              child: Text(context.tr('create_cv')),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLangChoice({
    required String label,
    required String code,
    required String selected,
    required VoidCallback onTap,
  }) {
    final isSelected = selected == code;
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 6),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isSelected ? AppColors.primary : Colors.grey.shade300,
              width: isSelected ? 2 : 1,
            ),
            color: isSelected ? AppColors.primary.withValues(alpha: 0.08) : null,
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              color: isSelected ? AppColors.primary : null,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final listState = ref.watch(cvListProvider);
    final listNotifier = ref.read(cvListProvider.notifier);
    final settings = ref.watch(settingsProvider);
    final settingsNotifier = ref.read(settingsProvider.notifier);

    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.description, color: Colors.white, size: 20),
            ),
            const SizedBox(width: 10),
            Text(
              context.tr('app_title'),
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
          ],
        ),
        actions: [
          // UI Language Selector Button
          TextButton.icon(
            onPressed: () => LanguageSelectorDialog.show(context),
            icon: const Icon(Icons.language, size: 18),
            label: Text(
              '${settings.appLanguage.nativeName} (${settings.appLanguage.code.toUpperCase()})',
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          // Theme Switcher Button
          IconButton(
            tooltip: context.tr('theme'),
            icon: Icon(isDark ? Icons.light_mode : Icons.dark_mode),
            onPressed: () {
              settingsNotifier.setThemeMode(isDark ? ThemeMode.light : ThemeMode.dark);
            },
          ),
          // Settings Button
          IconButton(
            tooltip: context.tr('settings_title'),
            icon: const Icon(Icons.settings_outlined),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => const SettingsScreen(),
                ),
              );
            },
          ),
          const SizedBox(width: 12),
        ],
      ),
      body: listState.isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Hero Banner
                  _buildHeroBanner(context, ref, listState),
                  const SizedBox(height: 24),
                  // Search and Filters Bar
                  _buildFilterBar(context, ref, listState, listNotifier),
                  const SizedBox(height: 20),
                  // CV List / Grid
                  if (listState.filteredCvs.isEmpty)
                    _buildEmptyState(context, ref)
                  else
                    _buildCvGrid(context, ref, listState.filteredCvs, listNotifier),
                ],
              ),
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showNewCvDialog(context, ref),
        icon: const Icon(Icons.add),
        label: Text(context.tr('create_new_cv')),
      ),
    );
  }

  Widget _buildHeroBanner(BuildContext context, WidgetRef ref, CvListState state) {
    final total = state.cvs.length;
    final enCount = state.cvs.where((c) => c.language == 'en').length;
    final frCount = state.cvs.where((c) => c.language == 'fr').length;
    final arCount = state.cvs.where((c) => c.language == 'ar').length;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Theme.of(context).colorScheme.primary,
            Theme.of(context).colorScheme.secondary,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.2),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.tr('tagline'),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 16,
                  runSpacing: 8,
                  children: [
                    _buildStatPill(context.tr('total'), '$total'),
                    _buildStatPill('EN (LTR)', '$enCount'),
                    _buildStatPill('FR (LTR)', '$frCount'),
                    _buildStatPill('AR (RTL)', '$arCount'),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Theme.of(context).colorScheme.primary,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            ),
            onPressed: () => _showNewCvDialog(context, ref),
            icon: const Icon(Icons.add_circle, size: 20),
            label: Text(
              context.tr('create_new_cv'),
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatPill(String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        '$label: $value',
        style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600),
      ),
    );
  }

  Widget _buildFilterBar(
    BuildContext context,
    WidgetRef ref,
    CvListState state,
    CvListNotifier notifier,
  ) {
    return Row(
      children: [
        // Search Input
        Expanded(
          flex: 3,
          child: TextField(
            decoration: InputDecoration(
              hintText: context.tr('search'),
              prefixIcon: const Icon(Icons.search, size: 20),
              isDense: true,
              suffixIcon: state.searchQuery.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear, size: 18),
                      onPressed: () => notifier.setSearchQuery(''),
                    )
                  : null,
            ),
            onChanged: (val) => notifier.setSearchQuery(val),
          ),
        ),
        const SizedBox(width: 16),
        // Language Filter Segmented
        SegmentedButton<String>(
          segments: [
            ButtonSegment(value: 'all', label: Text(context.tr('all'))),
            const ButtonSegment(value: 'en', label: Text('English')),
            const ButtonSegment(value: 'fr', label: Text('Français')),
            const ButtonSegment(value: 'ar', label: Text('العربية')),
          ],
          selected: {state.languageFilter},
          onSelectionChanged: (newSelection) {
            notifier.setLanguageFilter(newSelection.first);
          },
        ),
      ],
    );
  }

  Widget _buildEmptyState(BuildContext context, WidgetRef ref) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(48),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.folder_open_outlined,
                size: 64,
                color: Theme.of(context).colorScheme.outline,
              ),
              const SizedBox(height: 16),
              Text(
                context.tr('no_cvs_title'),
                style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                context.tr('no_cvs_desc'),
                textAlign: TextAlign.center,
                style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant),
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: () => _showNewCvDialog(context, ref),
                icon: const Icon(Icons.add),
                label: Text(context.tr('create_first_cv')),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCvGrid(
    BuildContext context,
    WidgetRef ref,
    List<CvModel> cvs,
    CvListNotifier notifier,
  ) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final crossAxisCount = constraints.maxWidth > 1100
            ? 3
            : (constraints.maxWidth > 700 ? 2 : 1);

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            mainAxisExtent: 220,
          ),
          itemCount: cvs.length,
          itemBuilder: (context, index) {
            final cv = cvs[index];
            return _buildCvCard(context, ref, cv, notifier);
          },
        );
      },
    );
  }

  Widget _buildCvCard(
    BuildContext context,
    WidgetRef ref,
    CvModel cv,
    CvListNotifier notifier,
  ) {
    final themeColor = AppColors.fromHex(cv.style.primaryColorHex);
    final dateStr = DateFormatter.formatMonthYear(cv.updatedAt);

    return Card(
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => CvEditorScreen(initialCv: cv),
            ),
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Badges Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Language Badge
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: themeColor.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: themeColor.withValues(alpha: 0.3)),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.translate, size: 12, color: themeColor),
                        const SizedBox(width: 4),
                        Text(
                          '${cv.language.toUpperCase()} • ${cv.isRtl ? "RTL" : "LTR"}',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: themeColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Template Badge
                  Text(
                    cv.style.templateId.toUpperCase(),
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.outline,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              // CV Title
              Text(
                cv.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 4),
              // Full Name & Job Title
              Text(
                cv.personalInfo.fullName.isNotEmpty
                    ? '${cv.personalInfo.fullName}${cv.personalInfo.jobTitle.isNotEmpty ? " • ${cv.personalInfo.jobTitle}" : ""}'
                    : context.tr('personal_details_incomplete'),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 13,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
              const Spacer(),
              // Footer & Actions
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      '${context.tr("last_updated")}: $dateStr',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 11,
                        color: Theme.of(context).colorScheme.outline,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Preview / Export
                      IconButton(
                        visualDensity: VisualDensity.compact,
                        tooltip: context.tr('preview'),
                        icon: const Icon(Icons.picture_as_pdf_outlined, size: 18),
                        padding: const EdgeInsets.all(4),
                        constraints: const BoxConstraints(),
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => CvPreviewScreen(cv: cv),
                            ),
                          );
                        },
                      ),
                      // Duplicate
                      IconButton(
                        visualDensity: VisualDensity.compact,
                        tooltip: context.tr('duplicate'),
                        icon: const Icon(Icons.copy_outlined, size: 18),
                        padding: const EdgeInsets.all(4),
                        constraints: const BoxConstraints(),
                        onPressed: () async {
                          await notifier.duplicateCv(cv.id);
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(context.tr('duplicate_success'))),
                            );
                          }
                        },
                      ),
                      // Delete
                      IconButton(
                        visualDensity: VisualDensity.compact,
                        tooltip: context.tr('delete'),
                        icon: const Icon(Icons.delete_outline, size: 18, color: Color(0xFFDC2626)),
                        padding: const EdgeInsets.all(4),
                        constraints: const BoxConstraints(),
                        onPressed: () async {
                          final confirm = await ConfirmDialog.show(
                            context,
                            title: context.tr('delete_cv_title'),
                            content: context.tr('delete_cv_confirm'),
                            isDestructive: true,
                          );
                          if (confirm) {
                            await notifier.deleteCv(cv.id);
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(context.tr('delete_success'))),
                              );
                            }
                          }
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
