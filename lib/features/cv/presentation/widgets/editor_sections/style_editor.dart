import 'package:flutter/material.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/localization/app_localizations.dart';
import '../../../../pdf_export/templates/cv_template_registry.dart';
import '../../../domain/models/cv_style.dart';

class StyleEditor extends StatelessWidget {
  final CvStyle style;
  final String cvLanguage;
  final ValueChanged<CvStyle> onStyleChanged;
  final ValueChanged<String> onLanguageChanged;

  const StyleEditor({
    super.key,
    required this.style,
    required this.cvLanguage,
    required this.onStyleChanged,
    required this.onLanguageChanged,
  });

  @override
  Widget build(BuildContext context) {
    final primaryTemplates = CvTemplateRegistry.getPrimaryTemplates();
    final legacyTemplates = CvTemplateRegistry.getAllTemplates().where((t) => !t.isPrimary).toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.tr('section_style'),
            style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          // CV Document Language Card
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.language, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        context.tr('cv_language_setting'),
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    context.tr('cv_language_disclaimer'),
                    style: TextStyle(fontSize: 12, color: Theme.of(context).colorScheme.onSurfaceVariant),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      _buildLangChoice(context, 'en', 'English (LTR)'),
                      const SizedBox(width: 10),
                      _buildLangChoice(context, 'fr', 'Français (LTR)'),
                      const SizedBox(width: 10),
                      _buildLangChoice(context, 'ar', 'العربية (RTL)'),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          // Template Selection Card
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    context.tr('template_selection'),
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 14),
                  ...primaryTemplates.map((def) => Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: _buildTemplateItem(
                      context,
                      id: def.id,
                      title: context.tr(def.titleKey),
                      desc: context.tr(def.descriptionKey),
                      icon: def.icon,
                    ),
                  )),
                  if (legacyTemplates.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Theme(
                      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                      child: ExpansionTile(
                        initiallyExpanded: legacyTemplates.any((t) => t.id == style.templateId),
                        tilePadding: EdgeInsets.zero,
                        childrenPadding: const EdgeInsets.only(top: 8),
                        title: Text(
                          context.tr('more_templates'),
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                        children: legacyTemplates.map((def) => Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: _buildTemplateItem(
                            context,
                            id: def.id,
                            title: context.tr(def.titleKey),
                            desc: context.tr(def.descriptionKey),
                            icon: def.icon,
                          ),
                        )).toList(),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          // Color Palette Card
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    context.tr('color_palette'),
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 14),
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: AppColors.presetCvColors.map((item) {
                      final hex = item['hex'] as String;
                      final color = item['color'] as Color;
                      final isSelected = style.primaryColorHex.toLowerCase() == hex.toLowerCase();

                      return InkWell(
                        onTap: () {
                          onStyleChanged(style.copyWith(primaryColorHex: hex));
                        },
                        borderRadius: BorderRadius.circular(24),
                        child: Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: color,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: isSelected ? Colors.white : Colors.transparent,
                              width: 3,
                            ),
                            boxShadow: isSelected
                                ? [
                                    BoxShadow(
                                      color: color.withValues(alpha: 0.6),
                                      blurRadius: 8,
                                      spreadRadius: 2,
                                    ),
                                  ]
                                : null,
                          ),
                          child: isSelected
                              ? const Icon(Icons.check, color: Colors.white, size: 22)
                              : null,
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLangChoice(BuildContext context, String code, String label) {
    final isSelected = cvLanguage == code;
    return Expanded(
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          backgroundColor: isSelected ? Theme.of(context).colorScheme.primaryContainer : null,
          side: BorderSide(
            color: isSelected ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.outline,
            width: isSelected ? 2 : 1,
          ),
          padding: const EdgeInsets.symmetric(vertical: 12),
        ),
        onPressed: () => onLanguageChanged(code),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            color: isSelected ? Theme.of(context).colorScheme.onPrimaryContainer : null,
            fontSize: 13,
          ),
        ),
      ),
    );
  }

  Widget _buildTemplateItem(
    BuildContext context, {
    required String id,
    required String title,
    required String desc,
    required IconData icon,
  }) {
    final isSelected = style.templateId == id;
    final primary = Theme.of(context).colorScheme.primary;

    return InkWell(
      onTap: () => onStyleChanged(style.copyWith(templateId: id)),
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? primary : Theme.of(context).colorScheme.outline.withValues(alpha: 0.5),
            width: isSelected ? 2 : 1,
          ),
          color: isSelected ? primary.withValues(alpha: 0.05) : null,
        ),
        child: Row(
          children: [
            Icon(icon, size: 32, color: isSelected ? primary : Theme.of(context).colorScheme.outline),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      color: isSelected ? primary : null,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    desc,
                    style: TextStyle(
                      fontSize: 12,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected) Icon(Icons.check_circle, color: primary, size: 22),
          ],
        ),
      ),
    );
  }
}
