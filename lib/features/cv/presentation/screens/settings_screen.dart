import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/localization/app_locale.dart';
import '../../../../core/localization/app_localizations.dart';
import '../providers/settings_provider.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    final settingsNotifier = ref.read(settingsProvider.notifier);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(context.tr('settings_title')),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 800),
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
            children: [
              // 1. Interface Language Section
              _buildSectionCard(
                context,
                title: context.tr('interface_language'),
                subtitle: context.tr('interface_language_desc'),
                icon: Icons.language,
                child: Column(
                  children: AppLanguage.values.map((lang) {
                    final isSelected = lang == settings.appLanguage;
                    return Card(
                      elevation: isSelected ? 1.5 : 0,
                      color: isSelected ? theme.colorScheme.primaryContainer.withValues(alpha: 0.4) : null,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(
                          color: isSelected
                              ? theme.colorScheme.primary
                              : theme.colorScheme.outlineVariant.withValues(alpha: 0.5),
                          width: isSelected ? 2 : 1,
                        ),
                      ),
                      margin: const EdgeInsets.only(bottom: 10),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(12),
                        onTap: () => settingsNotifier.setLanguage(lang),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          child: Row(
                            children: [
                              Radio<AppLanguage>(
                                value: lang,
                                groupValue: settings.appLanguage,
                                onChanged: (val) {
                                  if (val != null) settingsNotifier.setLanguage(val);
                                },
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      lang.nativeName,
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                                        color: isSelected ? theme.colorScheme.primary : null,
                                      ),
                                    ),
                                    Text(
                                      lang.englishName,
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: theme.colorScheme.onSurfaceVariant,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              // Direction Tag Badge
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: lang.isRtl
                                      ? Colors.amber.withValues(alpha: 0.15)
                                      : Colors.blue.withValues(alpha: 0.15),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  lang.isRtl ? context.tr('direction_rtl') : context.tr('direction_ltr'),
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    color: lang.isRtl ? Colors.amber.shade900 : Colors.blue.shade900,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 16),

              // Notice on Independence of Interface & CV Languages
              Card(
                color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.4),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5)),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Icon(Icons.info_outline, color: theme.colorScheme.primary, size: 22),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Text(
                          context.tr('independent_lang_notice'),
                          style: TextStyle(
                            fontSize: 13,
                            color: theme.colorScheme.onSurfaceVariant,
                            height: 1.4,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // 2. Default CV Document Language Section
              _buildSectionCard(
                context,
                title: context.tr('cv_default_language'),
                subtitle: context.tr('cv_default_language_desc'),
                icon: Icons.description_outlined,
                child: Row(
                  children: [
                    _buildDefaultCvLangChoice(
                      context,
                      code: AppConstants.langEn,
                      label: 'English (LTR)',
                      selected: settings.defaultCvLanguage,
                      onTap: () => settingsNotifier.setDefaultCvLanguage(AppConstants.langEn),
                    ),
                    const SizedBox(width: 10),
                    _buildDefaultCvLangChoice(
                      context,
                      code: AppConstants.langFr,
                      label: 'Français (LTR)',
                      selected: settings.defaultCvLanguage,
                      onTap: () => settingsNotifier.setDefaultCvLanguage(AppConstants.langFr),
                    ),
                    const SizedBox(width: 10),
                    _buildDefaultCvLangChoice(
                      context,
                      code: AppConstants.langAr,
                      label: 'العربية (RTL)',
                      selected: settings.defaultCvLanguage,
                      onTap: () => settingsNotifier.setDefaultCvLanguage(AppConstants.langAr),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // 3. Theme & Appearance Section
              _buildSectionCard(
                context,
                title: context.tr('theme_mode'),
                subtitle: '',
                icon: Icons.palette_outlined,
                child: SegmentedButton<ThemeMode>(
                  segments: [
                    ButtonSegment(
                      value: ThemeMode.system,
                      label: Text(context.tr('theme_system')),
                      icon: const Icon(Icons.brightness_auto, size: 18),
                    ),
                    ButtonSegment(
                      value: ThemeMode.light,
                      label: Text(context.tr('theme_light')),
                      icon: const Icon(Icons.light_mode, size: 18),
                    ),
                    ButtonSegment(
                      value: ThemeMode.dark,
                      label: Text(context.tr('theme_dark')),
                      icon: const Icon(Icons.dark_mode, size: 18),
                    ),
                  ],
                  selected: {settings.themeMode},
                  onSelectionChanged: (set) {
                    if (set.isNotEmpty) {
                      settingsNotifier.setThemeMode(set.first);
                    }
                  },
                ),
              ),
              const SizedBox(height: 20),

              // 4. About & System Info
              _buildSectionCard(
                context,
                title: context.tr('about_app'),
                subtitle: '${AppConstants.appName} • ${context.tr("version")} ${AppConstants.appVersion}',
                icon: Icons.verified_user_outlined,
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.green.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.offline_pin, size: 16, color: Colors.green),
                          const SizedBox(width: 6),
                          Text(
                            context.tr('offline_storage_badge'),
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required Widget child,
  }) {
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: theme.colorScheme.primary, size: 22),
                const SizedBox(width: 10),
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ],
            ),
            if (subtitle.isNotEmpty) ...[
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: TextStyle(fontSize: 12, color: theme.colorScheme.onSurfaceVariant),
              ),
            ],
            const SizedBox(height: 16),
            child,
          ],
        ),
      ),
    );
  }

  Widget _buildDefaultCvLangChoice(
    BuildContext context, {
    required String code,
    required String label,
    required String selected,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);
    final isSelected = selected == code;

    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: isSelected ? theme.colorScheme.primary : theme.colorScheme.outlineVariant,
              width: isSelected ? 2 : 1,
            ),
            color: isSelected ? theme.colorScheme.primary.withValues(alpha: 0.08) : null,
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              color: isSelected ? theme.colorScheme.primary : null,
            ),
          ),
        ),
      ),
    );
  }
}
