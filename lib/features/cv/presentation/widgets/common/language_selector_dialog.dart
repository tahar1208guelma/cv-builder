import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../core/localization/app_locale.dart';
import '../../../../../core/localization/app_localizations.dart';
import '../../providers/settings_provider.dart';

class LanguageSelectorDialog extends ConsumerWidget {
  const LanguageSelectorDialog({super.key});

  static Future<void> show(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (ctx) => const LanguageSelectorDialog(),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentLang = ref.watch(settingsProvider).appLanguage;

    return AlertDialog(
      title: Row(
        children: [
          const Icon(Icons.language, size: 22),
          const SizedBox(width: 8),
          Text(context.tr('language')),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: AppLanguage.values.map((lang) {
          final isSelected = lang == currentLang;
          return RadioListTile<AppLanguage>(
            value: lang,
            groupValue: currentLang,
            title: Text(
              lang.nativeName,
              style: TextStyle(
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
            subtitle: Text(lang.englishName),
            secondary: Text(
              lang.code.toUpperCase(),
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            onChanged: (newLang) {
              if (newLang != null) {
                ref.read(settingsProvider.notifier).setLanguage(newLang);
                Navigator.of(context).pop();
              }
            },
          );
        }).toList(),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(context.tr('close')),
        ),
      ],
    );
  }
}
