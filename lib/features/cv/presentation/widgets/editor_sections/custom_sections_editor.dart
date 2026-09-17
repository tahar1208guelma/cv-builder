import 'package:flutter/material.dart';
import '../../../../../core/localization/app_localizations.dart';
import '../../../domain/models/custom_section.dart';
import '../common/repeatable_entry_card.dart';

class CustomSectionsEditor extends StatelessWidget {
  final List<CustomSection> customSections;
  final ValueChanged<List<CustomSection>> onChanged;

  const CustomSectionsEditor({
    super.key,
    required this.customSections,
    required this.onChanged,
  });

  void _addSection(BuildContext context) {
    final titleCtrl = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(context.tr('add_custom_section')),
        content: TextField(
          controller: titleCtrl,
          decoration: InputDecoration(
            labelText: context.tr('custom_section_title'),
            hintText: context.tr('custom_section_hint'),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(context.tr('cancel')),
          ),
          ElevatedButton(
            onPressed: () {
              final title = titleCtrl.text.trim();
              if (title.isNotEmpty) {
                final updated = List<CustomSection>.from(customSections)
                  ..add(CustomSection(title: title));
                onChanged(updated);
              }
              Navigator.of(ctx).pop();
            },
            child: Text(context.tr('add')),
          ),
        ],
      ),
    );
  }

  void _editSectionTitle(BuildContext context, int sectionIndex) {
    final section = customSections[sectionIndex];
    final titleCtrl = TextEditingController(text: section.title);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(context.tr('edit')),
        content: TextField(
          controller: titleCtrl,
          decoration: InputDecoration(labelText: context.tr('custom_section_title')),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.of(ctx).pop(), child: Text(context.tr('cancel'))),
          ElevatedButton(
            onPressed: () {
              final title = titleCtrl.text.trim();
              if (title.isNotEmpty) {
                final updated = List<CustomSection>.from(customSections);
                updated[sectionIndex] = section.copyWith(title: title);
                onChanged(updated);
              }
              Navigator.of(ctx).pop();
            },
            child: Text(context.tr('save')),
          ),
        ],
      ),
    );
  }

  void _deleteSection(int index) {
    final updated = List<CustomSection>.from(customSections)..removeAt(index);
    onChanged(updated);
  }

  void _addItem(BuildContext context, int sectionIndex, {CustomSectionItem? existingItem, int? itemIndex}) {
    final tCtrl = TextEditingController(text: existingItem?.title ?? '');
    final sCtrl = TextEditingController(text: existingItem?.subtitle ?? '');
    final dCtrl = TextEditingController(text: existingItem?.date ?? '');
    final descCtrl = TextEditingController(text: existingItem?.description ?? '');

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(existingItem == null ? context.tr('add_custom_item') : context.tr('edit')),
        content: SizedBox(
          width: 450,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: tCtrl, decoration: InputDecoration(labelText: context.tr('custom_item_title'))),
              const SizedBox(height: 10),
              TextField(controller: sCtrl, decoration: InputDecoration(labelText: context.tr('custom_item_subtitle'))),
              const SizedBox(height: 10),
              TextField(controller: dCtrl, decoration: InputDecoration(labelText: context.tr('custom_item_date'))),
              const SizedBox(height: 10),
              TextField(controller: descCtrl, maxLines: 2, decoration: InputDecoration(labelText: context.tr('custom_item_desc'))),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.of(ctx).pop(), child: Text(context.tr('cancel'))),
          ElevatedButton(
            onPressed: () {
              final item = CustomSectionItem(
                id: existingItem?.id,
                title: tCtrl.text.trim(),
                subtitle: sCtrl.text.trim(),
                date: dCtrl.text.trim(),
                description: descCtrl.text.trim(),
              );
              final section = customSections[sectionIndex];
              final updatedItems = List<CustomSectionItem>.from(section.items);
              if (itemIndex != null) {
                updatedItems[itemIndex] = item;
              } else {
                updatedItems.add(item);
              }
              final updatedSections = List<CustomSection>.from(customSections);
              updatedSections[sectionIndex] = section.copyWith(items: updatedItems);
              onChanged(updatedSections);
              Navigator.of(ctx).pop();
            },
            child: Text(context.tr('save')),
          ),
        ],
      ),
    );
  }

  void _moveItem(int sectionIndex, int fromIdx, int toIdx) {
    final section = customSections[sectionIndex];
    if (toIdx < 0 || toIdx >= section.items.length) return;
    final updatedItems = List<CustomSectionItem>.from(section.items);
    final item = updatedItems.removeAt(fromIdx);
    updatedItems.insert(toIdx, item);
    final updatedSections = List<CustomSection>.from(customSections);
    updatedSections[sectionIndex] = section.copyWith(items: updatedItems);
    onChanged(updatedSections);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(
                    context.tr('section_custom'),
                    style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '${customSections.length}',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.onPrimaryContainer,
                      ),
                    ),
                  ),
                ],
              ),
              ElevatedButton.icon(
                onPressed: () => _addSection(context),
                icon: const Icon(Icons.add, size: 18),
                label: Text(context.tr('add_custom_section')),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (customSections.isEmpty)
            Card(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Center(
                  child: Text(
                    context.tr('no_custom_sections'),
                    style: TextStyle(color: theme.colorScheme.onSurfaceVariant),
                  ),
                ),
              ),
            )
          else
            ...customSections.asMap().entries.map((secEntry) {
              final sIdx = secEntry.key;
              final section = secEntry.value;

              return Card(
                margin: const EdgeInsets.only(bottom: 16),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Text(
                                section.title,
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                              const SizedBox(width: 6),
                              IconButton(
                                visualDensity: VisualDensity.compact,
                                padding: EdgeInsets.zero,
                                icon: const Icon(Icons.edit_outlined, size: 16),
                                tooltip: context.tr('edit'),
                                onPressed: () => _editSectionTitle(context, sIdx),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              TextButton.icon(
                                onPressed: () => _addItem(context, sIdx),
                                icon: const Icon(Icons.add, size: 16),
                                label: Text(context.tr('add_custom_item')),
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete_outline, size: 20, color: Color(0xFFDC2626)),
                                onPressed: () => _deleteSection(sIdx),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const Divider(),
                      if (section.items.isEmpty)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Text(context.tr('no_items_in_section'), style: TextStyle(color: theme.colorScheme.outline)),
                        )
                      else
                        ...section.items.asMap().entries.map((itemEntry) {
                          final item = itemEntry.value;
                          final iIdx = itemEntry.key;

                          return RepeatableEntryCard(
                            index: iIdx,
                            totalCount: section.items.length,
                            title: item.title.isNotEmpty ? item.title : context.tr('untitled_entry'),
                            subtitle: item.subtitle,
                            date: item.date,
                            onEdit: () => _addItem(context, sIdx, existingItem: item, itemIndex: iIdx),
                            onDelete: () {
                              final updatedItems = List<CustomSectionItem>.from(section.items)..removeAt(iIdx);
                              final updatedSections = List<CustomSection>.from(customSections);
                              updatedSections[sIdx] = section.copyWith(items: updatedItems);
                              onChanged(updatedSections);
                            },
                            onMoveUp: () => _moveItem(sIdx, iIdx, iIdx - 1),
                            onMoveDown: () => _moveItem(sIdx, iIdx, iIdx + 1),
                          );
                        }),
                    ],
                  ),
                ),
              );
            }),
        ],
      ),
    );
  }
}
